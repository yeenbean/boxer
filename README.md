# 🥊 Boxer

Instantly launch an ephemeral Docker container from your terminal with just one function in your `.bashrc` or `.zshrc` file.

![](./assets/demo.gif)

## Why?

I was inspired by [Distrobox](https://github.com/89luca89/distrobox?tab=readme-ov-file) and wanted to create a solution that works on macOS. Boxer creates **ephemeral** Linux environments for testing or other purpose, and is designed for developers, pentesters, and hobbyists alike.

**Boxer is not meant to replace Distrobox.** Instead, it provides a lightweight way to launch ephemeral containers of any Docker image.

### Differences between Distrobox and Boxer

**Boxer can...**

- Create and dismantle ephemeral containers of any Docker image
- Access files and folders from the directory where the container was launched

**Boxer cannot...**

- Leave containers running in the background
- Persist changes made to its containers (planned)
- Use Wayland or X11 sockets
- Use networking features (planned)
- Mount removable devices
- Tell you a love story

## Key Features

* Launches an interactive Docker container running the specified OS or image
* Automatically removes the container after use
* Includes a bind mount to your current working directory in `/host`
* Optionally run a specific command or shell in the container
* 🆕 Supports image tags
* No additional software required
* Likely works with `podman` using an alias (untested)

## Setup

Add this code to your `.bashrc` or `.zshrc` file, then restart your terminal:

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

Launch a container with the `boxer` command like this:

```
boxer <image_name>[:image_tag] [command]
```

Then, find the files from the directory in which you launched the container in
the bind mount location: `/host`.

### Examples

| Example | Command |
| ------- | ------- |
| Whip up an Ubuntu container | `boxer ubuntu` |
| Drop into a shell within the node image | `boxer node bash` |
| Target a specific image tag | `boxer rockylinux:9` |
