
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

         stage("Display changeset?") {
             steps {
                 script {
                     checkout(scm)
                     def changeLogSets = currentBuild.changeSets
                     echo("changeSets=" + changeLogSets)
                     for (int i = 0; i < changeLogSets.size(); i++) {
                         def entries = changeLogSets[i].items
                         for (int j = 0; j < entries.length; j++) {
                             def entry = entries[j]
                             echo "${entry.commitId} by ${entry.author} on ${new Date(entry.timestamp)}: ${entry.msg}"
                             def files = new ArrayList(entry.affectedFiles)
                             for (int k = 0; k < files.size(); k++) {
                                 def file = files[k]
                                 echo " ${file.editType.name} ${file.path}"
                             }
                         }
                     }
                 }
             }
         }
     }
}
