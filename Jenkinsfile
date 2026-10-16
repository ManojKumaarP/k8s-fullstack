
pipeline {
    agent any

    tools {
        jdk 'JDK21'
    }

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo 'Source code checked out successfully.'
            }
        }

        stage('Check Java and Maven') {
            steps {
                sh '''
                    set -eu
                    echo "JAVA_HOME=$JAVA_HOME"
                    java -version
                    javac -version
                    mvn -version
                '''
            }
        }

        stage('Backend Build and Test') {
            steps {
                dir('BackEnd') {
                    sh 'mvn clean install'
                    echo 'Backend build and tests completed successfully.'
                }
            }
        }

        stage('Frontend Validation') {
            steps {
                dir('FrontEnd') {
                    sh '''
                        set -eu
                        test -f index.html
                        test -f app.js
                        test -f style.css
                        echo "Frontend files validated successfully."
                    '''
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                sh '''
                    set -eu

                    docker build \
                      -t manojkumaar/k8s-fullstack-frontend:${BUILD_NUMBER} \
                      ./FrontEnd

                    docker build \
                      -t manojkumaar/k8s-fullstack-backend:${BUILD_NUMBER} \
                      ./BackEnd

                    echo "Docker images built successfully."
                '''
            }
        }

        stage('Push Images to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKERHUB_USER',
                        passwordVariable: 'DOCKERHUB_TOKEN'
                    )
                ]) {
                    sh '''
                        set -eu
                        set +x

                        echo "$DOCKERHUB_TOKEN" | docker login \
                            --username "$DOCKERHUB_USER" \
                            --password-stdin

                        docker push \
                          manojkumaar/k8s-fullstack-backend:${BUILD_NUMBER}

                        docker push \
                          manojkumaar/k8s-fullstack-frontend:${BUILD_NUMBER}

                        docker logout
                    '''
                }
            }
        }

        stage('Kubernetes Pre-Deployment Check') {
            steps {
                sh '''
                    set -eu

                    echo "Checking Kubernetes connectivity..."
                    kubectl get nodes

                    echo "Checking application namespace..."
                    kubectl get namespace fullstack

                    echo "Checking existing Deployments..."
                    kubectl get deployments \
                      backend frontend -n fullstack

                    echo "Checking Deployment container names..."
                    kubectl get deployment backend frontend \
                      -n fullstack \
                      -o custom-columns='NAME:.metadata.name,CONTAINERS:.spec.template.spec.containers[*].name'
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    set -eu

                    echo "Deploying backend image..."
                    kubectl set image deployment/backend \
                      backend=manojkumaar/k8s-fullstack-backend:${BUILD_NUMBER} \
                      -n fullstack

                    echo "Deploying frontend image..."
                    kubectl set image deployment/frontend \
                      frontend=manojkumaar/k8s-fullstack-frontend:${BUILD_NUMBER} \
                      -n fullstack

                    echo "Waiting for backend rollout..."
                    kubectl rollout status deployment/backend \
                      -n fullstack --timeout=180s

                    echo "Waiting for frontend rollout..."
                    kubectl rollout status deployment/frontend \
                      -n fullstack --timeout=180s

                    echo "Verifying deployed images..."
                    kubectl get deployments \
                      backend frontend -n fullstack \
                      -o custom-columns='NAME:.metadata.name,READY:.status.readyReplicas,IMAGES:.spec.template.spec.containers[*].image'

                    echo "Checking application Pods..."
                    kubectl get pods -n fullstack

                    echo "Kubernetes deployment completed successfully."
                '''
            }
        }
    }

    post {
        success {
            echo 'CI/CD pipeline and Kubernetes deployment completed successfully.'
        }

        failure {
            echo 'Pipeline failed. Check the stage and console output.'
        }

        always {
            echo 'Pipeline execution finished.'
        }
    }
}
