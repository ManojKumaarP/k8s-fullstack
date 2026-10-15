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
                sh '''
                docker build -t YOUR_DOCKERHUB_USERNAME/k8s-fullstack-frontend:${BUILD_NUMBER} ./FrontEnd
                docker build -t YOUR_DOCKERHUB_USERNAME/k8s-fullstack-backend:${BUILD_NUMBER} ./BackEnd
                echo "Docker images built successfully."'''
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
