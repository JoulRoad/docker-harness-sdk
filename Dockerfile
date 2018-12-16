FROM openjdk:8-jdk-alpine3.8

ARG version

LABEL com.actionml.harness-sdk.vendor=ActionML \
      com.actionml.harness-sdk.version=${version}

ENV DOCKER_CHANNEL=stable \
    DOCKER_VERSION=18.09.0 \
    DOCKER_SHASUM=08795696e852328d66753963249f4396af2295a7fe2847b839f7102e25e47cb9 \
    SDK_VERBOSE=yes

RUN cd /tmp && \
# install alpine essential packages and build-tools
    apk add --no-cache --update curl bash git tar gnupg \
        binutils coreutils findutils file make maven && \
# install python3 (from package)
    apk add --no-cache --update python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools wheel && \
        ln -sf /usr/bin/python3 /usr/bin/python && \
        ln -sf /usr/bin/python3-config /usr/bin/python-config && \
        ln -sf /usr/bin/pydoc3 /usr/bin/pydoc && \
        ln -sf /usr/bin/pip3 /usr/bin/pip && \
    rm -r /root/.cache && \
# install docker binary
  if ! curl -#fL -o docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz"; then \
    echo >&2 "error: failed to download 'docker-${DOCKER_VERSION}' from '${DOCKER_CHANNEL}' for x86_64"; \
    exit 1; \
  fi; \
  \
  tar -xzf docker.tgz \
    --strip-components 1 \
    -C /usr/local/bin && \
  \
  echo "${DOCKER_SHASUM}  docker.tgz" | sha256sum -c && rm docker.tgz
## We don't install custom modprobe, since haven't run into issues yet (see the link bellow)
#  https://github.com/docker-library/docker/blob/master/18.06/modprobe.sh
#

COPY /details.sh /entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
