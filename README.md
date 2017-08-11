# piarmy-minio-client

#### Start service
```
docker service create \
  --name=piarmy-minio-client \
  --network=piarmy \
  --constraint=node.role==manager \
  mattwiater/piarmy-minio-client:latest
```

#### Enter container

`docker exec -it $(docker ps | grep piarmy-minio-client | awk '{print $1}') /bin/ash`

#### Add minio host

`./mc config host add minio1 http://minio1:9000 piarmyPIARMY PIARMYpiarmy S3v4`

#### List buckets

`./mc ls minio1`

JSON output: `./mc --json ls minio1`

#### List bucket contents

`./mc ls minio1/trailers`

JSON output: `./mc --json ls minio1`