# Usa una base leggera con GUI supportata
FROM ubuntu:24.04

ARG CONTAINER_USERNAME=utente
ENV CONTAINER_USERNAME=${CONTAINER_USERNAME}

ARG PYCHARM_VERSION=2024.3.1.1
ENV PYCHARM_VERSION=${PYCHARM_VERSION}

RUN userdel -r ubuntu

# Crea un utente non root
ARG PUID=1000
ARG PGID=1000
ENV PUID=${PUID}
ENV PGID=${PGID}

RUN groupadd -g $PGID ${CONTAINER_USERNAME} && \
    useradd -m -u $PUID -g $PGID -s /bin/bash ${CONTAINER_USERNAME}
   
ENV workspace=/tmp
COPY . ${workspace}

WORKDIR ${workspace}
RUN chmod +x ${workspace}/installer.sh
RUN ${workspace}/installer.sh


# Copia lo script di avvio
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Cambia contesto all'utente non root
USER ${CONTAINER_USERNAME}
WORKDIR /home/${CONTAINER_USERNAME}

# Imposta PATH
ENV PATH="/opt/pycharm-community/bin:$PATH"

# Usa lo script di avvio come punto di ingresso
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

