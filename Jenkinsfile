pipeline {
    agent any
 
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'git@github.com:Ragav-web/CDeploymentproj.git', credentialsId: 'a9739d61-17f0-4800-8386-f8a12eb1fc3f'
            }
        }
 
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    env.KUBECONFIG = "C:\\Users\\santhasoruban_s\\.kube\\config"
                    withCredentials([string(credentialsId: 'secrets', variable: 'SECRET_VALUE')]) {
                        bat """
                            powershell.exe minikube config set-context minikube
                            powershell.exe kubectl apply -f deployment.yaml --validate=false
                            powershell.exe kubectl apply -f service.yaml --validate=false
                        """
                    }
                }
            }
        }
 
        stage('Test') {
            steps {
                script {
                    env.KUBECONFIG = "C:\\Users\\santhasoruban_s\\.kube\\config"
                    withCredentials([string(credentialsId: 'secrets', variable: 'SECRET_VALUE')]) {
                        bat '''
                            powershell "kubectl get pods"
                            powershell "Invoke-WebRequest -UseBasicParsing http://127.0.0.1:58820"
                        '''
                    }
                }
            }
        }
    }
}
