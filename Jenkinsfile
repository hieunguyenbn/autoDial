
pipeline {
    agent any 
     stages {
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
