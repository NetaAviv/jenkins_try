pipeline {
    agent any
    environment {
        AWS_ECR_URI = '767828746131.dkr.ecr.us-east-1.amazonaws.com/netaproject/firstproject'
        AWS_DEFAULT_REGION = 'us-east-1'
        EC2_USER = 'ec2-user'  
        EC2_HOST = '44.203.66.201'  
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
        stage('Deploy to EC2') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'EC2_SSH_PRIVATE_KEY', keyFileVariable: 'SSH_KEY')]) {
                    script {
                        sh '''
                            ssh -o StrictHostKeyChecking=no -i $SSH_KEY $EC2_USER@$EC2_HOST << 'EOF'
                            set -e  

                            echo "Logging into AWS ECR..."
                            export AWS_DEFAULT_REGION="us-east-1"
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
}
