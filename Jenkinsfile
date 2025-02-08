pipeline {
    agent any

    environment {
        // Define the AWS region, ECR repository, and Docker image name
        AWS_REGION = 'us-west-2'  // change to your AWS region
        ECR_REPOSITORY = 'my-flask-app-repo'  // change to your ECR repository name
        IMAGE_NAME = 'my-flask-app'  // change to your desired image name
        AWS_ACCOUNT_ID = '123456789012'  // your AWS account ID
        DOCKER_TAG = 'latest'  // change to the desired image tag
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Checkout the GitHub repository
                git branch: 'main', url: 'https://github.com/your-username/your-repo.git'  // Change the URL to your repo
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Log in to AWS ECR
                    sh '''
                        $(aws ecr get-login --no-include-email --region $AWS_REGION)
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
