# Usa una base leggera con GUI supportata
FROM ubuntu:24.04

RUN userdel -r ubuntu

ENV workspace=/tmp
COPY . ${workspace}

WORKDIR ${workspace}
RUN chmod +x ${workspace}/installer.sh
RUN ${workspace}/installer.sh

#RUN getent group kvm || groupadd -r kvm

# Crea un utente non root
ARG PUID=1000
ARG PGID=1000
RUN groupadd -g $PGID manzolo && \
    useradd -m -u $PUID -g $PGID -s /bin/bash manzolo

#RUN mkdir -p /home/manzolo/.config/Google/AndroidStudio2024.2 && chown -R manzolo:manzolo /home/manzolo/.config

# Cambia contesto all'utente non root
USER manzolo
WORKDIR /home/manzolo

# Imposta PATH
ENV PATH="/opt/pycharm-community-2024.3.1.1/bin:$PATH"

# Comando di avvio
CMD ["pycharm"]
