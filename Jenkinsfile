pipeline {
    agent any

    environment {
        // Креденшіали для Docker
        DOCKER_CREDENTIALS_ID = 'dockerHub'
        COMPOSE_FILE = 'docker-compose.yml' // Назва файлу Docker Compose
    }

    stages {
        stage('Вхід у Docker') {
            steps {
                script {
                    // Використання креденшіалів з Jenkins для входу в Docker
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh 'echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin'
                    }
                }
            }
        }

        stage('Білд і пуш Docker зображень') {
            steps {
                script {
                    // Білдимо і пушимо образи через Docker Compose
                    sh 'docker-compose -f ${COMPOSE_FILE} build'
                    sh 'docker-compose -f ${COMPOSE_FILE} push'
                }
            }
        }

        stage('Запуск Docker контейнерів') {
            steps {
                script {
                    // Використовуємо Docker Compose для запуску контейнерів
                    sh 'docker-compose -f ${COMPOSE_FILE} up -d'
                }
            }
        }

        stage('Чистка') {
            steps {
                script {
                    // Видаляємо неактивні контейнери і невикористовувані образи
                    sh 'docker system prune -af'
                }
            }
        }
    }
}
