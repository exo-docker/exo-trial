# Dockerizing base image for eXo Platform with:
#
# - Libre Office
# - MongoDB
# - eXo Platform Trial edition

# Build:    docker build -t exoplatform/exo-trial .
#
# Run:      docker run -ti --name=exo exoplatform/exo-trial:latest
#           docker run -d  --name=exo -p 80:8080 exoplatform/exo-trial:latest

FROM       exoplatform/base-jdk:jdk8
MAINTAINER DROUET Frederic <fdrouet+docker@exoplatform.com>

# Environment variables
ENV EXO_VERSION   4.3.0
ENV EXO_EDITION   trial
ENV EXO_DOWNLOAD  http://storage.exoplatform.org/downloads/Releases/Platform/4.3/${EXO_VERSION}/platform-${EXO_EDITION}-${EXO_VERSION}.zip
ENV MONGO_VERSION 3.0

ENV EXO_APP_DIR     /opt/exo
ENV EXO_CONF_DIR    /etc/exo
ENV EXO_DATA_DIR    /srv/exo
ENV EXO_LOG_DIR     /var/log/exo
ENV EXO_TMP_DIR     /tmp/exo-tmp
ENV MONGO_DATA_DIR  /srv/mongodb

ENV EXO_USER exo
ENV EXO_GROUP ${EXO_USER}

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN useradd --create-home --user-group --shell /bin/bash ${EXO_USER}
# giving all rights to eXo user
RUN echo "exo   ALL = NOPASSWD: ALL" > /etc/sudoers.d/exo && chmod 440 /etc/sudoers.d/exo

# Install some useful or needed tools
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo "deb http://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/${MONGO_VERSION} multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-${MONGO_VERSION}.list

RUN apt-get -qq update && \
  apt-get -qq -y upgrade ${_APT_OPTIONS} && \
  apt-get -qq -y install ${_APT_OPTIONS} libreoffice-calc libreoffice-draw libreoffice-impress libreoffice-math libreoffice-writer && \
  apt-get -qq -y install ${_APT_OPTIONS} mongodb-org-server && \
  apt-get -qq -y autoremove && \
  apt-get -qq -y clean && \
  rm -rf /var/lib/apt/lists/*

# Create needed directories
RUN mkdir -p ${EXO_APP_DIR}
RUN mkdir -p ${EXO_DATA_DIR}    && chown ${EXO_USER}:${EXO_GROUP} ${EXO_DATA_DIR} && \
  mkdir ${EXO_DATA_DIR}/.eXo/   && chown ${EXO_USER}:${EXO_GROUP} ${EXO_DATA_DIR}/.eXo && \
  ln -s ${EXO_DATA_DIR}/.eXo    /home/${EXO_USER}/.eXo
RUN mkdir -p ${EXO_TMP_DIR}     && chown ${EXO_USER}:${EXO_GROUP} ${EXO_TMP_DIR}
RUN mkdir -p ${EXO_LOG_DIR}     && chown ${EXO_USER}:${EXO_GROUP} ${EXO_LOG_DIR}
RUN mkdir -p ${MONGO_DATA_DIR}  && chown mongodb:mongodb ${MONGO_DATA_DIR}

# Install eXo Platform
RUN curl -L -o /srv/downloads/eXo-Platform-${EXO_EDITION}-${EXO_VERSION}.zip ${EXO_DOWNLOAD} && \
    unzip -q /srv/downloads/eXo-Platform-${EXO_EDITION}-${EXO_VERSION}.zip -d ${EXO_APP_DIR} && \
    rm -f /srv/downloads/eXo-Platform-${EXO_EDITION}-${EXO_VERSION}.zip && \
    ln -s ${EXO_APP_DIR}/platform-${EXO_VERSION}-${EXO_EDITION} ${EXO_APP_DIR}/current && \
    chown -R ${EXO_USER}:${EXO_GROUP} ${EXO_APP_DIR}/current/
RUN ln -s ${EXO_APP_DIR}/current/gatein/conf /etc/exo
RUN rm -rf ${EXO_APP_DIR}/current/logs && ln -s ${EXO_LOG_DIR} ${EXO_APP_DIR}/current/logs

# Install Docker customization file
ADD setenv-docker-customize.sh ${EXO_APP_DIR}/current/bin/setenv-docker-customize.sh
RUN chmod 755 ${EXO_APP_DIR}/current/bin/setenv-docker-customize.sh & chown exo:exo ${EXO_APP_DIR}/current/bin/setenv-docker-customize.sh
RUN sed -i '/# Load custom settings/i \
\# Load custom settings for docker environment\n\
[ -r "$CATALINA_BASE/bin/setenv-docker-customize.sh" ] \
&& . "$CATALINA_BASE/bin/setenv-docker-customize.sh" \
|| echo "No Docker eXo Platform customization file : $CATALINA_BASE/bin/setenv-docker-customize.sh"\n\
' ${EXO_APP_DIR}/current/bin/setenv.sh && \
  grep 'setenv-docker-customize.sh' ${EXO_APP_DIR}/current/bin/setenv.sh

# Add Configuration files

RUN mkdir /etc/service/mongod
RUN mkdir /etc/service/exo

ADD conf/mongod.conf          /etc/mongod.conf
ADD conf/mongod.sh            /etc/service/mongod/run
ADD conf/exo.sh               /etc/service/exo/run
ADD conf/chat.properties      /etc/exo/chat.properties

RUN chmod +x /etc/service/mongod/run
RUN chmod +x /etc/service/exo/run

EXPOSE 8080
