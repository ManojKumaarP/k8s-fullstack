pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    } 
    
    stages {
        stage ('Checkout') {
            steps {
                checkout scm
                echo 'Source code checked out successfully.'
            }
        }
    }
    
    post {
        sucess {
            echo 'Pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Please check the logs for details.'
        }
        always {
            echo 'Pipeline execution finished.'
        }
    }
}