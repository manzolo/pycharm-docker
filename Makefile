# Nome del file .env (modificabile se necessario)
ENV_FILE := .env

PUID := $(shell id -u)
PGID := $(shell id -g)

# Carica le variabili dal file .env
ifneq (,$(wildcard $(ENV_FILE)))
    include $(ENV_FILE)
    export $(shell sed 's/=.*//' $(ENV_FILE))
endif
# Target per avviare i container
start:
	@echo "Consentire connessioni X11 locali"
	@xhost +SI:localuser:$(shell id -un)
	@echo "Riavvio i container Docker Compose"
	docker compose run --remove-orphans ${CONTAINER_NAME}

# Target per fermare i container
stop:
	@echo "Fermo e rimuovo i container Docker Compose"
	docker compose down
	docker compose rm -f

# Target per la build dell'immagine
build:
	@echo "Build dell'immagine"
ifeq ($(DEBUG),true)
	@echo "Modalità DEBUG attiva: build in plain text abilitato"
	docker build --progress=plain --build-arg CONTAINER_USERNAME=${CONTAINER_USERNAME} \
		--build-arg PYCHARM_VERSION=${PYCHARM_VERSION} \
		--build-arg PUID=${PUID} \
		--build-arg PGID=${PGID} \
		-t ${REGISTRY_BASE_URL}/${IMAGE_OWNER}/${IMAGE_NAME}:${IMAGE_TAG} .
else
	docker build --build-arg CONTAINER_USERNAME=${CONTAINER_USERNAME} \
		--build-arg PYCHARM_VERSION=${PYCHARM_VERSION} \
		--build-arg PUID=${PUID} \
		--build-arg PGID=${PGID} \
		-t ${REGISTRY_BASE_URL}/${IMAGE_OWNER}/${IMAGE_NAME}:${IMAGE_TAG} .
endif
	@echo "Immagine costruita: ${REGISTRY_BASE_URL}/${IMAGE_OWNER}/${IMAGE_NAME}:${IMAGE_TAG}"


#registry_tag:
#	docker tag ${IMAGE_NAME} ${REGISTRY_BASE_URL}/${IMAGE_OWNER}/${IMAGE_NAME}:${IMAGE_TAG}

registry_push:
	docker push ${REGISTRY_BASE_URL}/${IMAGE_OWNER}/${IMAGE_NAME}:${IMAGE_TAG}

# Target per la build dell'immagine
logs:
	@echo "Container logs"
	docker compose logs -f

# Target per la build dell'immagine
enter:
	@echo "Consentire connessioni X11 locali"
	@xhost +SI:localuser:$(shell id -un)
	@echo "Enter Container"
	docker compose run --remove-orphans --entrypoint /bin/bash ${CONTAINER_NAME} 

