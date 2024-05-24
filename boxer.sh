boxer() {
  docker run -it --rm --mount type=bind,source="$(pwd)",target=/host --hostname boxer-"$1" "$1":latest "${@:2}"
}
