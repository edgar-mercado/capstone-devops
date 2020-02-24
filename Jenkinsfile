@Library('github.com/releaseworks/jenkinslib') _
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
                sh 'docker tag ecme820721/capstone:latest ecme820721/capstone:$BUILD_NUMBER'
            }
        }
        stage('Push') {
            steps {
                echo 'Pushing..'
                sh 'echo $USER_CREDENTIALS_PSW | docker login --username $USER_CREDENTIALS_USR --password-stdin'
                sh 'docker push ecme820721/capstone:$BUILD_NUMBER'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
                // withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'eks-key', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                //     AWS("eks update-kubeconfig --name capstone --region us-west-2")
                // }
                sh 'kubectl config use-context arn:aws:eks:us-west-2:947114706565:cluster/capstone'
                sh 'kubectl config current-context'
                sh '''#!/bin/bash
                      kubectl version --short --client
                      kubectl get namespaces
                      dockerpath=ecme820721/capstone:$BUILD_NUMBER

                      kubectl run --image=$dockerpath capstone --port=80 -n udacity
                      kubectl set image deployments/capstone capstone=$dockerpath -n udacity

                      kubectl get pods -n udacity
                      podname=$(kubectl get pods -o json -n udacity | jq -r .items[].metadata.name)
                      sleep 30
                      kubectl expose deployment capstone --type=LoadBalancer --name=capstone-service -n udacity
                      kubectl get service/capstone-service -n udacity |  awk {'print $1" " $2 " " $4 " " $5'} | column -t


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
