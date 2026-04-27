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
        // Solo variables de entorno tipo String aquí
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
                    // Cambiamos sh por bat
                    bat "docker build -t %IMAGE% ." 
                }
            }
        }

        stage('GNATCheck Analysis') {
            steps {
                script {
                    bat 'if not exist reports mkdir reports' // Comando mkdir estilo Windows
                    
                    def projects = getProjects()
                    projects.each { project ->
                        // En bat, las variables se acceden con %VAR% o se inyectan desde Groovy
                        bat """
                            docker run --rm ^
                                -v %cd%:/workspace ^
                                -w /workspace/${project.path} ^
                                %IMAGE% ^
                                gnatcheck -P${project.gpr} ^
                                    --all-checks ^
                                    --style ^
                                    --output-dir=/workspace/reports/${project.path} ^
                                    --output-format=html,xml ^
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