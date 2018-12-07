FROM openjdk:8-jdk-alpine3.8

ARG version
ARG scala_version

LABEL com.actionml.scala.vendor=ActionML \
      com.actionml.scala.version=${version}

ENV SCALA_VERSION=${scala_version} \
    SCALA_HOME=/usr/share/scala \
    SDK_VERBOSE=yes

RUN \
# install alpine essential packages and build-tools
    apk add --no-cache --update curl bash git tar gnupg \
        binutils coreutils findutils file build-base && \
# install python3 (from package)
    apk add --no-cache --update python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
        ln -sf /usr/bin/python3 /usr/bin/python && \
        ln -sf /usr/bin/python3-config /usr/bin/python-config && \
        ln -sf /usr/bin/pydoc3 /usr/bin/pydoc && \
        ln -sf /usr/bin/pip3 /usr/bin/pip && \
    rm -r /root/.cache && \
# install install scala
    export SCALA_VERSION=${scala_version} && \
    curl -\#SL -o /tmp/scala.tgz \
       https://downloads.typesafe.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz && \
    mkdir -p $SCALA_HOME && cd $SCALA_HOME && \
    tar -xzf /tmp/scala.tgz --strip-component=1 && \
    rm -r ./bin/*.bat doc man && ln -s ${SCALA_HOME}/bin/* /usr/local/bin/ && \
    rm -rf /tmp/* && \
# install maven
    apk add --no-cache --update maven

COPY /details.sh /entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
