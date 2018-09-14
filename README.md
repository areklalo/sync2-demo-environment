# sync2-demo-environment

# Description
Run openmrs distributions and mysql as docker containers.

## Requirements
  - Docker engine
  - Docker compose

## Development

To start containers:
```
$ docker-compose up
```

Application will be accessible on:
* parent - http://localhost:8086/openmrs
* child1 - http://localhost:8088/openmrs
* child2 - http://localhost:8087/openmrs

If you made any changes (modified modules/owas/war) to the distro run:
```
$ docker-compose up --build
```

If you want to destroy containers and delete any left over volumes and data when doing changes to the docker
configuration and images run:
```
$ docker-compose down -v
```
