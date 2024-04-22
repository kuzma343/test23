pipeline {
    agent any

    environment {
        // Додаємо креденшіали для Docker
        DOCKER_CREDENTIALS_ID = 'dockerHub'
    }
   

    stages {
        
        
        stage("Docker login"){
      steps{
      withCredentials([string(credentialsId: 'DockerHubPwd', variable: 'dockerpwd')]) {
      sh "docker login -u username -p ${dockerpwd}"
            }
        }
   }

        stage('Білд Docker зображення') {
            steps {
                script {
                    // Будуємо Docker зображення
                    sh 'docker build -t kuzma343/kuzma343market:version1.9 .'
                }
            }
        }

        stage('Пуш у Docker Hub') {
            steps {
                script {
                    // Пушимо зображення на Docker Hub
                    sh 'docker push kuzma343/kuzma343market:version1.90'
                }
            }
        }

        stage('Запуск Docker контейнера') {
            steps {
                script {
                    // Запускаємо Docker контейнер
                    sh 'docker run -d -p 80:80 kuzma343/kuzma343market:version1.9'
                }
            }
        }
    }
}
