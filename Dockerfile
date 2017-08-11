FROM armhf/alpine

RUN apk update && apk upgrade && \
  apk add --no-cache \
  sudo bash curl nmap jq

RUN curl -o /home/mc https://dl.minio.io/client/mc/release/linux-arm/mc && \
  mv /home/mc /usr/bin/mc && \
  chmod +x /usr/bin/mc

WORKDIR /home

CMD ["tail", "-f", "/dev/null"]