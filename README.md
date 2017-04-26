# eXo Platform Trial Docker container
[![Docker Stars](https://img.shields.io/docker/stars/exoplatform/exo-trial.svg?maxAge=2592000)]() - [![Docker Pulls](https://img.shields.io/docker/pulls/exoplatform/exo-trial.svg?maxAge=2592000)]()

* eXo Platform Trial edition
* Ubuntu
* Oracle JDK
* LibreOffice

## How to

### run the container

```
docker run -d -p 8080:8080 --name=exo exoplatform/exo-trial:latest
```

* watch logs inside the container

```
# eXo Platform logs
docker exec -ti exo tail -f /var/log/exo/platform.log
# MongoDB logs
docker exec -ti exo tail -f /var/log/mongodb/mongod.log
```

* keep data when the container is removed

```
docker run -d --rm -p 8080:8080 -v exo_trial_data:/srv -v exo_trial_logs:/var/log --name=exo exoplatform/exo-trial:latest
```

### install eXo Platform add-ons

There is 2 ways to install add-ons in the container during the startup time:

* provide a commas separated list of add-ons you want to install in a `EXO_ADDONS_LIST` environment variable to the container:

```
docker run -d -p 8080:8080 --name=exo -e EXO_ADDONS_LIST="exo-answers,exo-crash-tomcat:4.1.0" exoplatform/exo-trial:latest
```

* provide the list of add-ons you want to install in a file `/etc/exo/addons-list.conf` in the container:

```
docker run -d -p 8080:8080 --name=exo -v ~/addons-list.conf:/etc/exo/addons-list.conf:ro exoplatform/exo-trial:latest
```

The format of the file is :
* 1 add-on declaration per line
* 1 add-on declaration is : `ADDON_ID` or `ADDON_ID:VERSION`
* every line starting with a `#` character is treated as a comment and is ignored
* every blank line is ignored

```
# Sample add-ons-list.conf file
exo-crash-tomcat:4.1.0
#exo-chat:1.2.0
exo-answers
```

### list installed eXo Platform add-ons

In a running container execute the following command:

```
docker exec -ti exo /sbin/setuser exo /opt/exo/current/addon list --installed
```

### override eXo Platform add-ons catalog

For add-on development purpose, it could be useful to point the add-on manager to another catalog.
You can use the ``EXO_ADDONS_CATALOG_URL`` environment variable for that :

```
# Pointing to a remote catalog
docker run -d -p 8080:8080 --name=exo \
 -e EXO_ADDONS_CATALOG_URL="http://my.enterprise.com/catalog.json" \
 -e EXO_ADDONS_LIST="my-enterprise-addon:1.0.0" \
 exoplatform/exo-trial:latest

# Pointing to a catalog on the local filesystem
docker run -d -p 8080:8080 --name=exo \
 -e EXO_ADDONS_CATALOG_URL="file:///etc/exo/catalog.json" \
 -e EXO_ADDONS_LIST="my-enterprise-addon:1.0.0" \
 -v /path/to/catlog.json:/etc/exo/catalog.json:ro \
 exoplatform/exo-trial:latest
```


### customize some eXo Platform settings

As explained in [eXo Platform documentation](https://www.exoplatform.com/docs/PLF44/PLFAdminGuide.InstallationAndStartup.CustomizingEnvironmentVariables.html) you can customize several aspects of eXo platform by settings environment variables.

You can just pass environment variables:

```
docker run -d -p 8080:8080 --name=exo -e EXO_JVM_SIZE_MAX="4g" exoplatform/exo-trial:latest
```

You your own `setenv-customize.sh` file:

```
docker run -d -p 8080:8080 --name=exo -v ~/setenv-customize.sh:/opt/exo/current/bin/setenv-customize.sh:ro exoplatform/exo-trial:latest
```


## List of available versions

|    Image                        |  JDK  |   eXo Platform           | Size
|---------------------------------|-------|--------------------------|-----
|exoplatform/exo-trial:latest     |   8   | 4.4.1 Trial edition      | [![](https://badge.imagelayers.io/exoplatform/exo-trial:latest.svg)](https://imagelayers.io/?images=exoplatform/exo-trial:latest 'Get your own badge on imagelayers.io')
|exoplatform/exo-trial:4.4        |   8   | 4.4.1 Trial edition      | [![](https://badge.imagelayers.io/exoplatform/exo-trial:4.4.svg)](https://imagelayers.io/?images=exoplatform/exo-trial:4.4 'Get your own badge on imagelayers.io')
|exoplatform/exo-trial:4.3        |   8   | 4.3.0 Trial edition      | [![](https://badge.imagelayers.io/exoplatform/exo-trial:4.3.svg)](https://imagelayers.io/?images=exoplatform/exo-trial:4.3 'Get your own badge on imagelayers.io')
