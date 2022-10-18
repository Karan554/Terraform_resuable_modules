pipeline {
    agent any
    
     options {
        ansiColor('xterm')
    }

    parameters {
        string(name: 'environment', defaultValue: 'default', description: 'Workspace/environment file to use for deployment')
        string(name: 'vars_param', defaultValue: 'dev-east', description: 'Workspace/vars file to use for deployment')
        string(name: 'version', defaultValue: '', description: 'Version variable to pass to Terraform')
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        booleanParam(name: 'autoApprove2', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }
    
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        TF_IN_AUTOMATION      = '1'
    }

    stages {
        
        stage('GetCode'){
            steps{
                git branch: 'main',
                url: 'https://github.com/Karan554/Terraform_resuable_modules.git'
                
                sh 'ls -lat'
                
            }
        }
        
        stage('terraform') {
      steps {
                sh "chmod +x -R ${env.WORKSPACE}"
            }
        }
        
       stage('Plan') {
            steps {
                script {
                    currentBuild.displayName = params.version
                }
                dir('/var/jenkins_home/workspace/reusable_modules/dev'){
                sh 'terraform init -input=false'
                sh 'terraform workspace select ${environment}'
                sh "terraform plan -out tfplan"
                sh 'terraform show -no-color tfplan > tfplan.txt'
                }

            }
        }
        
        stage('Approval') {
            when {
               not {
                   equals expected: true, actual: params.autoApprove
                }
            }
            steps {
               script {
                   def plan = readFile '/var/jenkins_home/workspace/reusable_modules/dev/tfplan.txt'
                   input message: "Do you want to apply the plan?",
                       parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }
        
        stage('Apply') {
            steps {
                dir('/var/jenkins_home/workspace/reusable_modules/dev'){
                    sh "terraform apply -input=false tfplan"
                }
            }
        }
        
        stage('Destroy-Plan') {
            steps {
                script {
                    currentBuild.displayName = params.version
                }
                dir('/var/jenkins_home/workspace/reusable_modules/dev'){
                    sh "terraform plan -destroy -out tfdestroy"
                    sh 'terraform show -no-color tfdestroy > tfdestroy.txt'
                }
            }
        }

        stage('Destoy-Approval') {
            when {
               not {
                   equals expected: true, actual: params.autoApprove2
                }
            }
            steps {
               script {
                   def destroy_plan = readFile '/var/jenkins_home/workspace/reusable_modules/dev/tfdestroy.txt'
                   input message: "Do you want to apply the Destroy-plan?",
                       parameters: [text(name: 'Destroy-plan', description: 'Please review the Destoy-plan', defaultValue: destroy_plan)]
                }
            }
        }

        stage('Destroy') {
            steps {
                dir('/var/jenkins_home/workspace/reusable_modules/dev'){
                   sh "terraform apply -input=false tfdestroy"                    
                }
            }
        }
    }
}
