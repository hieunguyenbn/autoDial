
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
        stage('Compare Current and Previous Builds') {
            steps {
                script {
                    def previousBuild = currentBuild.previousBuild
                    if (previousBuild != null && previousBuild.result == "SUCCESS") {
                        echo "Comparing current build with previous build #${previousBuild.number}"

                        def currentCommits = []
                        def previousCommits = []

                        // Get current build changes
                        for (changeSet in currentBuild.changeSets) {
                            for (entry in changeSet.items) {
                                currentCommits.add(entry.commitId)
                            }
                        }

                        // Get previous build changes
                        for (changeSet in previousBuild.changeSets) {
                            for (entry in changeSet.items) {
                                previousCommits.add(entry.commitId)
                            }
                        }

                        echo "Current Build Commits: ${currentCommits}"
                        echo "Previous Build Commits: ${previousCommits}"

                        if (previousCommits.size() > 0 && currentCommits.size() > 0) {
                            def newCommits = currentCommits - previousCommits
                            def removedCommits = previousCommits - currentCommits

                            echo "New Commits in Current Build: ${newCommits}"
                            echo "Commits Removed Since Previous Build: ${removedCommits}"
                        } else {
                            echo "No changes detected between builds."
                        }
                    } else {
                        echo "No successful previous build found. Skipping comparison."
                    }
                }
            }
        }
     }
}
