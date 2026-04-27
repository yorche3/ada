FROM alire/gnat:ubuntu-lts

# Evitar prompts interactivos durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# 1. Instalamos todas las dependencias necesarias primero
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gnat \
    asis-programs \
    curl \
    unzip \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 2. Descargar Alire 2.1.0 (usando -f para fallar rápido si no descarga)
RUN curl -fSL https://github.com/alire-project/alire/releases/download/v2.1.0/alr-2.1.0-bin-x86_64-linux.zip -o /tmp/alr.zip && \
    unzip /tmp/alr.zip -d /usr/bin/ && \
    chmod +x /usr/bin/alr && \
    rm /tmp/alr.zip

WORKDIR /workspace