#!/bin/bash

set -e

readonly ARCH=${1:-amd64}
readonly NAME=${2:-cni-plugins}
VERSION=${3:-v1.1.1}

# "latest" is not a real release tag on GitHub, so a download URL built
# with it 404s (wget exit 8). Resolve it to the actual latest tag first.
if [ "$VERSION" = "latest" ]; then
  VERSION=$(curl -s https://api.github.com/repos/containernetworking/plugins/releases/latest | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -1)
fi

wget -qO cni-plugins.tgz "https://github.com/containernetworking/plugins/releases/download/$VERSION/$NAME-linux-$ARCH-$VERSION.tgz"
