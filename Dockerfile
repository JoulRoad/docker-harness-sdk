FROM actionml/vw:10bd09ab-harness

ARG release_version
ARG version
LABEL com.actionml.scala.vendor=ActionML \
      com.actionml.scala.version=${release_version}

ENV SCALA_VERSION=${version} \
    SCALA_HOME=/usr/share/scala \
    SBT_VERSION=1.2.1 \
    SBT_HOME=/usr/share/sbt \
    SDK_VERBOSE=no

# Note: overrides JAVA_HOME set by actionml/vw:jni
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk

## Install OpenJDK8 Java SDK
#
RUN set -x && apk add --update --no-cache openjdk8 && \
      [ "$JAVA_HOME" = "$(docker-java-home)" ]


## Install Scala
#
#  Note: specific version MUST BE COMPATIBLE with openjdk 1.8!
RUN apk add --no-cache --virtual=.deps tar gnupg && \
    curl -#SL -o /tmp/scala.tgz \
      "https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz" && \
    mkdir $SCALA_HOME && cd $SCALA_HOME && \
    tar xzf /tmp/scala.tgz --strip-component=1 && \
    # odd but scala this stub (omits "cat: ...release: No such file or directory")
    java -version &> ${JAVA_HOME}/release && \
    # link to /usr/bin
    rm -r ./bin/*.bat doc man && ln -s ${SCALA_HOME}/bin/* /usr/bin/ && \
    # cleanup
    rm -rf /tmp/* && apk del .deps


## Install Sbt
#
RUN apk add --no-cache --virtual=.deps tar gnupg && \
    cd /tmp/ && curl --remote-name-all -#SLO \
      https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/{sbt-${SBT_VERSION}.tgz,sbt-${SBT_VERSION}.tgz.asc} && \
    # verify sbt integrity
    export GNUPGHOME=/tmp && \
    for server in ha.pool.sks-keyservers.net \
              hkp://p80.pool.sks-keyservers.net:80 \
              keyserver.ubuntu.com \
              hkp://keyserver.ubuntu.com:80 \
              pgp.mit.edu; do \
        gpg --keyserver "$server" --recv-keys 2EE0EA64E40A89B84B2DF73499E82A75642AC823 && break || echo "Trying new server..."; \
    done && \
    gpg --batch --verify sbt*.asc sbt*.tgz && \
    mkdir $SBT_HOME && cd $SBT_HOME && \
    tar xzf /tmp/sbt*.tgz --strip-component=1 && \
    ln -s ${SBT_HOME}/bin/* /usr/bin/ && \
    # cleanup
    rm -rf /tmp/* && apk del .deps


## Install SDK
#
#  note: minimum to begin with
RUN  apk add --no-cache maven make

## Set entrypoint
#
COPY /entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
