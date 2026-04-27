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
                    // Limpiamos y creamos el directorio de reportes
                    bat 'if exist reports rd /s /q reports'
                    bat 'mkdir reports'
                    
                    def projects = getProjects()
                    projects.each { project ->
                        // Ajustamos parámetros:
                        // 1. Usamos -rules +RDefault_Checks y +RStyle_Checks en lugar de --all-checks
                        // 2. Simplificamos a un formato de salida para evitar errores de versión
                        bat """
                            docker run --rm ^
                                -v %cd%:/workspace ^
                                -w /workspace/${project.path} ^
                                %IMAGE% ^
                                gnatcheck -P${project.gpr} ^
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