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
                    // Usamos comillas dobles para que Groovy interpole la variable IMAGE
                    sh "docker build -t ${IMAGE} ."
                }
            }
        }

        stage('GNATCheck Analysis') {
            steps {
                script {
                    sh 'mkdir -p reports'
                    
                    // Llamamos a la función que definimos arriba
                    def projects = getProjects()

                    projects.each { project ->
                        def projectPath = project.path
                        def gprFile = project.gpr

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