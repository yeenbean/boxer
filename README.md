# 🥊 Boxer

Instantly launch any operating system or Docker image from your terminal. No installation required - just add a single function to your `.bashrc` or `.zshrc` file.

![](./assets/demo.gif)

## Key Features

* Launches an interactive Docker container running the specified OS or image
* Automatically removes the container after use
* Includes a bind mount to your current working directory in `/host`
* Optionally run a specific command or shell in the container
* 🆕 Supports image tags
* No additional software required
* Likely works with `podman` using an alias (untested)

## Setup

Add the following code to your `.bashrc` or `.zshrc` file, then restart your terminal:

```bash
boxer() {
  # setup vars
  IMAGE=$1
  IFS=':' read -r IMAGE_NAME IMAGE_VERSION <<< "$IMAGE"

  if [ -z "${IMAGE_VERSION}" ]; then
    docker run -it --rm --mount type=bind,source="$(pwd)",target=/host --hostname "$0"-"$IMAGE_NAME" "$IMAGE_NAME" ${@:2}
  else
    docker run -it --rm --mount type=bind,source="$(pwd)",target=/host --hostname "$0"-"$IMAGE_NAME" "$IMAGE_NAME":"$IMAGE_VERSION" ${@:2}
  fi
}
```

## Usage and Examples

```
boxer <image_name>[:image_tag] [command]
```

### Whip up an Ubuntu container:

```
boxer ubuntu
```

### Drop into a shell within the node image:

```
boxer node bash
```

### Target a specific image tag

```
boxer rockylinux:9
```
