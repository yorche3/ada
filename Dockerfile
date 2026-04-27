FROM alire/gnat:ubuntu-lts

# Instalamos gnatcheck (vía asis-programs) y utilidades para descargar Alire
RUN apt-get update && \
    apt-get install -y gnat asis-programs curl unzip && \
    rm -rf /var/lib/apt/lists/*

# Descarga e instalación de Alire 2.1.0 especificado
RUN curl -L https://github.com/alire-project/alire/releases/download/v2.1.0/alr-2.1.0-bin-x86_64-linux.zip -o alr.zip && \
    unzip alr.zip -d /usr/bin/ && \
    chmod +x /usr/bin/alr && \
    rm alr.zip

WORKDIR /workspace