FROM debian:bookworm-slim

USER root

ARG ARCH=amd64

RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates \
    && KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable-1.31.txt) \
    && curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl" \
    && install -m 0755 kubectl /usr/local/bin/kubectl \
    && rm -f kubectl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

USER 1001

CMD [ "kubectl" ]
