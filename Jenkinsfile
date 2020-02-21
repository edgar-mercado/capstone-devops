pipeline {
    agent any

    stages {
        stage('Clone repository') {
            /* Let's make sure we have the repository cloned to our workspace */

            checkout scm
        }
        stage('Build') {
            steps {
                echo 'Building..'
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
