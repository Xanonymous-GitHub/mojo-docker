# Mojo Docker Image

This Docker image encapsulates the Mojo setup to provide a straightforward and isolated environment for running Mojo
applications. You can either pull the pre-built image from Docker Hub or build the image yourself.

## Using Pre-built Image

The Mojo Docker image is available on Docker Hub under the repository `xanonymous/mojo`. You can pull and use this image
by running the following command:

```bash
docker run -it xanonymous/mojo
```

## Building The Image Yourself

If you prefer to build the image yourself, you can do so using the provided `Dockerfile`. You will need to provide your
Modular authentication key via the `mojo_auth_key` file. Here's the command to build the image:

```bash
DOCKER_BUILDKIT=1 docker build --secret id=modular_auth,src=./mojo_auth_key -t mojo .
```

Replace the example key in the key file with your actual Modular authentication key.

Once the image is built, you can run a container from it using the following command:

```bash
docker run -it mojo
```

This will provide you with an isolated environment for running Mojo applications.

## Contributing

Feel free to contribute to the development of this Docker image by submitting issues or pull requests on the repository
hosting this Dockerfile.
