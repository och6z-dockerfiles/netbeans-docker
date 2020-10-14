ARG MAVEN_VERSION

FROM maven:${MAVEN_VERSION}

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    wget \
    unzip \
    openjfx \
    openssh-client \
    git \
    && apt-get purge -y && apt-get autoremove -y && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/*

ARG GID
ARG GID_NAME
ARG UID
ARG UID_NAME

RUN addgroup --gid ${GID} ${GID_NAME} \
    && adduser --uid ${UID} --ingroup ${GID_NAME} --home /home/${UID_NAME} --shell /bin/bash --disabled-password --gecos "" ${UID_NAME}

COPY --chown=${UID_NAME}:${GID_NAME} data /home/${UID_NAME}/

ARG PRODUCT_VERSION
ENV PRODUCT_VERSION ${PRODUCT_VERSION}

ARG PRODUCT_DOWNLOAD_URL=https://downloads.apache.org
ENV PRODUCT_DOWNLOAD_URL ${PRODUCT_DOWNLOAD_URL}

ARG IDE

COPY ${IDE}.sh /

RUN chmod +x /${IDE}.sh \
    && /${IDE}.sh \
    && rm --force /${IDE}.sh

USER ${UID_NAME}

WORKDIR /home/${UID_NAME}/data

ENTRYPOINT ["/bin/bash", "-c"]

CMD ["/home/netbeans/bin/netbeans"]

#docker builder build --no-cache --build-arg MAVEN_VERSION=3.6.3-openjdk-14-slim --build-arg IDE=netbeans --build-arg PRODUCT_VERSION=11.0 --build-arg GID=$(id -g) --build-arg GID_NAME=$(id -gn) --build-arg UID=$(id -u) --build-arg UID_NAME=$(id -un) --file Dockerfile . --tag image-name:latest
#xhost +local:docker
#docker container run --interactive --tty --volume /tmp/.X11-unix:/tmp/.X11-unix --user $(id -un) --volume $(pwd):/home/$(id -un) --env DISPLAY=unix$DISPLAY --name container-name image-id
