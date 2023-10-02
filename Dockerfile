# syntax=docker/dockerfile:experimental

# Define the Python version as an argument
ARG PYTHON_VERSION=3

# Base stage
FROM python:${PYTHON_VERSION}-slim as base

# Environment optimizations
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /mojo

# TODO: Install and run Mojo in a non-privileged user.
# Create a non-privileged user
# ARG UID=10001
# RUN adduser \
#     --disabled-password \
#     --gecos "" \
#     --home "/nonexistent" \
#     --shell "/sbin/nologin" \
#     --no-create-home \
#     --uid "${UID}" \
#     appuser

# Setup the authentication environment for downloading mojo
ARG MODULAR_AUTH
ENV MODULAR_AUTH=${MODULAR_AUTH}

# Install Modular and mojo using a secret for MODULAR_AUTH
RUN --mount=type=secret,id=modular_auth \
    export MODULAR_AUTH=$(cat /run/secrets/modular_auth) && \
    apt-get update && \
    apt-get full-upgrade -y && \
    apt-get install -y --no-install-recommends curl libedit2 && \
    curl https://get.modular.com | bash - && \
    modular install mojo && \
    apt-get autoremove -y && \
    apt-get clean

# Cleanup pip cache and build artifacts
RUN rm -rf /root/.cache/pip \
    && rm -rf /root/.modular/pkg/packages.modular.com_mojo/build

# Setup the environment for running mojo
ARG MODULAR_HOME=/root/.modular
ARG MOJO_HOME=$MODULAR_HOME/pkg/packages.modular.com_mojo
RUN echo "export MODULAR_HOME=\"$MODULAR_HOME\"" >> ~/.bashrc \
    && echo "export PATH=\"$MOJO_HOME/bin:\$PATH\"" >> ~/.bashrc

# Erase the authentication environment variables
RUN unset MODULAR_AUTH \
    && modular config-set user.id 'undefined'

# Switch to the non-privileged user
# USER appuser

# Prevent container termination after running and set default command to mojo
ENV MOJO_HOME=$MOJO_HOME
CMD ["/bin/bash", "-c", "$MOJO_HOME/bin/mojo"]
