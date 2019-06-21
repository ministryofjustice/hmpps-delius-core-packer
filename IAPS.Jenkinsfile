def verify_image(filename) {
    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
        sh '''
        #!/usr/env/bin bash
        docker run --rm \
        -e BRANCH_NAME \
        -e TARGET_ENV \
        -e ARTIFACT_BUCKET \
        -e ZAIZI_BUCKET \
        -v `pwd`:/home/tools/data \
        mojdigitalstudio/hmpps-packer-builder \
        bash -c 'USER=`whoami` packer validate \
        -var \'github_access_token=`aws ssm get-parameter --name /jenkins/github/accesstoken --with-decryption --output text --query Parameter.Value --region eu-west-2`\' \
        ''' + filename + "'"
    }
}

def build_image(filename) {
    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
        sh '''
        #!/usr/env/bin bash
        docker run --rm \
        -e BRANCH_NAME \
        -e TARGET_ENV \
        -e ARTIFACT_BUCKET \
        -e ZAIZI_BUCKET \
        -v `pwd`:/home/tools/data \
        mojdigitalstudio/hmpps-packer-builder \
        bash -c 'USER=`whoami` packer build \
        -var \'github_access_token=`aws ssm get-parameter --name /jenkins/github/accesstoken --with-decryption --output text --query Parameter.Value --region eu-west-2`\' \
        ''' + filename + "'"
    }
}

pipeline {
    agent { label "jenkins_slave"}

    options {
        ansiColor('xterm')
    }

    stages {
        stage('Verify Delius-Core IAPS') { 
            steps { 
                sh '''
                    #! bin/bash +x
                    ls -ail
                    ls -ail scripts/
                    ls -ail scripts/windows/
                '''
                script {
                    verify_image('iaps.json')
                }
            }
        }

        stage('Build Delius-Core IAPS') { 
            steps { 
                script {
                    build_image('iaps.json')
                }
            }
        }
    }
    post {
        always {
            deleteDir() /* clean up our workspace */
        }
    }
}
