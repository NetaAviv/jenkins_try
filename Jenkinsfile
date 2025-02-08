pipeline {
    agent any

    environment {
        // Define the AWS region, ECR repository, and Docker image name
        AWS_REGION = 'us-east-1'  // change to your AWS region
        ECR_REPOSITORY = 'netaproject/firstproject'  // change to your ECR repository name
        IMAGE_NAME = 'my-flask-app'  // change to your desired image name
        AWS_ACCOUNT_ID = '767828746131'// your AWS account ID
        DOCKER_TAG = 'latest'  // change to the desired image tag
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Checkout the GitHub repository
                git branch: 'main', url: 'https://github.com/NetaAviv/jenkins_try.git'  // Change the URL to your repo
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Log in to AWS ECR
                    sh '''
                        $(aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 767828746131.dkr.ecr.us-east-1.amazonaws.com)
                    '''
                    
                    // Build the Docker image from the Dockerfile
                    sh '''
                        docker build -t $IMAGE_NAME:$DOCKER_TAG .
                    '''
                }
            }
        }

        stage('Tag Docker Image') {
            steps {
                script {
                    // Tag the Docker image with the ECR repository URL
                    sh '''
                        docker tag $IMAGE_NAME:$DOCKER_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY:$DOCKER_TAG
                    '''
                }
            }
        }

        stage('Push to AWS ECR') {
            steps {
                script {
                    // Push the image to AWS ECR
                    sh '''
                        docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY:$DOCKER_TAG
                    '''
                }
            }
        }
    }

    post {
        always {
            // Clean up docker images to free up space
            sh 'docker system prune -af'
        }
    }
}
