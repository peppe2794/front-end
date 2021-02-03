pipeline {
  environment {
    registry = "peppe2794/test"
    registryCredential = 'dockerhub'
    dockerImage = ''
    DOCKER_TAG = getVersion().trim()
    IMAGE="test"
  }
  tools {
    nodejs 'NodeJS'
 }
  agent any
  stages {
    stage('SonarQube analysis'){
      steps{
        withSonarQubeEnv(installationName: 'Sonarqube2', credentialsId: 'Sonarqube2') {
          sh "${tool("sonar_scanner")}/bin/sonar-scanner"
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
    stage('Static Security Assesment'){
      steps{
        sh 'docker run --name ${IMAGE} -t -d $registry:${DOCKER_TAG}'
        sh 'inspec exec https://github.com/dev-sec/linux-baseline -t docker://${IMAGE} --chef-license=accept || true'
        sh 'docker stop ${IMAGE}'
        sh 'docker container rm ${IMAGE}'
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
      build job: 'socks_application', parameters: [string (value: "$IMAGE"+":"+"$DOCKER_TAG", description: 'Parametro', name: 'FRONT_END')]
    }
  }
}

def getVersion(){
  def commitHash = sh returnStdout: true, script: 'git rev-parse --short HEAD'
  return commitHash
}
