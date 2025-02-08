pipeline {
    agent any
    environment {
        AWS_ECR_URI = '767828746131.dkr.ecr.us-east-1.amazonaws.com/netaproject/firstproject'
        AWS_ACCESS_KEY_ID = credentials('aws-id')  // Jenkins credentials ID for AWS Access Key
        AWS_SECRET_ACCESS_KEY = credentials('aws-id')  // Jenkins credentials ID for AWS Secret Key
        AWS_DEFAULT_REGION = 'us-east-1'
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Show current directory and list files
                    sh 'pwd'
                    sh 'ls -l'
                    // Ensure Dockerfile exists
                    sh 'ls -l Dockerfile'
                    // Now attempt the build
                    sh 'docker build -t jenkins_try .'
                }
            }
        }
        stage('Login to AWS ECR') {
            steps {
                script {
                    sh '''
                        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $AWS_ECR_URI
                    '''
                }
            }
        }
        stage('Push Docker Image to ECR') {
            steps {
                script {
                    sh '''
                        docker tag flask-app:latest $AWS_ECR_URI:latest
                        docker push $AWS_ECR_URI:latest
                    '''
                }
            }
        }
    }
}
