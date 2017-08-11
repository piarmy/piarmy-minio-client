FROM armhf/alpine

RUN apk update && apk upgrade && \
  apk add --no-cache \
  sudo bash curl nmap

RUN curl -o /home/mc https://dl.minio.io/client/mc/release/linux-arm/mc && \
  chmod +x /home/mc

WORKDIR /home

CMD ["tail", "-f", "/dev/null"]