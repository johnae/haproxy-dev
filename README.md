### HAProxy sidekick container

This is mostly so I get db:s in other containers on localhost in some other container. Meant to be run something like this:

```
docker run -e FWD_PG='postgres-dev:5432' -e FWD_MONGO='mongo-dev:27017' --rm --net=container:some-container --name some-container-sidekick johnae/haproxy-dev
```

Basically, any env var with a name starting with "FWD" will be added to the haproxy config. The env vars are assumed to contain "ip-or-hostname:port".
