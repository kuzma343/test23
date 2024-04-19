pipeline {
    agent any

    environment {
        // Додаємо креденшіали для Docker
        DOCKER_CREDENTIALS_ID = 'dockerHub'
    }
   

    stages {
        
        
       stage('Вхід у Docker') {
            steps {
                script {
                    // Використовуємо креденшіали з Jenkins для входу в Docker
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh 'echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin'
                    }
                }
            }
        }
