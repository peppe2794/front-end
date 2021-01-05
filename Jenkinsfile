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
    stage ('Provisioning with ANSIBLE'){
      steps{
        ansiblePlaybook become: true, credentialsId: 'pve', disableHostKeyChecking: true, installation: 'ansible', inventory: '/etc/ansible/hosts', playbook: 'provisioning.yml'
      }
    }
    stage('Provisioning with TERRAFORM - Init'){
        steps{
            sh label: '', script: 'terrafom init'
        }
    }
    stage('Provisioning with TERRAFORM - Apply'){
        steps{
            sh label: '', script: 'terrafom apply --auto-approve'
        }
    stage('Deploy Image') {
      steps{
        ansiblePlaybook credentialsId: 'node', disableHostKeyChecking: true, extras: "-e DOCKER_TAG=${DOCKER_TAG}", installation: 'ansible', inventory: '/etc/ansible/hosts', playbook: 'Deploy-docker.yaml'
      }
    }
 }
}
def getVersion(){
  def commitHash = sh returnStdout: true, script: 'git rev-parse --short HEAD'
  return commitHash
}
