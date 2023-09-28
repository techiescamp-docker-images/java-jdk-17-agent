@Library('jenkins-shared-library@develop') _

def awsRegion = "us-west-2"
def imageName = "jdk17_base_image"
def versionTag = "1.0.0"

pipeline {
    agent {
        label 'AGENT-01'
    }

    stages {
        stage('Lint Dockerfile') {
            steps {
                hadoLint()
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        dockerBuild(
                            versionTag: versionTag,
                            imageName: imageName
                        )
                    } catch (Exception buildError) {
                        currentBuild.result = 'FAILURE'
                        error("Failed to build Docker image: ${buildError}")
                    }
                }
            }
        }
        stage('Run Trivy Scan') {
            steps {
                script {
                    try {
                        def imageNameAndTag = "${imageName}:${versionTag}"
                        trivyScan(imageNameAndTag)
                    } catch (Exception trivyError) {
                        currentBuild.result = 'FAILURE'
                        error("Trivy scan failed: ${trivyError}")
                    }
                }
            }
        }
        stage('Push Image To ECR') {
            when {
                branch 'main'
            }
            steps {
                script {
                    try {
                        ecrRegistry(
                            ecrRepository: "${ECR_REGISTRY}/jdk17_base_image",
                            imageName: "${imageName}",
                            versionTag: "${versionTag}",
                            awsRegion: "${awsRegion}"
                        )
                    } catch (Exception pushError) {
                        currentBuild.result = 'FAILURE'
                        error("Failed to push image to ECR: ${pushError}")
                    }
                }
            }
        }
    }

    post {
        success {
            script {
                emailNotification.sendEmailNotification('success', 'aswin@crunchops.com')
            }
        }
        failure {
            script {
                emailNotification.sendEmailNotification('failure', 'aswin@crunchops.com')
            }
        }
        always {
            cleanWs()
        }
    }
}
