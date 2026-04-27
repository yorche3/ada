// Definimos la lista de proyectos fuera del pipeline para que sea accesible
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
                    // Usamos %IMAGE% para la variable de entorno de Jenkins en Windows
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
                        // 1. Cambiamos el Working Directory (-w) a /workspace (la raíz)
                        // 2. Apuntamos al archivo GPR usando la ruta completa: ${project.path}/${project.gpr}
                        bat """
                            docker run --rm ^
                                -v %cd%:/workspace ^
                                -w /workspace ^
                                %IMAGE% ^
                                gnatcheck -P${project.path}/${project.gpr} ^
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
                // El allowEmptyArchive ayuda si algún análisis no genera resultados
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