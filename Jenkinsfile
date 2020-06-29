def set_branch_name() {
    return env.GIT_BRANCH.replace("/", "_")
}

def verify_image(filename) {
    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
        sh '''
        #!/usr/env/bin bash
        docker run --rm \
        -e BRANCH_NAME \
        -e IMAGE_TAG_VERSION \
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
        -e IMAGE_TAG_VERSION \
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

def get_git_latest_master_tag() {
    git_branch = sh (
                    script: """docker run --rm \
                                    -v `pwd`:/home/tools/data \
                                    mojdigitalstudio/hmpps-packer-builder \
                                    bash -c 'git describe --tags --exact-match'""",
                    returnStdout: true
                 ).trim()    
    return git_branch
}

def set_tag_version() {
    branchName = set_branch_name()
    if (branchName == "master") {
        git_tag = get_git_latest_master_tag()
    }
    else {
        git_tag = '0.0.0'
    }
    return git_tag
}

pipeline {
    agent { label "jenkins_slave"}

    options {
        ansiColor('xterm')
    }

    triggers {
        cron(env.BRANCH_NAME=='master'? '#H 4 * * 7': '')
    }

    environment {
        // TARGET_ENV is set on the jenkins slave and defaults to dev
        AWS_REGION        = "eu-west-2"
        BRANCH_NAME       = set_branch_name()
        IMAGE_TAG_VERSION = set_tag_version()
}

    stages {
        stage ('Notify build started') {
            steps {
                slackSend(message: "Build Started - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL.replace(':8080','')}|Open>)")
            }
        }

        stage('Output Branch Name and Tag') {
            steps {
                sh('echo $BRANCH_NAME')
                sh('echo $IMAGE_TAG_VERSION')
            }
        }

        stage('Verify Delius-Core AMIS') {
            parallel {
                //stage('Verify Delius-Core Weblogic') { steps { script {verify_image('weblogic.json')}}}
                //stage('Verify Delius-Core Weblogic Admin') { steps { script {verify_image('weblogic-admin.json')}}}
                //stage('Verify OracleDB') { steps { script {verify_image('oracledb.json')}}}
                stage('Verify OracleDB 11g') { steps { script {verify_image('oracle11g.json')}}}
                stage('Verify OracleDB 18c') { steps { script {verify_image('oracle18c.json')}}}
                //stage('Verify Delius-Core Oracle-Client') { steps { script {verify_image('oracle-client.json')}}}
            }
        }

        stage('Build Delius-Core AMIS') {
            parallel {
                //stage('Build Delius-Core Weblogic') { steps { script {build_image('weblogic.json')}}}
                //stage('Build OracleDB') { steps { script {build_image('oracledb.json')}}}
                stage('Build OracleDB 11g') { steps { script {build_image('oracle11g.json')}}}
                stage('Build OracleDB 18c') { steps { script {verify_image('oracle18c.json')}}}
                //stage('Build Delius-Core Oracle-Client') { steps { script {build_image('oracle-client.json')}}}
            }
        }

        stage('Build Delius-Core Weblogic Admin AMI') {
            parallel {
                stage('Build Delius-Core Weblogic Admin') { steps { script {build_image('weblogic-admin.json')}}}
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
