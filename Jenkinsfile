pipeline {
    environment {
        registry = "peppe2794/test"
        registryCredential = 'dockerhub'
        dockerImage = ''
    }
    agent any
    stages {
        stage('Build') {
            steps {
               script {
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
               }
            }
        }
     stage('Deploy Image') {
         steps{
                script {
                     docker.withRegistry( '', registryCredential ) {
                     dockerImage.push()
                }
        }
     }
    }
    }
}
