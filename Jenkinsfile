def shouldModuleBuild(module, params) {
    switch(module) {
        case "admin":
            return params.admin == "yes"
        case "product":
            return params.product == "yes"
        default:
            return false
    }
} 

def getDockerFile(module) {
    switch(module) {
        case "admin":
            return "app.j2"
        case "product":
            return "app.j2"
        default:
            return false
    }
}


pipeline {
    agent any
    environment {
        PROJECT                 = "ecom"
        IREPO                   = "eks-ci-stack"
        MWREPO                  = "doing-crud-with-fastapi"
        SLACK_WEBHOOK_TOKEN     = "xxxxxxxxxxxxxxxx"
        SLACK_CHANNEL           = "py-notify" 
        REGION                  = 'ap-southeast-1'   
    }

    parameters {
        string(name: 'SLACK_CHANNEL', description: 'Default Slack channel to send messages to', defaultValue: 'py-notify')

        choice(choices: ['uat', 'prod'], description: 'Select Environment', name: 'ENVIRONMENT')
        choice(name: 'terraform', choices: ['no' , 'yes'], description: 'Run Terraform')
        // choice(name: 'recycleinstance', choices: ['no', 'yes'], description: 'Recycle Instances?')
        choice(name: 'eksdeployMode', choices: ['live' , 'dryrun'], description: 'Deployment Mode')
        choice(name: 'ekshelmchanges', choices: ['no' , 'yes'], description: 'Helm upgrade?')
        choice(name: 'dockersystemprune', choices: ['no' , 'yes'], description: 'Docker system prune?')
        string(defaultValue: "release-tag", description: 'MW Release Tag', name: 'MWRELEASETAG')
        choice(name: 'admin', choices: ['no' , 'yes'], description: 'Do you want to deploy Ecom Admin MW?')
        choice(name: 'product', choices: ['no' , 'yes'], description: 'Do you want to deploy Ecom Product MW?')
        
        
    }
    stages{
        stage('Infra Code Checkout & Slack Notification') {
            parallel{
                stage('Slack Notification') {
                    steps {
                        dir("${workspace}") {
                        script{
                            BUILD_TRIGGER_BY = "${currentBuild.getBuildCauses()[0].userId}"
                            STATUS = "Started" 
                            JOB_NAME = "${env.ENVIRONMENT}-${env.PROJECT}-jenkins"
                            sh script:"pip3 install slack_sdk && python3 slack.py ${BUILD_TRIGGER_BY} ${env.BUILD_NUMBER} ${JOB_NAME} ${STATUS} ${env.SLACK_WEBHOOK_TOKEN} ${env.SLACK_CHANNEL}"
                            }
                        }
                    }
                }
                stage('Infra Code Checkout'){
                    steps{
                        script{
                            if (env.ENVIRONMENT == 'prod'){
                                IBRNCH = 'master'
                            }
                            if (env.ENVIRONMENT == 'uat'){
                                IBRNCH = 'develop'
                            }
                        }
                        git(url: "https://github.com/musatee/${IREPO}", branch: "${IBRNCH}" , credentialsId: 'ecom-poc')
                    }
                }   
            }
        }
        stage ('MW Code Checkout') {
            matrix {
                axes {
                    axis {
                        name 'REPO'
                        values "doing-crud-with-fastapi"
                    }
                }
                stages{
                    stage ('Checkout ${REPO}') {
                        steps{
                            dir("${REPO}") {
                                git(url: "https://github.com/musatee/${REPO}", branch: "master" , credentialsId: 'ecom-poc')
                            }
                        }
                    }
                }
            }
        }

        stage("MW Checkout to Release Tag") {
            when {
                anyOf {
                    expression { params.admin == "yes" }
                    expression { params.product == "yes" }
                }
            }
            steps{
                dir ("${env.WORKSPACE}/${MWREPO}"){
                    sh "git checkout ${params.MWRELEASETAG}"
                }
            }
        }
        
        stage('Terraform Plan') {
            when {
                expression {
                    params.terraform == "yes"
                }
            }
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh "terraform workspace select ${params.ENVIRONMENT} || terraform workspace new ${params.ENVIRONMENT}"
                    sh "terraform plan -out=myplan"
                }
            }
        }
        stage('Terraform Apply') {
            when {
                expression {
                    params.terraform == "yes"
                }
            }
            steps {
                input 'Do you want to proceed?'
                dir('terraform') {
                    sh 'terraform apply -input=false myplan'
                }
            }
        }
        stage('Docker system prune') {
            when {
                expression {
                    params.dockersystemprune == "yes"
                }
            }
            steps {
                sh "docker system prune -af"
            }
        }
        stage('Admin & Product MW Build') {
            matrix {
                axes {
                    axis {
                        name 'module'
                        values "admin", "product"
                    }
                }
                stages{
                    stage ('Build ${MODULE}') {
                        when {
                            expression { shouldModuleBuild(module, params) }
                        }
                        steps {
                            dir("${env.WORKSPACE}") {
                                sh script:"ansible-playbook ansible/build-module.yaml -e workspace=${env.WORKSPACE} -e CodeRepo=${env.MWREPO} -e dockerfileName=${getDockerFile(module)} -e module=${MODULE} -e env=${params.ENVIRONMENT}",label:"Ecom Admin & Product MW Build"
                            }
                        }
                    }
                }
            }
        }
        stage("Helm Diff") {
            when {
                expression {
                    params.ekshelmchanges == "yes"
                }
            }
            steps {
                dir("${env.WORKSPACE}/helmfile") {
                    sh "bash chart-downloader.sh"
                    sh "aws eks update-kubeconfig --region ${env.REGION} --name ${params.ENVIRONMENT}-${env.PROJECT}-eks-cluster"
                    sh "helmfile -f ./helmfile.yaml -e ${params.ENVIRONMENT} diff"
                }
            }
        }
        stage("Helm Upgrade") {
            when {
                expression {
                    params.ekshelmchanges == "yes" && params.eksdeployMode == "live"
                }
            }
            steps {
                input 'Do you want to proceed?'
                dir("${env.WORKSPACE}/helmfile") {
                    sh "bash chart-downloader.sh"
                    sh "aws eks update-kubeconfig --region ${env.REGION} --name ${params.ENVIRONMENT}-${env.PROJECT}-eks-cluster"
                    sh "helmfile -f ./helmfile.yaml -e ${params.ENVIRONMENT} apply"
                    script{
                        if (params.admin == "yes"){
                            sh "kubectl rollout restart deploy admin -n ecom"
                        }
                        if (params.product == "yes"){
                            sh "kubectl rollout restart deploy product -n ecom"
                        }
                    }
                }
            }
        }
    }
    post {
        aborted {
            dir("${workspace}") {
                script{
                    BUILD_TRIGGER_BY = "${currentBuild.getBuildCauses()[0].userId}"
                    STATUS = "Aborted" 
                    JOB_NAME = "${env.ENVIRONMENT}-${env.PROJECT}-jenkins"
                    sh script:"python3 slack.py ${BUILD_TRIGGER_BY} ${env.BUILD_NUMBER} ${JOB_NAME} ${STATUS} ${env.SLACK_WEBHOOK_TOKEN} ${env.SLACK_CHANNEL}"
                }
            }
        }
        failure {
            dir("${workspace}") {
                script{
                    BUILD_TRIGGER_BY = "${currentBuild.getBuildCauses()[0].userId}"
                    STATUS = "Failed" 
                    JOB_NAME = "${env.ENVIRONMENT}-${env.PROJECT}-jenkins"
                    sh script:"python3 slack.py ${BUILD_TRIGGER_BY} ${env.BUILD_NUMBER} ${JOB_NAME} ${STATUS} ${env.SLACK_WEBHOOK_TOKEN} ${env.SLACK_CHANNEL}"
                }
            }
        }
        success {
            dir("${workspace}") {
                script{
                    BUILD_TRIGGER_BY = "${currentBuild.getBuildCauses()[0].userId}"
                    STATUS = "Successful" 
                    JOB_NAME = "${env.ENVIRONMENT}-${env.PROJECT}-jenkins"
                    sh script:"python3 slack.py ${BUILD_TRIGGER_BY} ${env.BUILD_NUMBER} ${JOB_NAME} ${STATUS} ${env.SLACK_WEBHOOK_TOKEN} ${env.SLACK_CHANNEL}"
                }
            }
        }
    }
}