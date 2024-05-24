boxer() {
  # setup vars
  IMAGE=$1
  IFS=':' read -r IMAGE_NAME IMAGE_VERSION <<< "$IMAGE"

  docker run -it --rm --mount type=bind,source="$(pwd)",target=/host --hostname "$0"-"$IMAGE_NAME" "$IMAGE_NAME":"$IMAGE_VERSION" ${@:2}
}
