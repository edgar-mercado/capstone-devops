pipeline {
    agent any
    environment {
        USER_CREDENTIALS = credentials('dockerhub')
        AWS_CREDENTIALS = credentials('eks')
    }
    stages {
        stage('Clone repository') {
            /* Let's make sure we have the repository cloned to our workspace */
            steps {
                checkout scm
            }
        }
        stage('Lint') {
            steps {
                sh '''#!/bin/bash
                        echo "hello world"
                        python3 -m venv ~/.devops
                        source ~/.devops/bin/activate
                        pip3 install -r requirements.txt
                        ~/.devops/bin/pylint --disable=R,C,W1203 app.py
                        pip3 install --upgrade --user awscli
                '''
            }
        }
        stage('Build') {
            steps {
                echo 'Building..'
                sh 'ls -l'
                sh 'pwd'
                sh 'cd capstone-project'
                sh 'docker build -t "ecme820721/capstone" .'
                sh 'docker images'
            }
        }
        stage('Push') {
            steps {
                echo 'Pushing..'
                sh 'echo $USER_CREDENTIALS_PSW | docker login --username $USER_CREDENTIALS_USR --password-stdin'
                sh 'docker push "ecme820721/capstone:latest"'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
                withAWS(credentials:'eks', region: 'us-west-2') {
                    sh 'export aws_access_key_id=$AWS_CREDENTIALS_USR'
                    sh 'export aws_secret_access_key=$AWS_CREDENTIALS_PSW'
                    sh 'export region=us-west-2'
                    sh 'aws --version'
                    sh 'which aws'
                    sh 'aws eks update-kubeconfig --name capstone --region us-west-2'
                    sh 'kubectl config use-context arn:aws:eks:us-west-2:947114706565:cluster/capstone'
                }
                sh '''#!/bin/bash
                      kubectl version --short --client
                      dockerpath=ecme820721/capstone

                      kubectl run --image=$dockerpath capstone --port=80 -n udacity

                      kubectl get pods -n udacity
                      podname=$(kubectl get pods -o json -n udacity | jq -r .items[].metadata.name)
                      sleep 30
                      kubectl port-forward $podname  8000:80
                '''
            }
        }
        stage('Test') {
            steps {
                echo 'Testing....'
            }
        }
    }
}
