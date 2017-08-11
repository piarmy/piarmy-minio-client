# piarmy-minio-client

#### This is currently in progress. This notice will be removed when ready for deployment and documentation is updated. Assume unusable nonsense below.

## Notes

#### Ref:

https://docs.minio.io/docs/minio-client-complete-guide

#### Start service
`make service`

#### Enter container

`docker exec -it $(docker ps | grep piarmy-minio-client | awk '{print $1}') /bin/ash`

#### Add minio hosts

```
mc config host add minio1 http://minio1:9000 piarmyPIARMY PIARMYpiarmy S3v4 && \
  mc config host add minio2 http://minio2:9000 piarmyPIARMY PIARMYpiarmy S3v4 && \
  mc config host add minio3 http://minio3:9000 piarmyPIARMY PIARMYpiarmy S3v4 && \
  mc config host add minio4 http://minio4:9000 piarmyPIARMY PIARMYpiarmy S3v4

```

#### List buckets

`mc ls minio1`

JSON output: `mc --json ls minio1`

#### List bucket contents

`mc ls minio1/trailers`

JSON output: `mc --json ls minio1/trailers`

#### Testing

Make a bucket: `mc mb minio1/piarmy-swarm`
Add a file: `echo "test!" | mc pipe minio1/piarmy-swarm/test.txt`
Check that the file uploaded top minio1 has been distributed:
```
mc ls minio1/piarmy-swarm && \
  mc ls minio2/piarmy-swarm && \
  mc ls minio3/piarmy-swarm && \
  mc ls minio4/piarmy-swarm
```

Read file contents: `mc cat minio1/piarmy-swarm/test.txt`

Share file: `mc share download --expire 4h minio1/piarmy-swarm/test.txt`

Output should be similar to:
```
Expire: 4 hours 0 minutes 0 seconds
Share: http://minio1:9000/piarmy-swarm/test.txt?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=piarmyPIARMY%2F20170811%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20170811T174133Z&X-Amz-Expires=14400&X-Amz-SignedHeaders=host&X-Amz-Signature=c5bc11c178e8192d282d04da34a0142eb797eca2473e681444171843ecabbde0
```

Add and share another file:
```
echo "test2!" | mc pipe minio1/piarmy-swarm/test2.txt && \
  mc share download --expire 4h minio1/piarmy-swarm/test2.txt

```

List download shares: `mc share --json list download`
Output should be similar to:
```
{"status":"success","url":"http://minio1:9000/piarmy-swarm/test.txt","share":"http://minio1:9000/piarmy-swarm/test.txt?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=piarmyPIARMY%2F20170811%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20170811T174133Z&X-Amz-Expires=14400&X-Amz-SignedHeaders=host&X-Amz-Signature=c5bc11c178e8192d282d04da34a0142eb797eca2473e681444171843ecabbde0","timeLeft":13986496078302}
{"status":"success","url":"http://minio1:9000/piarmy-swarm/test2.txt","share":"http://minio1:9000/piarmy-swarm/test2.txt?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=piarmyPIARMY%2F20170811%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20170811T174807Z&X-Amz-Expires=14400&X-Amz-SignedHeaders=host&X-Amz-Signature=98da5efe7985e45e90dc104132ffb019c3b73580a2e1e0cdfd1876bec7ceb7a0","timeLeft":14381315276732}
```

Search for file by name, get download link:
`mc share --json list download | grep test2.txt | jq .share`

Download file:
`mc share --json list download | grep test2.txt | jq .share | xargs curl -o test2.txt`

Remove local file: `rm test2.txt`



Remove minio files:

```
mc rm minio1/piarmy-swarm/test.txt && \
  mc rm minio1/piarmy-swarm/test2.txt
```

Remove a bucket: `mc rm minio1/piarmy-swarm`

