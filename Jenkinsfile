boolean is_new_commits = false
pipeline {
    agent any 
    parameters {
        booleanParam(name: 'skip', defaultValue: false, description: 'Set to true to skip the stage')
    }
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
                    if ("${env.GIT_COMMIT}" == "${env.GIT_PREVIOUS_SUCCESSFUL_COMMIT}") {
                        echo "Already build!!"
                        is_new_commits = false
                    } else {
                        echo "Different! Start build a new one!"
                        is_new_commits = true
                    }
                }
            }
        }
        stage('Deliver') {
            when { expression { params.skip != true } }
            steps {
                script {
                    if (is_new_commits == true) {
                        echo "BUILD A NEW COMMIT"
                    } else {
                        echo "DONE TEST"
                    }
                }
            }
        }
        stage('FINISH') {
            steps {
                script {
                    echo "DONE THE BUILD PROCESS"
                }
            }
        }
    }
}
