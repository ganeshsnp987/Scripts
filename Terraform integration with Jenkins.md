Terraform integrate with Jenkins:
Install terraform plugins on Jenkins
Configure terraform tools in manage jenkins and give the terraform installation Name: "terraform" and path (/usr/bin/) and apply and save it.

Create jenkins pipeline with name "Terraform-EKS" and select pipeline and click on OK
This project is parameterised
Name: action
Choices: apply/destroy
Description: Select the choice Devopro_ganesh?
```bash
pipeline{
    agent any
    stages {
        stage('Checkout from Git'){
            steps{
                git branch: 'main', url: 'https://github.com/ganeshsnp987/Hotstar-App.git'
            }
        }
        stage('Terraform version'){
             steps{
                 sh 'terraform --version'
             }
        }
        stage('Terraform init'){
             steps{
                 dir('EKS_TERRAFORM') {
                      sh 'terraform init'
                   }
             }
        }
        stage('Terraform validate'){
             steps{
                 dir('EKS_TERRAFORM') {
                      sh 'terraform validate'
                   }
             }
        }
        stage('Terraform plan'){
             steps{
                 dir('EKS_TERRAFORM') {
                      sh 'terraform plan'
                   }
             }
        }
        stage('Terraform apply/destroy'){
             steps{
                 dir('EKS_TERRAFORM') {
                      sh 'terraform ${action} --auto-approve'
                   }
             }
        }
    }
}
```
