pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "<your-dockerhub-username>/helloweb:latest"
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${DOCKER_IMAGE} .'
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push ${DOCKER_IMAGE}'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f service.yaml'
            }
        }

        stage('Verify Deployment') {
            steps {
                sh 'kubectl rollout status deployment/helloweb'
                sh 'kubectl get pods'
            }
        }

        stage('Test Service') {
            steps {
                script {
                    def clusterIP = sh(script: "kubectl get svc helloweb -o jsonpath='{.spec.clusterIP}'", returnStdout: true).trim()
                    def port = sh(script: "kubectl get svc helloweb -o jsonpath='{.spec.ports[0].port}'", returnStdout: true).trim()
                    sh "curl --fail --silent --show-error http://${clusterIP}:${port}"
                }
            }
        }
    }

    post {
        success {
            echo "Deployment successful!"
        }
        failure {
            echo "Pipeline failed. Check logs."
        }
    }
}

