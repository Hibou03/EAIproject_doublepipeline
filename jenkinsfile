pipeline {
    agent any

    environment {
        TF_VAR_vsphere_user = credentials('vsphere_user')
        TF_VAR_vsphere_password = credentials('vsphere_password')
    }

    stages {
        stage('Gitleaks Scan') {
            steps {
                sh 'gitleaks detect --no-git -s .'
            }
        }

        stage('TFLint Scan') {
            steps {
                sh 'tflint'
            }
        }

        stage('TFSEC Scan') {
            steps {
                sh 'tfsec .'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform init'
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            when {
                branch 'mr' // uniquement pour merge request
            }
            steps {
                sh 'terraform plan -var-file="terraform.tfvars"'
            }
        }

        stage('Terraform Apply') {
            when {
                branch 'master' // uniquement sur master
            }
            steps {
                sh 'terraform apply -auto-approve -var-file="terraform.tfvars"'
            }
        }
    }
}
