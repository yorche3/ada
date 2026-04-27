FROM alire/gnat:ubuntu-lts

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl unzip ca-certificates pkg-config build-essential \
    gnat asis-programs \
    libssl-dev zlib1g-dev libgtk-3-dev \
    libc6-dev make && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fSL https://github.com/alire-project/alire/releases/download/v2.1.0/alr-2.1.0-bin-x86_64-linux.zip -o /tmp/alr.zip && \
    unzip /tmp/alr.zip -d /tmp/alr_extracted && \
    mv /tmp/alr_extracted/bin/alr /usr/bin/alr && \
    chmod +x /usr/bin/alr && \
    rm -rf /tmp/alr.zip /tmp/alr_extracted

# Estas variables son la clave para que el GCC de Alire encuentre -lssl y -lz
ENV LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:/lib/x86_64-linux-gnu
ENV C_INCLUDE_PATH=/usr/include/x86_64-linux-gnu:/usr/include
ENV PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig

WORKDIR /workspace