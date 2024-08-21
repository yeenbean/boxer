boxer() {
  # setup vars
  BOXER_VERSION=24.08.20
  BACKEND="docker" #you can change this to podman or nerdctl if you wish
  BOXER_NAME=$0
  IMAGE=$1
  IFS=':' read -r IMAGE_NAME IMAGE_VERSION <<< "$IMAGE"

  # print info about boxer
  echo "$BOXER_NAME $BOXER_VERSION"

  # check if container exists and create it if not
  if $BACKEND inspect "$BOXER_NAME-$IMAGE_NAME" > /dev/null 2>&1; then
    echo "using existing container."
    echo "you can start fresh by running $BACKEND rm $BOXER_NAME-$IMAGE_NAME."
  else
  echo "creating $BOXER_NAME-$IMAGE_NAME..."
    $BACKEND create -it --mount type=bind,source="$(pwd)",target=/host --hostname "$BOXER_NAME"-"$IMAGE_NAME" --name "$BOXER_NAME"-"$IMAGE_NAME" "$IMAGE"
    echo "bind mount created at $(pwd)."
    echo "bind mount will not update until you recreate the container."
  fi

  # attach to container
  echo "entering $BOXER_NAME-$IMAGE_NAME..."
  if [ "$IMAGE_NAME" = "debian" ] || [ "$IMAGE_NAME" = "ubuntu" ]; then
    $BACKEND start -i -a "$BOXER_NAME-$IMAGE_NAME"
  else
    $BACKEND start -i -a "$BOXER_NAME-$IMAGE_NAME"
  fi
}
