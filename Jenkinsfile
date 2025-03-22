
pipeline {
    agent any 
     stages {
        stage('Get Previous Build Info') {
            steps {
                script {
                    def previousBuild = currentBuild.getPreviousBuild().result
                    if (previousBuild != null) {
                        def prevFile = previousBuild.getArtifacts().find { it.fileName == 'git_info.txt' }
                        if (prevFile) {
                            def prevInfo = previousBuild.getArtifactManager().root().child(prevFile.relativePath).open().text
                            def prevCommit = prevInfo.findAll(/(?<=COMMIT_ID=).*/)[0].trim()
                            def prevBranch = prevInfo.findAll(/(?<=BRANCH=).*/)[0].trim()

                            echo "Previous Commit ID: ${prevCommit}"
                            echo "Previous Branch: ${prevBranch}"
                        } else {
                            echo "No previous commit ID found."
                        }
                    } else {
                        echo "No previous build available."
                    }
                }
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
        stage('Save Commit and Branch Info') {
            steps {
                script {
                    sh """
                        echo "COMMIT_ID=${env.GIT_COMMIT}" > git_info.txt
                        echo "BRANCH=${env.GIT_BRANCH ?: env.BRANCH_NAME}" >> git_info.txt
                    """
                    archiveArtifacts artifacts: 'git_info.txt', fingerprint: true
                }
            }
        }
     }
}
