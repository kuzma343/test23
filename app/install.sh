#!/bin/bash


# Перевіряємо, чи встановлений Docker
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Installing Docker..."
    # Установка Docker за допомогою скрипту з офіційного репозиторію Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker "$USER"
    # Перезавантажуємо систему для застосування змін
    sudo reboot
fi
# Задаємо змінні середовища
DOCKER_CREDENTIALS_ID='dockerHub'
CONTAINER_NAME='kuzma343_test23'
CONTAINER_NAME2='kuzma343_test23_2'
DOCKERFILE_PATH='BackEnd/Amazon-clone/Dockerfile'

# Входимо до Docker Hub
echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USERNAME" --password-stdin

# Будуємо та тегуємо Docker зображення
docker build -t kuzma343/test23:version"$BUILD_NUMBER" .
docker tag kuzma343/test23:version"$BUILD_NUMBER" kuzma343/test23:latest
docker build -t kuzma343/test23:backend"$BUILD_NUMBER" -f "$DOCKERFILE_PATH" .
docker tag kuzma343/test23:backend"$BUILD_NUMBER" kuzma343/test23:backend

# Пушимо зображення до Docker Hub
docker push kuzma343/test23:version"$BUILD_NUMBER"
docker push kuzma343/test23:backend
docker push kuzma343/test23:latest

# Спроба зупинити та видалити старий контейнер, якщо він існує
if [ "$(docker ps -aq -f name=^${CONTAINER_NAME})" ]; then
    docker stop "$CONTAINER_NAME"
    docker rm "$CONTAINER_NAME"
else
    echo "Container $CONTAINER_NAME not found. Continuing..."
fi

# Очистка старих образів
docker image prune -a --filter "until=24h" --force

# Запуск Docker контейнерів з новими зображеннями
docker run -d -p 8081:80 --name "$CONTAINER_NAME" --health-cmd="curl --fail http://localhost:80 || exit 1" kuzma343/test23:version"$BUILD_NUMBER"
docker run -d -p 8082:80 --name "$CONTAINER_NAME2" --health-cmd="curl --fail http://localhost:80 || exit 1" kuzma343/test23:backend"$BUILD_NUMBER"
