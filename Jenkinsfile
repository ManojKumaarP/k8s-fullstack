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
                      -t manojkumaar/k8s-fullstack-backend-noroot:${BUILD_NUMBER} \
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
                          manojkumaar/k8s-fullstack-backend-noroot:${BUILD_NUMBER}

                        docker push \
                          manojkumaar/k8s-fullstack-frontend:${BUILD_NUMBER}

                        docker logout
                    '''
                }
            }
        }

        stage('Update GitOps Image Tags') {
            steps {
                sh '''
                    set -eu

                    VALUES_FILE="GitOps/helm/fullstack/values.yaml"

                    test -f "$VALUES_FILE"

                    sed -i \
                      "s|^    tag: .*|    tag: \\"${BUILD_NUMBER}\\"|" \
                      "$VALUES_FILE"

                    echo "Updated Helm image tags:"
                    grep -A 4 -E '^(backend|frontend):' "$VALUES_FILE"

                    helm lint ./GitOps/helm/fullstack

                    helm template fullstack ./GitOps/helm/fullstack \
                      > /tmp/fullstack-rendered.yaml

                    echo "Helm validation completed successfully."
                '''
            }
        }
    }

    post {
        success {
            echo 'CI pipeline completed successfully.'
        }

        failure {
            echo 'Pipeline failed. Check the stage and console output.'
        }

        always {
            echo 'Pipeline execution finished.'
        }
    }
}
