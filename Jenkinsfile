pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1'
        AWS_ACCOUNT_ID = '767828746131'
        ECR_REPO_NAME = 'netaproject/firstproject'
    }
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/NetaAviv/jenkins_try.git'
            }
        }
        stage('Login to ECR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 767828746131, usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    script {
                        sh '''
                            # Configure AWS CLI with Jenkins credentials
                            aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                            aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                            aws configure set region $AWS_REGION

                            # Log in to ECR using docker login
                            aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                        '''
                    }
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                sh '''
                    # Build Docker image
                    docker build -t $ECR_REPO_NAME .

                    # Tag Docker image for ECR
                    docker tag $ECR_REPO_NAME:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:latest
                '''
            }
        }
        stage('Push to ECR') {
            steps {
                sh '''
                    # Push Docker image to ECR
                    docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:latest
                '''
            }
        }
    }
}
