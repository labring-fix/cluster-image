#!/bin/bash

set -eu

readonly ARCH=${arch:-}
readonly IMAGE_NAME=${app?}
readonly IMAGE_TAG=${version?}
readonly IMAGE_HUB_REGISTRY=${registry?}
readonly IMAGE_HUB_REPO=${repo?}
readonly IMAGE_HUB_USERNAME=${username?}
readonly IMAGE_HUB_PASSWORD=${password?}
readonly IMAGE_NAME_FULL=${IMAGE_HUB_REGISTRY}/${IMAGE_HUB_REPO}/${IMAGE_NAME}:${IMAGE_TAG}

# for host action ,Don't delete this code
sudo docker rmi "$IMAGE_NAME_FULL" || true
set -ex

# NOTE: use buildx imagetools instead of legacy `docker manifest create`.
# buildx pushes single-arch images as OCI indexes, which the legacy
# manifest command cannot combine (it fails silently with exit 1).
# imagetools works straight from the registry, so no local pulls needed.
sudo docker login -u "$IMAGE_HUB_USERNAME" -p "$IMAGE_HUB_PASSWORD" "$IMAGE_HUB_REGISTRY"
case $ARCH in
amd64 | arm64)
  sudo docker buildx imagetools create -t "$IMAGE_NAME_FULL" "$IMAGE_NAME_FULL-$ARCH"
  ;;
*)
  sudo docker buildx imagetools create -t "$IMAGE_NAME_FULL" "$IMAGE_NAME_FULL-amd64" "$IMAGE_NAME_FULL-arm64"
  ;;
esac
sudo docker buildx imagetools inspect "$IMAGE_NAME_FULL"

# for host action ,Don't delete this code
sudo docker rmi "$IMAGE_NAME_FULL" || true
