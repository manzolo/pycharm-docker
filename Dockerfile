# Usa una base leggera con GUI supportata
FROM ubuntu:24.04

ARG CONTAINER_USERNAME=utente
ENV CONTAINER_USERNAME=${CONTAINER_USERNAME}

RUN userdel -r ubuntu

# Crea un utente non root
ARG PUID=1000
ARG PGID=1000
RUN groupadd -g $PGID ${CONTAINER_USERNAME} && \
    useradd -m -u $PUID -g $PGID -s /bin/bash ${CONTAINER_USERNAME}
   
ENV workspace=/tmp
COPY . ${workspace}

WORKDIR ${workspace}
RUN chmod +x ${workspace}/installer.sh
RUN ${workspace}/installer.sh

# Cambia contesto all'utente non root
USER ${CONTAINER_USERNAME}
WORKDIR /home/${CONTAINER_USERNAME}

# Imposta PATH
ENV PATH="/opt/pycharm-community-2024.3.1.1/bin:$PATH"

# Comando di avvio
CMD ["pycharm"]
