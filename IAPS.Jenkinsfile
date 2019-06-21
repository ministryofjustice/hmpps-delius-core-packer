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

def build_win_image(filename) {
    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
        sh """
        #!/usr/env/bin bash
        set +x
        docker run --rm \
        -e BRANCH_NAME \
        -e ARTIFACT_BUCKET \
        -e WIN_ADMIN_PASS="${env.WIN_ADMIN_PASS}" \
        -e WIN_JENKINS_PASS="${env.WIN_JENKINS_PASS}" \
        -v `pwd`:/home/tools/data \
        mojdigitalstudio/hmpps-packer-builder \
        bash -c 'USER=`whoami` packer build """ + filename + "'"
    }
}

pipeline {
    agent { label "jenkins_slave"}

    options {
        ansiColor('xterm')
    }

    environment {
        // TARGET_ENV is set on the jenkins slave and defaults to dev
        WIN_ADMIN_PASS = '$(aws ssm get-parameters --names /${TARGET_ENV}/jenkins/windows/slave/admin/password --region eu-west-2 --with-decrypt | jq -r .Parameters[0].Value)'
        BRANCH_NAME = '$(echo $GIT_BRANCH | sed "s/\\//_/g")'
    }

    stages {
        stage('Verify Delius-Core IAPS') { 
            steps { 
                script {
                    verify_image('iaps.json')
                }
            }
        }

        stage('Build Delius-Core IAPS') { 
            steps { 
                script {
                    build_win_image('iaps.json')
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
