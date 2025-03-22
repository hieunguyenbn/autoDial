
pipeline {
    agent any 
     stages {
         stage('Show Git Info') {
            steps {
                script {
                    echo "Branch: ${env.GIT_BRANCH}"
                    echo "Commit ID: ${env.GIT_COMMIT}"
                    echo "Previous success Commit ID: ${env.GIT_PREVIOUS_SUCCESSFUL_COMMIT}"
                }
            }
        }
        stage('Compare Current and Previous Builds') {
            steps {
                script {
                    if ("${env.GIT_COMMIT}" == " ${env.GIT_PREVIOUS_SUCCESSFUL_COMMIT}") {
                        echo "Already build!!"
                    } else {
                        echo "Different! Start build a new one!"
                    }
                }
            }
        }
     }
}
