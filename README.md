# eXo Platform Trial Docker image
[![Docker Stars](https://img.shields.io/docker/stars/exoplatform/exo-trial.svg)]() - [![Docker Pulls](https://img.shields.io/docker/pulls/exoplatform/exo-trial.svg)]()

The eXo Platform Trial edition Docker image support `HSQLDB` only (for testing).

|    Image                        |  JDK  |   eXo Platform           
|---------------------------------|-------|--------------------------
|exoplatform/exo-trial:develop    |   8   | 4.4.3 Trial edition      
|exoplatform/exo-trial:latest     |   8   | 4.4.3 Trial edition      
|exoplatform/exo-trial:5.0        |   8   | 5.0.0-Mx Trial edition (latest release)
|exoplatform/exo-trial:4.4        |   8   | 4.4.3 Trial edition      
|exoplatform/exo-trial:4.3        |   8   | 4.3.0 Trial edition      

## Quick start

The prerequisites are :
* Docker daemon version 12+ and an internet access
* 4GB of available RAM + 1GB of disk


The most basic way to start eXo Platform Trial edition for *evaluation* purpose is to execute
```
docker run --rm -v exo_trial_data:/srv -p 8080:8080 exoplatform/exo-trial
```
and then waiting the log line which say that the server is started
```
2017-05-22 10:49:30,176 | INFO  | Server startup in 83613 ms [org.apache.catalina.startup.Catalina<main>]
```
When ready just go to http://localhost:8080 and follow the instructions ;-)

## Configuration options

## JVM

The standard eXo Platform environment variables can be used :

|    VARIABLE              |  MANDATORY  |   DEFAULT VALUE          |  DESCRIPTION
|--------------------------|-------------|--------------------------|----------------
| EXO_JVM_SIZE_MIN | NO | `512m` | specify the jvm minimum allocated memory size (-Xms parameter)
| EXO_JVM_SIZE_MAX | NO | `3g` | specify the jvm maximum allocated memory size (-Xmx parameter)

INFO: This list is not exhaustive (see eXo Platform documentation or {EXO_HOME}/bin/setenv.sh for more parameters).

## Mail

The following environment variables should be passed to the container in order to configure the mail server configuration to use :

|    VARIABLE              |  MANDATORY  |   DEFAULT VALUE          |  DESCRIPTION
|--------------------------|-------------|--------------------------|----------------
| EXO_MAIL_FROM | NO | `noreply@exoplatform.com` | "from" field of emails sent by eXo platform
| EXO_MAIL_SMTP_HOST | NO | `localhost` | SMTP Server hostname
| EXO_MAIL_SMTP_PORT | NO | `25` | SMTP Server port
| EXO_MAIL_SMTP_STARTTLS | NO | `false` | true to enable the secure (TLS) SMTP. See RFC 3207.
| EXO_MAIL_SMTP_USERNAME | NO | - | authentication username for smtp server (if needed)
| EXO_MAIL_SMTP_PASSWORD | NO | - | authentication password for smtp server (if needed)

## How-to ...

### see eXo Platform logs

```
# eXo Platform logs
docker exec <CONTAINER_NAME> tail -f /var/log/exo/platform.log
# MongoDB logs
docker exec <CONTAINER_NAME> tail -f /var/log/mongodb/mongod.log
```

### install eXo Platform add-ons

To install add-ons in the container, provide a commas separated list of add-ons you want to install in a `EXO_ADDONS_LIST` environment variable to the container:

```
docker run -d \
    -p 8080:8080 \
    -e EXO_ADDONS_LIST="exo-answers:1.2.1,exo-web-pack:1.1.1" \
    exoplatform/exo-trial
```

INFO: the provided add-ons list will be installed in the container during the container creation.


### list eXo Platform add-ons available

In a *running container* execute the following command:

```
docker exec <CONTAINER_NAME> /opt/exo/addon list
```

### list eXo Platform add-ons installed

In a *running container* execute the following command:

```
docker exec <CONTAINER_NAME> /opt/exo/addon list --installed
```

### override eXo Platform add-ons catalog

For add-on development purpose, it could be useful to point the add-on manager to another catalog.
You can use the ``EXO_ADDONS_CATALOG_URL`` environment variable for that :

```
# Pointing to a remote catalog
docker run -d -p 8080:8080 \
 -e EXO_ADDONS_CATALOG_URL="http://my.enterprise.com/catalog.json" \
 -e EXO_ADDONS_LIST="my-enterprise-addon:1.0.0" \
 exoplatform/exo-trial

# Pointing to a catalog on the local filesystem
docker run -d -p 8080:8080 \
 -e EXO_ADDONS_CATALOG_URL="file:///etc/exo/catalog.json" \
 -e EXO_ADDONS_LIST="my-enterprise-addon:1.0.0" \
 -v /path/to/catlog.json:/etc/exo/catalog.json:ro \
 exoplatform/exo-trial
```

### customize some eXo Platform settings

As explained in [eXo Platform documentation](https://www.exoplatform.com/docs/PLF44/PLFAdminGuide.InstallationAndStartup.CustomizingEnvironmentVariables.html) you can customize several aspects of eXo platform by settings environment variables :

```
docker run -d \
    -p 8080:8080 \
    -e EXO_JVM_SIZE_MAX="8g" \
    exoplatform/exo-trial
```
