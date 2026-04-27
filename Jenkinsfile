pipeline {
    agent any

    environment {
        IMAGE = 'gnatcheck-image'
        PROJECTS = [
            [path: 'console_training/consapp', gpr: 'consapp.gpr'],
            [path: 'gui_training/guiapp', gpr: 'guiapp.gpr'],
            [path: 'microservices/ms_rest', gpr: 'ms_rest.gpr'],
            [path: 'microservices/ms_soap', gpr: 'ms_soap.gpr']
        ]
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${IMAGE} .'
                }
            }
        }

        stage('GNATCheck Analysis') {
            steps {
                script {
                    sh 'mkdir -p reports'

                    PROJECTS.each { project ->
                        def projectPath = project.path
                        def gprFile = project.gpr
                        def reportDir = "reports/${projectPath}"

                        sh """
                            docker run --rm \
                                -v \$(pwd):/workspace \
                                -w /workspace/${projectPath} \
                                ${IMAGE} \
                                gnat check -P${gprFile} \
                                    --all-checks \
                                    --style \
                                    --output-dir=/workspace/reports/${projectPath} \
                                    --output-format=html,xml \
                                    --info
                        """
                    }
                }
            }
        }

        stage('Archive Reports') {
            steps {
                archiveArtifacts artifacts: 'reports/**/*.html,reports/**/*.xml', allowEmptyArchive: true
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}