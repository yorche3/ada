def getProjects() {
    return [
        [path: 'console_training/consapp', gpr: 'consapp.gpr'],
        [path: 'gui_training/guiapp', gpr: 'guiapp.gpr'],
        [path: 'microservices/ms_rest', gpr: 'ms_rest.gpr'],
        [path: 'microservices/ms_soap', gpr: 'ms_soap.gpr']
    ]
}

pipeline {
    agent any

    environment {
        IMAGE = 'gnatcheck-image'
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
                    bat "docker build -t %IMAGE% ."
                }
            }
        }

        stage('Resolve Dependencies & Build') {
            steps {
                script {
                    def projects = getProjects()
                    projects.each { project ->
                        // --accept-config-scripts permite que AWS/GtkAda ejecuten sus scripts de configuración
                        bat """
                            docker run --rm ^
                                -v %cd%:/workspace ^
                                -w /workspace/${project.path} ^
                                %IMAGE% ^
                                bash -c "alr --non-interactive index --update-all && alr --non-interactive build --accept-config-scripts"
                        """
                    }
                }
            }
        }

        stage('GNATCheck Analysis') {
            steps {
                script {
                    bat 'if exist reports rd /s /q reports'
                    bat 'mkdir reports'
                    
                    def projects = getProjects()
                    projects.each { project ->
                        // Se usa --non-interactive también aquí para evitar cuelgues
                        bat """
                            docker run --rm ^
                                -v %cd%:/workspace ^
                                -w /workspace/${project.path} ^
                                %IMAGE% ^
                                alr --non-interactive exec -- gnatcheck -P${project.gpr} ^
                                    -rules +RDefault_Checks +RStyle_Checks ^
                                    --output-dir=/workspace/reports/${project.path} ^
                                    --output-format=html ^
                                    --info
                        """
                    }
                }
            }
        }

        stage('Archive Reports') {
            steps {
                archiveArtifacts artifacts: 'reports/**/*.html', allowEmptyArchive: true
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}