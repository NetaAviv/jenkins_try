pipeline {
    agent any

    environment {
        AWS_ECR_URI = '767828746131.dkr.ecr.us-east-1.amazonaws.com/netaproject/firstproject'
        AWS_DEFAULT_REGION = 'us-east-1'
        EC2_USER = 'ec2-user'  // Change to 'ubuntu' if using Ubuntu AMI
        EC2_HOST = '44.203.66.201'  // Replace with your EC2 public IP
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
                    sh 'docker build -t flask-app:latest .'
                }
            }
        }

        stage('Login to AWS ECR') {
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    script {
                        sh '''
                            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                            aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ECR_URI
                        '''
                    }
                }
            }
        }

        stage('Push Docke
