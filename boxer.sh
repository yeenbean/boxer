boxer() {
  # setup vars
  BACKEND="docker" #you can change this to podman or nerdctl if you wish
  IMAGE=$1
  IFS=':' read -r IMAGE_NAME IMAGE_VERSION <<< "$IMAGE"

  if [ -z "${IMAGE_VERSION}" ]; then
    $BACKEND run -it --rm --mount type=bind,source="$(pwd)",target=/host --hostname "$0"-"$IMAGE_NAME" "$IMAGE_NAME" ${@:2}
  else
    $BACKEND run -it --rm --mount type=bind,source="$(pwd)",target=/host --hostname "$0"-"$IMAGE_NAME" "$IMAGE_NAME":"$IMAGE_VERSION" ${@:2}
  fi
}
