
pipeline {
    agent any 
     stages {
        stage('Clone') {
            steps {
                script {
                    try {
                        git branch: 'master',
                        url: "https://github.com/hieunguyenbn/autoDial.git"
                    } catch (err) {
                        echo "The prplOS has already been downloaded!"
                    }
                }
            }
        }
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
