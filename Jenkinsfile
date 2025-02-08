pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1'
        AWS_ACCOUNT_ID = '767828746131'
        ECR_REPO_NAME = 'netaproject/firstproject'  // Replace with your ECR repository name
        AWS_ACCESS_KEY_ID = credentials('1a8b4a50-b7eb-4d9d-af75-6226fde78a58')  // Fetch AWS access key ID
        AWS_SECRET_ACCESS_KEY = credentials('1a8b4a50-b7eb-4d9d-af75-6226fde78a58')  // Fetch AWS secret access key
    }
    stages {
        stage('Checkout Code') {
            steps {
                // Checkout the code from GitHub repository
                git branch: 'main', url: 'https://github.com/NetaAviv/jenkins_try.git'
            }
        }
        stage('Login to ECR') {
            steps {
                script {
                    // Log in to AWS ECR using AWS CLI (credentials are automatically passed via environment variables)
                    sh '''
                        aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                    '''
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                // Build your Docker image
                sh '''
                    docker build -t $ECR_REPO_NAME .
                    docker tag $ECR_REPO_NAME:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:latest
                '''
            }
        }
        stage('Push Docker Image to ECR') {
            steps {
                // Push the Docker image to AWS ECR
                sh '''
                    docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:latest
                '''
            }
        }
    }
}
