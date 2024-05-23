# 🥊 boxer

Instantly launch any operating system or Docker image from your terminal. No installation required - just add a single function to your `.bashrc` or `.zshrc` file.

## Key Features

* Launches an interactive Docker container running the specified OS or image
* Automatically removes the container after use
* Includes a bind mount to your current working directory in `/host`
* No additional software required
* Probably works with `podman` using an alias (untested)

⚠️ *`boxer` always pulls the latest version of an image. At this time, you cannot specify a tag for an image.* ⚠️

## Setup

Add the following code to your `.bashrc` or `.zshrc` file, then restart your terminal:

```bash
boxer() {
  docker run -it --rm --mount type=bind,source="$(pwd)",target=/host --hostname boxer-"$1" "$1":latest "${@:2}"
}
```

## Usage and Examples

```
boxer <image_name> [command]
```

### Whip up an Ubuntu container:

```
boxer ubuntu
```

### Drop into a shell within the node image:

```
boxer node bash
```
