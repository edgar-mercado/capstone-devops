pipeline {
    agent any
    environment {
        USER_CREDENTIALS = credentials('dockerhub')
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
                sh 'hadolint Dockerfile'
                sh 'python3 -m venv ~/.devops'
            	  sh 'pip install --upgrade pip && pip install -r requirements.txt'
                sh 'pylint --disable=R,C,W1203 app.py'

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
            }
        }
        stage('Test') {
            steps {
                echo 'Testing....'
            }
        }
    }
}
