# sync2-demo-environment

# Description
Run openmrs distributions and mysql as docker containers.

## Requirements
  - Docker engine
  - Docker compose

## Development

Application will be accessible on:
* parent - http://localhost:8086/openmrs
* child1 - http://localhost:8087/openmrs
* child2 - http://localhost:8088/openmrs

All OpenMRS instances use the same set of modules. Which can be found in the "modules" directory.

### reloadModule script
In order to reload the OpenMRS module you can use prepared script:

```
$ ./scripts/reloadModule.sh
```
To display all possible options you can execute this script with the "-h" parameter.

For instance if you want to reload the Sync2 module, execute:
```
$ ./scripts/reloadModule.sh -p {path_to_Sync2_module}
```

### manageDemo script
In order to manage the demo-environment you can use prepared script:
```
$ ./scripts/manageDemo.sh
```

To display all possible options you can execute this script with the "-h" parameter.
For instance if you want to restart and clear the demo-environment, execute:
```
$ ./scripts/manageDemo.sh -rv
```

If you made any changes to the Dockerfile you should restart and rebuild docker image:
```
$ ./scripts/manageDemo.sh -rb
```
