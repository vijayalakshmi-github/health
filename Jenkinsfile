pipeline{
  agent any

  environment{
    imagename="vijayalakshmis/medicure"
    registryCredential = 'Docker'
    dockerImage = ''
  }
  tools
  {
    maven 'MAVEN_3'
  }
  stages{
    stage('Checkout'){
      steps{
        echo 'Checkout the source code'
        git 'https://github.com/vijayalakshmi-github/medicure.git'
      }
    }

    stage('Build'){
      steps{
        echo 'Packaging'
        sh 'mvn clean package'
      }
    }

    stage('Generate test report'){
      steps{
        publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/medicure_test/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])
      }
    }

    stage('Build image') {
      steps{
        script {
          dockerImage = docker.build imagename
        }
      }
    }
    stage('Push Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
             dockerImage.push('latest')
          }
        }
      }
    }
    stage ('Configure and Deploy Prod-server with Terraform, Ansible'){
      steps{
        
        sh 'chmod 700 aws.pem'
        sh 'terraform init'
        sh 'terraform validate'
        sh 'terraform apply --auto-approve'
      }
    }
  }
}
