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
