
pipeline {
    agent any

    tools {
        jdk 'JDK21'
    }

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    environment {
        BACKEND_IMAGE = 'manojkumaar/employee-backend-nonroot'
        FRONTEND_IMAGE = 'manojkumaar/employee-frontend'
        VALUES_FILE = 'GitOps/helm/fullstack/values.yaml'
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
                      -t "${FRONTEND_IMAGE}:${BUILD_NUMBER}" \
                      ./FrontEnd

                    docker build \
                      -t "${BACKEND_IMAGE}:${BUILD_NUMBER}" \
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

                        trap 'docker logout >/dev/null 2>&1 || true' EXIT

                        echo "$DOCKERHUB_TOKEN" | docker login \
                            --username "$DOCKERHUB_USER" \
                            --password-stdin

                        docker push "${BACKEND_IMAGE}:${BUILD_NUMBER}"
                        docker push "${FRONTEND_IMAGE}:${BUILD_NUMBER}"

                        echo "Both images pushed successfully."
                    '''
                }
            }
        }

        stage('Update GitOps Image Tags') {
            steps {
                sh '''
                    set -eu

                    test -f "$VALUES_FILE"

                    # Update only the tag following each expected repository.
                    sed -i \
                      "/^    repository: manojkumaar\\/employee-backend-nonroot$/{
                        n
                        s/^    tag: .*/    tag: \\"${BUILD_NUMBER}\\"/
                      }" "$VALUES_FILE"

                    sed -i \
                      "/^    repository: manojkumaar\\/employee-frontend$/{
                        n
                        s/^    tag: .*/    tag: \\"${BUILD_NUMBER}\\"/
                      }" "$VALUES_FILE"

                    # Fail if either expected image tag was not updated.
                    grep -A 2 -F \
                      'repository: manojkumaar/employee-backend-nonroot' \
                      "$VALUES_FILE" | grep -Fq "tag: \\"${BUILD_NUMBER}\\""

                    grep -A 2 -F \
                      'repository: manojkumaar/employee-frontend' \
                      "$VALUES_FILE" | grep -Fq "tag: \\"${BUILD_NUMBER}\\""

                    echo "Updated image configuration:"
                    grep -n -A 3 -E '^backend:|^frontend:' "$VALUES_FILE"

                    git diff --check
                    git diff -- "$VALUES_FILE"
                '''
            }
        }

        stage('Commit and Push GitOps Update') {
            steps {
                // Requires a Jenkins Git username/password credential
                // whose password is a GitHub PAT with repository write access.
                withCredentials([
                    gitUsernamePassword(
                        credentialsId: 'github-push-creds',
                        gitToolName: 'Default'
                    )
                ]) {
                    sh '''
                        set -eu

                        git config user.name "Jenkins CI"
                        git config user.email "jenkins-ci@users.noreply.github.com"

                        # Stage only the intended GitOps file.
                        git add "$VALUES_FILE"

                        if git diff --cached --quiet -- "$VALUES_FILE"; then
                            echo "No GitOps changes to commit."
                            exit 0
                        fi

                        git commit -m \
                          "chore(gitops): update fullstack images to build ${BUILD_NUMBER}"

                        # Assumes this pipeline builds the main branch
                        # and Argo CD watches main.
                        git push origin HEAD:main

                        echo "GitOps update pushed to GitHub."
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'CI pipeline completed. GitOps update pushed if changes were present.'
        }

        failure {
            echo 'Pipeline failed. Inspect the failed stage before retrying.'
        }

        always {
            echo 'Pipeline execution finished.'
        }
    }
}