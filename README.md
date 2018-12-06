# sync2-demo-environment

# Description
Run openmrs distributions and mysql as docker containers.

## Requirements
  - Docker engine
  - Docker compose

## Development

To run the demo environment you need to execute (if it is the first time please add "-b" parameter to build Docker images):
```
$ ./scripts/manageDemo.sh -u
```

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

If you want to use the OpenMRS development mode (more info: https://wiki.openmrs.org/display/docs/Using+the+UI+Framework+in+Your+Module#UsingtheUIFrameworkinYourModule-Developmentmode)you need to follow this steps:
1) Copy content of the ./instance/openmrs-runtime.properties file
2) Sign in into a running container. For instance:
```
$ sudo docker exec -it sync2_child1 bash
```
3) Go to the /usr/local/tomcat/.OpenMRS inside the docker container
4) Paste the value copied in the 1 step
5) Sign out from the docker container
6) In the docker-compose.yml change mapping of the projects directory. For instance:
This:
```
- child2-data:/root/projectDir
```
Change to (if your OpenMRS projects are in the /home/user/sync2 directory):
```
- /home/user/sync2:/root/projectDir
```

Note!
By default the development mode is enable only for the sync2 project.
If you want to add different project you need to make changes in the
"uiFramework.developmentModules" from the ./instance/openmrs-runtime.properties file and
make sure the same changes are in the docker container (see step 4 above).
