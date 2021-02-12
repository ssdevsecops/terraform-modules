pipeline {
    agent any

    stages {
        stage('checkout') {
            steps {
               checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/ssdevsecops/terraform-modules.git']]])
            }
        }
        stage('init') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'terraform-user', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                 sh 'cd dev;terraform init'
            }
                
            }
        }
        
        stage('plan') {
            steps {
                sh 'cd dev; terraform plan'
            }
        }
        
        stage('apply') {
            steps {
                sh 'cd dev ; terraform apply -auto-approve=true'
            }
        }
    }
}

