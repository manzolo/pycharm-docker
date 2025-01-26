#!/bin/bash
# Esegui chown per garantire i permessi corretti
rm -rf /home/${CONTAINER_USERNAME}/.config/JetBrains/PyCharmCE2024.3/.lock

# Avvia Android Studio
exec pycharm