
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
                        params.skip = true
                    } else {
                        echo "Different! Start build a new one!"
                    }
                }
            }
        }
        stage('Deliver') {
            when { expression { params.skip != true } }
            steps {
                sh "tar -czf prplos_${working_branch}_${env.GIT_COMMIT}.tar.gz ./bin/targets/intel_x86/lgm"
                emailext (
                    attachLog: true,
                    attachmentsPattern: '*.tar.gz',
                    body: '$DEFAULT_CONTENT',
                    subject: '$DEFAULT_SUBJECT', 
                    to: '$DEFAULT_RECIPIENTS')
            }
        }
     }
}
