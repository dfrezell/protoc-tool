FROM golang:1.19-bullseye

LABEL description="Provide protoc for golang, twirp and protolint."

WORKDIR /app

RUN apt-get update -y && \
    apt-get install -y \
        unzip \
    && rm -rf /var/lib/apt/lists/*

ENV PATH=$PATH:/usr/local/protoc/bin:/usr/local/protolint

ARG PROTOC_VERSION
ENV PROTOC_VERSION=${PROTOC_VERSION:-21.6}
ENV PROTOC_ZIP=protoc-${PROTOC_VERSION}-linux-x86_64.zip
RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/${PROTOC_ZIP}
RUN mkdir -p /usr/local/protoc && unzip -o ${PROTOC_ZIP} -d /usr/local/protoc

ARG PROTOLINT_VERSION
ENV PROTOLINT_VERSION=${PROTOLINT_VERSION:-0.40.0}
ENV PROTOLINT_TGZ=protolint_${PROTOLINT_VERSION}_Linux_x86_64.tar.gz
RUN curl -LO https://github.com/yoheimuta/protolint/releases/download/v${PROTOLINT_VERSION}/${PROTOLINT_TGZ}
RUN mkdir -p /usr/local/protolint && tar -C /usr/local/protolint -zxvf ${PROTOLINT_TGZ}

ARG PROTOC_GEN_TWIRP_VERSION
ENV PROTOC_GEN_TWIRP_VERSION=${PROTOC_GEN_TWIRP_VERSION:-8.1.2}
RUN go install github.com/twitchtv/twirp/protoc-gen-twirp@v${PROTOC_GEN_TWIRP_VERSION}

ARG PROTOC_GEN_GO_VERSION
ENV PROTOC_GEN_GO_VERSION=${PROTOC_GEN_GO_VERSION:-1.28.1}
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v${PROTOC_GEN_GO_VERSION}

ENTRYPOINT [ "protoc" ]
