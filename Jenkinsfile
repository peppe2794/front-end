pipeline {
  environment {
    registry = "peppe2794/test"
    registryCredential = 'dockerhub'
    dockerImage = ''
    DOCKER_TAG = getVersion().trim()
    IMAGE="test:"
  }
  agent any
  stages {
    stage('SonarQube analysis'){
      steps{
        tool name: 'NodeJS', type: 'nodejs'
        tool name: 'sonar_scanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
        withSonarQubeEnv(installationName: 'Sonarqube', credentialsId: 'Sonarqube') {
          sh "${sonar_scanner}/bin/sonar-scanner"
        }
      }
    }
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build("$registry:$DOCKER_TAG")
        }
      }
    }
    stage('Push Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }
 }
  post{
    success{
      echo 'Post success'
      build job: 'socks_application', parameters: [string (value: "$IMAGE"+"$DOCKER_TAG", description: 'Parametro', name: 'FRONT_END')]
    }
  }
}

def getVersion(){
  def commitHash = sh returnStdout: true, script: 'git rev-parse --short HEAD'
  return commitHash
}
