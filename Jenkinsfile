pipeline {
    agent any
    environment {
        AWS_ECR_URI = '767828746131.dkr.ecr.us-east-1.amazonaws.com/netaproject/firstproject'
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')  // Ensure this matches the Jenkins credentials ID
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')  // Ensure this matches the Jenkins credentials ID
        AWS_DEFAULT_REGION = 'us-east-1'
        EC2_USER = 'ec2-user'  // Change based on your EC2 AMI (e.g., ubuntu for Ubuntu AMIs)
        EC2_HOST = '44.203.66.201'  // Replace with your EC2 instance's public IP
        SSH_KEY = credentials('EC2_SSH_PRIVATE_KEY')  // Store EC2 SSH key in Jenkins credentials
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
                    // Build the correct image name
                    sh 'docker build -t flask-app:latest .'
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
        stage('Tag and Push Docker Image to ECR') {
            steps {
                script {
                    sh '''
                        docker tag flask-app:latest $AWS_ECR_URI:latest
                        docker push $AWS_ECR_URI:latest
                    '''
                }
            }
        }
         stage('Deploy to EC2') {
            steps {
                script {
                    sh '''
                        ssh -o StrictHostKeyChecking=no -i $SSH_KEY $EC2_USER@$EC2_HOST << 'EOF'
                        echo "Logging into AWS ECR..."
                        aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ECR_URI
                        
                        echo "Stopping existing container..."
                        docker stop flask-container || true
                        docker rm flask-container || true

                        echo "Pulling latest Docker image..."
                        docker pull $AWS_ECR_URI:latest

                        echo "Running new container..."
                        docker run -d -p 5000:5000 --name flask-container $AWS_ECR_URI:latest
                        EOF
                    '''
                }
            }
         }
    }
}
