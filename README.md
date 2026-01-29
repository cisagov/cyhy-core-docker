# cyhy-core-docker 💀🐳 #

[![GitHub Build Status](https://github.com/cisagov/cyhy-core-docker/workflows/build/badge.svg)](https://github.com/cisagov/cyhy-core-docker/actions/workflows/build.yml)
[![License](https://img.shields.io/github/license/cisagov/cyhy-core-docker)](https://spdx.org/licenses/)
[![CodeQL](https://github.com/cisagov/cyhy-core-docker/workflows/CodeQL/badge.svg)](https://github.com/cisagov/cyhy-core-docker/actions/workflows/codeql-analysis.yml)

## Docker Image ##

[![Docker Pulls](https://img.shields.io/docker/pulls/cisagov/cyhy-core)](https://hub.docker.com/r/cisagov/cyhy-core)
[![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/cisagov/cyhy-core)](https://hub.docker.com/r/cisagov/cyhy-core)
[![Platforms](https://img.shields.io/badge/platforms-amd64-blue)](https://hub.docker.com/r/cisagov/cyhy-core/tags)

This is a containerization of the [cisagov/cyhy-core] project to serve as a
base image for other Cyber Hygiene containerization projects.

## Running ##

### Running with Docker ###

To run the `cisagov/cyhy-core` image via Docker:

```console
docker run cisagov/cyhy-core:1.2.0
```

### Running with Docker Compose ###

1. Create a `compose.yml` file similar to the one below to use [Docker Compose](https://docs.docker.com/compose/).

    ```yaml
    ---
    name: cyhy-core

    services:
      cyhy-core:
        image: cisagov/cyhy-core:1.2.0
        volumes:
          - source: <your_cyhy_conf_dir>
            target: /etc/cyhy
            type: bind
          - source: <your_maxmind_db_dir>
            target: /usr/local/share/GeoIP
            type: bind
    ```

1. Start the container and detach:

    ```console
    docker compose up --detach
    ```

## Updating your container ##

### Docker Compose ###

1. Pull the new image from Docker Hub:

    ```console
    docker compose pull
    ```

1. Recreate the running container by following the [previous instructions](#running-with-docker-compose):

    ```console
    docker compose up --detach
    ```

### Docker ###

1. Stop the running container:

    ```console
    docker stop <container_id>
    ```

1. Pull the new image:

    ```console
    docker pull cisagov/cyhy-core:1.2.0
    ```

1. Recreate and run the container by following the [previous instructions](#running-with-docker).

## Image tags ##

The images of this container are tagged with [semantic
versions](https://semver.org) of the underlying example project that they
containerize.  It is recommended that most users use a version tag (e.g.
`:1.2.0`).

| Image:tag | Description |
|-----------|-------------|
|`cisagov/cyhy-core:1.2.0`| An exact release version. |
|`cisagov/cyhy-core:1.2`| The most recent release matching the major and minor version numbers. |
|`cisagov/cyhy-core:1`| The most recent release matching the major version number. |
|`cisagov/cyhy-core:edge` | The most recent image built from a merge into the `develop` branch of this repository. |
|`cisagov/cyhy-core:nightly` | A nightly build of the `develop` branch of this repository. |
|`cisagov/cyhy-core:latest`| The most recent release image pushed to a container registry.  Pulling an image using the `:latest` tag [should be avoided.](https://vsupalov.com/docker-latest-tag/) |

See the [tags tab](https://hub.docker.com/r/cisagov/cyhy-core/tags) on Docker
Hub for a list of all the supported tags.

## Volumes ##

| Mount point | Purpose        |
|-------------|----------------|
| `/etc/cyhy` | Contains the configuration file (`cyhy.conf`) |
| `/usr/local/share/GeoIP/` | Contains the MaxMind GeoIP2 database (`GeoIP2-City.mmdb` or `GeoLite2-City.mmdb`) |

## Ports ##

No ports are exposed by this container.

<!--
| Port | Purpose        |
|------|----------------|
| port_number | Describe the port's purpose. |
-->

## Environment variables ##

### Required ###

There are no required environment variables.

<!--
| Name  | Purpose | Default |
|-------|---------|---------|
| `REQUIRED_VARIABLE` | Describe its purpose. | `null` |
-->

### Optional ###

There are no optional environment variables.

<!--
| Name  | Purpose | Default |
|-------|---------|---------|
| `OPTIONAL_VARIABLE` | Describe its purpose.  | `null` |
-->

## Secrets ##

There are no secrets for the container.

<!--
| Filename     | Purpose |
|--------------|---------|
| `secret_filename.txt` | Describe the secret's purpose. |
-->

## Building from source ##

Build the image locally using this git repository as the [build context](https://docs.docker.com/engine/reference/commandline/build/#git-repositories):

```console
docker build \
  --tag cisagov/cyhy-core:1.2.0 \
  https://github.com/cisagov/cyhy-core.git#develop
```

## Cross-platform builds ##

To create images that are compatible with other platforms, you can use the
[`buildx`](https://docs.docker.com/buildx/working-with-buildx/) feature of
Docker:

1. Copy the project to your machine using the `Code` button above
   or the command line:

    ```console
    git clone https://github.com/cisagov/cyhy-core.git
    cd example
    ```

1. Create the `Dockerfile-x` file with `buildx` platform support:

    ```console
    ./buildx-dockerfile.sh
    ```

1. Build the image using `buildx`:

    ```console
    docker buildx build \
      --file Dockerfile-x \
      --platform linux/amd64 \
      --output type=docker \
      --tag cisagov/cyhy-core:1.2.0 .
    ```

## Contributing ##

We welcome contributions!  Please see [`CONTRIBUTING.md`](CONTRIBUTING.md) for
details.

## License ##

This project is in the worldwide [public domain](LICENSE).

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain
dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.

[cisagov/cyhy-core]: https://github.com/cisagov/cyhy-core
