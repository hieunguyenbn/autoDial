
pipeline {
    agent any 
     stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        stage('Show Git Info') {
            steps {
                script {
                    echo "Branch: ${env.GIT_BRANCH}"
                    echo "Commit ID: ${env.GIT_COMMIT}"
                    echo "Commit ID: ${env.GIT_PREVIOUS_SUCCESSFUL_COMMIT}"
                }
            }
        }
     }
}
