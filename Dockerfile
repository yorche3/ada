FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Instalar dependencias base, librerías de desarrollo Y GIT
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    unzip \
    ca-certificates \
    pkg-config \
    build-essential \
    make \
    python3 \
    git \
    # Librerías de sistema necesarias para AWS, SOAP y GUI
    libssl-dev \
    zlib1g-dev \
    libgtk-3-dev \
    libc6-dev \
    asis-programs && \
    rm -rf /var/lib/apt/lists/*

# 2. Descargar e instalar Alire 2.1.0 globalmente
RUN curl -fSL https://github.com/alire-project/alire/releases/download/v2.1.0/alr-2.1.0-bin-x86_64-linux.zip -o /tmp/alr.zip && \
    unzip /tmp/alr.zip -d /tmp/alr_extracted && \
    mv /tmp/alr_extracted/bin/alr /usr/bin/alr && \
    chmod +x /usr/bin/alr && \
    rm -rf /tmp/alr.zip /tmp/alr_extracted

# 3. Configuración Global de Toolchains
# Ahora que git está instalado, Alire podrá descargar el índice sin errores
RUN alr --non-interactive index --update-all && \
    alr --non-interactive toolchain --select gnat_native=15.2.1 && \
    alr --non-interactive toolchain --select gprbuild=25.0.1

# 4. Variables de entorno para el enlazado
ENV LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:/lib/x86_64-linux-gnu
ENV LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:/lib/x86_64-linux-gnu
ENV C_INCLUDE_PATH=/usr/include/x86_64-linux-gnu:/usr/include
ENV CPATH=/usr/include/x86_64-linux-gnu:/usr/include
ENV PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig

WORKDIR /workspace