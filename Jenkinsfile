pipeline {
    environment {
    registry = "peppe2794/test"
    registryCredential = 'dockerhub'
    }
    agent any
    stages {
        stage('Build') {
            steps {
                echo "BUILD"
                docker.build registry + ":$BUILD_NUMBER"
            }
        }
    }
}
