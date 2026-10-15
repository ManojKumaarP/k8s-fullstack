
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
        stage('Backend Build and test') {
            steps {
                dir('BackEnd') {
                    sh 'mvn clean install'
                    echo 'Backend build and tests completed successfully.'
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