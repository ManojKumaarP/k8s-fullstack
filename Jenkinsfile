
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
                /* groovylint-disable-next-line GStringExpressionWithinString */
                sh '''
                    docker build -t manojkumaar/k8s-fullstack-frontend:${BUILD_NUMBER} ./FrontEnd
                    docker build -t manojkumaar/k8s-fullstack-backend:${BUILD_NUMBER} ./BackEnd
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
                    /* groovylint-disable-next-line GStringExpressionWithinString */
                    sh '''
                        set +x
                        echo "$DOCKERHUB_TOKEN" | docker login \
                            --username "$DOCKERHUB_USER" \
                            --password-stdin

                        docker push manojkumaar/k8s-fullstack-frontend:${BUILD_NUMBER}
                        docker push manojkumaar/k8s-fullstack-backend:${BUILD_NUMBER}

                        docker logout
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully.'
        }

        failure {
            echo 'Pipeline failed. Check the console output.'
        }

        always {
            echo 'Pipeline execution finished.'
        }
    }
}
