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

    triggers {
        cron(env.BRANCH_NAME=='master'? '#H 4 * * 7': '')
    }

    stages {
        stage ('Notify build started') {
            steps {
                slackSend(message: "Build Started - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL.replace(':8080','')}|Open>)")
            }
        }

        stage('Verify Delius-Core AMIS') {
            parallel {
                //stage('Verify Delius-Core Weblogic') { steps { script {verify_image('weblogic.json')}}}
                //stage('Verify Delius-Core Weblogic Admin') { steps { script {verify_image('weblogic-admin.json')}}}
                //stage('Verify Delius-Core OracleDB') { steps { script {verify_image('oracledb.json')}}}
                stage('Verify Delius-Core OracleDB 11g') { steps { script {verify_image('oracle11g.json')}}}
                //stage('Verify Delius-Core OracleDB 18c') { steps { script {verify_image('oracle18c.json')}}}
                //stage('Verify Delius-Core OracleDB 19c') { steps { script {verify_image('oracle19c.json')}}}
                //stage('Verify Delius-Core ApacheDS') { steps { script {verify_image('apacheds.json')}}}
                //stage('Verify Delius-Core Oracle-Client') { steps { script {verify_image('oracle-client.json')}}}
            }
        }

        stage('Build Delius-Core AMIS') {
            parallel {
                //stage('Build Delius-Core Weblogic') { steps { script {build_image('weblogic.json')}}}
                //stage('Build Delius-Core Weblogic Admin') { steps { script {build_image('weblogic-admin.json')}}}
                //stage('Build Delius-Core OracleDB') { steps { script {build_image('oracledb.json')}}}
                stage('Verify Delius-Core OracleDB 11g') { steps { script {verify_image('oracle11g.json')}}}
                //stage('Verify Delius-Core OracleDB 18c') { steps { script {verify_image('oracle18c.json')}}}
                //stage('Verify Delius-Core OracleDB 19c') { steps { script {verify_image('oracle19c.json')}}}
                //stage('Build Delius-Core ApacheDS') { steps { script {build_image('apacheds.json')}}}
                //stage('Build Delius-Core Oracle-Client') { steps { script {build_image('oracle-client.json')}}}
            }
        }
    }

    post {
        success {
            slackSend(message: "Build completed - ${env.JOB_NAME} ${env.BUILD_NUMBER}", color: 'good')
        }
        failure {
            slackSend(message: "Build failed - ${env.JOB_NAME} ${env.BUILD_NUMBER}", color: 'danger')
        }
    }
}
