boxer() {
  # setup vars
  BOXER_VERSION=25.1.9c
  BACKEND="docker" #you can change this to podman or nerdctl if you wish
  BOXER_NAME=$0
  IMAGE=$1
  IFS=':' read -r IMAGE_NAME IMAGE_VERSION <<< "$IMAGE"

  # print info about boxer
  echo "$BOXER_NAME $BOXER_VERSION"

  # check if container exists and remove it if so
  if $BACKEND inspect "$BOXER_NAME-$IMAGE_NAME" > /dev/null 2>&1; then
    $BACKEND rm "$BOXER_NAME-$IMAGE_NAME" > /dev/null || {
      echo Failed to remove existing container $BOXER_NAME-$IMAGE_NAME.
      echo You may need to remove it manually before running boxer.
      exit(1)
    }
  fi

  # create the container
  echo "creating ephemeral container $BOXER_NAME-$IMAGE_NAME..."
  $BACKEND create -it --mount type=bind,source="$(pwd)",target=/host --workdir /host --hostname "$BOXER_NAME"-"$IMAGE_NAME" --name "$BOXER_NAME"-"$IMAGE_NAME" --entrypoint "/bin/sh" "$IMAGE" > /dev/null || {
    echo Failed to create the container.
    exit(1)
  }
  #echo "bind mount created at $(pwd)."

  # attach to container
  #echo "entering $BOXER_NAME-$IMAGE_NAME..."
  if [ "$IMAGE_NAME" = "debian" ] || [ "$IMAGE_NAME" = "ubuntu" ]; then
    $BACKEND start -i -a "$BOXER_NAME-$IMAGE_NAME"  # maybe switch to bash since these images include it
  else
    $BACKEND start -i -a "$BOXER_NAME-$IMAGE_NAME"
  fi

  # remove the container
  $BACKEND rm "$BOXER_NAME-$IMAGE_NAME" > /dev/null || {
    echo Failed to remove the container. You may need to remove it manually.
  }
  echo removed $BOXER_NAME-$IMAGE_NAME
  echo bye!
}
