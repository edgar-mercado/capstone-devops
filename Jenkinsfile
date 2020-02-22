pipeline {
    agent any

    stages {
        stage('Clone repository') {
            /* Let's make sure we have the repository cloned to our workspace */
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                echo 'Building..'
                cd capstone-project
                sh 'docker build -t "ecme820721/capstone" .'
                sh 'docker ls'
            }
        }
        stage('Push') {
            steps {
                echo 'Pushing..'
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
