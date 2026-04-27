FROM alire/gnat:ubuntu-lts

ENV DEBIAN_FRONTEND=noninteractive

# 1. Instalamos todas las dependencias del sistema
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gnat \
    asis-programs \
    curl \
    unzip \
    ca-certificates \
    pkg-config \
    # Dependencias para GUI (GtkAda)
    libgtk-3-dev \
    # Dependencias para Microservicios/Red (AWS / OpenSSL)
    libssl-dev \
    # Dependencia extra común para compilación de C en Ada
    build-essential && \
    rm -rf /var/lib/apt/lists/*

# 2. Instalar Alire 2.1.0
RUN curl -fSL https://github.com/alire-project/alire/releases/download/v2.1.0/alr-2.1.0-bin-x86_64-linux.zip -o /tmp/alr.zip && \
    unzip /tmp/alr.zip -d /tmp/alr_extracted && \
    mv /tmp/alr_extracted/bin/alr /usr/bin/alr && \
    chmod +x /usr/bin/alr && \
    rm -rf /tmp/alr.zip /tmp/alr_extracted

# 3. Configurar Alire para usar las herramientas del sistema
RUN alr --non-interactive toolchain --select gnat_native && \
    alr --non-interactive toolchain --select gprbuild

WORKDIR /workspace