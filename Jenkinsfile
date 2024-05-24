pipeline {
    agent any

    environment {
        // Adding credentials for Docker
        DOCKER_CREDENTIALS_ID = 'dockerHub'
        CONTAINER_NAME = 'kuzma343_test23'
        CONTAINER_NAME2 = 'kuzma343_test23_2'
        DOCKERFILE_PATH = 'BackEnd/Amazon-clone/Dockerfile'
    }

    stages {
        stage('Docker Login') {
            steps {
                script {
                    // Using Jenkins credentials to login to Docker
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh "echo \$DOCKER_PASSWORD | docker login --username \$DOCKER_USERNAME --password-stdin"
                    }
                }
            }
        }

        stage('Build Docker Image and Tag Docker Image') {
            steps {
                script {
                    // Building Docker image
                    sh "docker build -t kuzma343/test23:version\$BUILD_NUMBER ."
                    sh "docker tag kuzma343/test23:version\$BUILD_NUMBER kuzma343/test23:latest"
                    sh "docker build -t kuzma343/test23:backend\$BUILD_NUMBER -f \$DOCKERFILE_PATH ."
                    sh "docker tag kuzma343/test23:backend\$BUILD_NUMBER kuzma343/test23:backend"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    // Pushing images to Docker Hub
                    sh "docker push kuzma343/test23:version\$BUILD_NUMBER"
                    sh "docker push kuzma343/test23:backend"
                    sh "docker push kuzma343/test23:latest"
                }
            }
        }

        stage('Stop and Remove Old Container') {
            steps {
                script {
                    // Attempt to stop and remove the old container if it exists
                    sh """
                    if [ \$(docker ps -aq -f name=^${CONTAINER_NAME}\$) ]; then
                        docker stop ${CONTAINER_NAME}
                        docker rm ${CONTAINER_NAME}
                    else
                        echo "Container ${CONTAINER_NAME} not found. Continuing..."
                    fi
                    """
                }
            }
        }

        stage('Clean Old Images') {
            steps {
                script {
                    // Cleaning old images from Docker Hub
                    sh 'docker image prune -a --filter "until=24h" --force'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Running Docker container with the new image
                    sh "docker run -d -p 8081:80 --name ${CONTAINER_NAME} --health-cmd='curl --fail http://localhost:80 || exit 1' kuzma343/test23:version\$BUILD_NUMBER"
                    sh "docker run -d -p 8082:80 --name ${CONTAINER_NAME2} --health-cmd='curl --fail http://localhost:80 || exit 1' kuzma343/test23:backend\$BUILD_NUMBER"
                }
            }
        }
    }
}
