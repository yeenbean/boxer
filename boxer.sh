boxer() {
  # setup vars
  BOXER_VERSION=25.1.27
  BACKEND="docker" #you can change this to podman or nerdctl if you wish
  BOXER_NAME=$0
  IMAGE=$1
  IFS=':' read -r IMAGE_NAME IMAGE_VERSION <<< "$IMAGE"

  # print info about boxer
  echo "$BOXER_NAME $BOXER_VERSION"

  # check if container exists and remove it if so
  if $BACKEND inspect "$BOXER_NAME-$IMAGE_NAME" > /dev/null 2>&1; then
    echo "Sweeping the ring..."
    $BACKEND stop "$BOXER_NAME-$IMAGE_NAME" > /dev/null
    $BACKEND rm "$BOXER_NAME-$IMAGE_NAME" > /dev/null || {
      echo "failed to clean up the container: $BOXER_NAME-$IMAGE_NAME."
      echo "you may need to remove it manually."
      exit(1)
    }
  fi

  # create the container
  #echo "container: $BOXER_NAME-$IMAGE_NAME..."
  echo "Prepping the match..."
  $BACKEND create -it --mount type=bind,source="$(pwd)",target=/host --workdir /host --hostname "$BOXER_NAME"-"$IMAGE_NAME" --name "$BOXER_NAME"-"$IMAGE_NAME" --entrypoint "/bin/sh" "$IMAGE" > /dev/null || {
    echo "Boxer: something went wrong, sorry :("
    exit(1)
  }
  #echo "bind mount created at $(pwd)."

  # attach to container
  echo "Fighter $IMAGE_NAME enters the ring!"
  echo "They're up against $(whoami). Who will win?"
  echo "Round start..."
  echo
  $BACKEND start -i -a "$BOXER_NAME-$IMAGE_NAME"

  # remove the container
  $BACKEND rm "$BOXER_NAME-$IMAGE_NAME" > /dev/null || {
    echo "Failed to remove the container. You may need to remove it manually."
    exit(1)
  }
  echo
  echo "$IMAGE_NAME was KO'd!"
  echo "$(whoami) wins!"
  echo "See you next time."
}
