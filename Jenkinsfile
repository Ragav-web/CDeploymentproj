pipeline {
    agent any
    environment {
        KUBECONFIG_PATH = '/home/santhasoruban/.kube/config' 
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/CDeploymentproj.git'
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Configure kubeconfig for kubectl in Minikube
                    withKubeConfig([kubeConfig: KUBECONFIG_PATH]) {
                        sh 'kubectl apply -f deployment.yaml'
                        sh 'kubectl apply -f services.yaml'
                    }
                }
            }
        }
        stage('Test Application') {
            steps {
                script {
                    sleep(10) // Wait for Kubernetes objects to start
                    sh '''
                        STATUS=$(kubectl get pods -l app=helloapp -o jsonpath="{.items[0].status.phase}")
                        if [ "$STATUS" != "Running" ]; then
                            echo "Error: Pod is not running"
                            exit 1
                        fi
                    '''
                }
                echo 'Pod is running successfully!'
            }
        }
    }
    post {
        success {
            echo 'Deployment and testing successful!'
        }
        failure {
            echo 'Deployment or testing failed!'
        }
    }
}

