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

        stage('GNATCheck Analysis') {
            steps {
                script {
                    bat 'if exist reports rd /s /q reports'
                    bat 'mkdir reports'
                    
                    def projects = getProjects()
                    projects.each { project ->
                        // Ejecutamos alr printenv para regenerar los archivos de configuración
                        // Luego ejecutamos gnatcheck desde la raíz del proyecto (-w)
                        bat """
                            docker run --rm ^
                                -v %cd%:/workspace ^
                                -w /workspace/${project.path} ^
                                %IMAGE% ^
                                bash -c "alr printenv && gnatcheck -P${project.gpr} ^
                                    -rules +RDefault_Checks +RStyle_Checks ^
                                    --output-dir=/workspace/reports/${project.path} ^
                                    --output-format=html ^
                                    --info"
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