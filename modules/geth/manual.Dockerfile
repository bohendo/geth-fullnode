FROM alpine:3.8
WORKDIR /root
ENV HOME /root
ENV VERSION v1.8.20

# install build tools, download source code, and build
RUN apk add --update --no-cache --virtual build-tools \
    gcc git go linux-headers make musl-dev openssl \
 && git clone --progress https://github.com/ethereum/go-ethereum.git /go-ethereum \
 && cd /go-ethereum \
 && git checkout $VERSION \
 && make geth \
 && cp /go-ethereum/build/bin/geth /usr/local/bin/ \
 && cd $HOME \
 && rm -rf /go-ethereum \
 && apk del build-tools \
 && apk add --update --no-cache ca-certificates

COPY entry.sh entry.sh

EXPOSE 8545 8546 30303 30303/udp

ENTRYPOINT ["sh", "entry.sh"]