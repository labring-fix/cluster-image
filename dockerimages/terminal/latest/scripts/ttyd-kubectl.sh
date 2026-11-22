#!/bin/bash


to_download_arch() {
    case $ARCH in
        amd64)
            _ARCH=x86_64
            ;;
        arm64)
            _ARCH=aarch64
            ;;
        *)
            fatal "Unsupported architecture $ARCH"
    esac
}

to_download_arch
echo "download arch : $_ARCH"


wget https://storage.googleapis.com/kubernetes-release/release/v${kubeVersion}/bin/linux/${ARCH}/kubectl -O /usr/bin/kubectl && chmod a+x /usr/bin/kubectl
if [ $? != 0 ]; then
   echo "====download kubectl failed!===="
   exit 1
fi

wget https://github.com/labring/ttyd/releases/download/${ttydVersion}/ttyd.${_ARCH} && chmod +x ttyd.${_ARCH} && mv ttyd.${_ARCH} /usr/bin/ttyd
if [ $? != 0 ]; then
   echo "====download ttyd failed!===="
   exit 1
fi

wget -qO- "https://get.helm.sh/helm-v${helmVersion}-linux-$ARCH.tar.gz" | tar -zx "linux-$ARCH/helm" && chmod +x linux-$ARCH/helm && mv linux-$ARCH/helm /usr/bin/helm
if [ $? != 0 ]; then
   echo "====download helm failed!===="
   exit 1
fi

# dl.min.io returns 410 Gone for the mc download now, so fetch it from the
# minio/mc GitHub release instead (resolve the latest tag first).
MC_VERSION=$(curl -s https://api.github.com/repos/minio/mc/releases/latest | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -1)
wget "https://github.com/minio/mc/releases/download/${MC_VERSION}/mc.linux-${ARCH}.${MC_VERSION}" -O /usr/bin/mc && chmod a+x /usr/bin/mc
if [ $? != 0 ]; then
   echo "====download mc failed!===="
   exit 1
fi
