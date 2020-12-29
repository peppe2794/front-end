pipeline {
  environment {
    registry = "peppe2794/test"
    registryCredential = 'dockerhub'
    dockerImage = ''
    DOCKER_TAG = getVersion().trim()
  }
  agent any
  stages {
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
    stage('Deploy Image') {
      steps{
        ansiblePlaybook credentialsId: 'node', disableHostKeyChecking: true, extras: 'DOCKER_TAG="${DOCKER_TAG}"', installation: 'ansible', inventory: '/etc/ansible/hosts', playbook: 'Deploy-docker.yaml'
      }
 }
}
def getVersion(){
  def commitHash = sh returnStdout: true, script: 'git rev-parse --short HEAD'
  return commitHash
}
