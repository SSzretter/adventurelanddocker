FROM ubuntu:22.04
WORKDIR /adventureland

RUN set -uex; \
    apt-get update; \
    apt-get install -y ca-certificates curl gnupg; \
    mkdir -p /etc/apt/keyrings; \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
     | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg; \
    NODE_MAJOR=16; \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" \
     > /etc/apt/sources.list.d/nodesource.list; \
    apt-get -qy update; \
    apt-get -qy install nodejs; \
    apt-get -qy install git gh libsqlite3-dev; \
    apt-get -qy install screen nano wget git wget build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libxml2-dev libxslt-dev cmake zlib1g-dev;
    
RUN wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz; \
    tar xzf Python-2.7.18.tgz; \
    cd Python-2.7.18; \
    ./configure --prefix=/usr/local --enable-shared; \    
    make; \
    make altinstall; \
    update-alternatives --install /usr/bin/python python /usr/local/bin/python2.7 1; \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/python2.7.conf;

RUN ldconfig; \
    wget https://bootstrap.pypa.io/pip/2.7/get-pip.py; \
    /usr/local/bin/python2.7 get-pip.py; \
    pip check; \
    pip install lxml;


COPY . .

RUN chmod +x server_entrypoint.sh;
RUN chmod +x client_entrypoint.sh;

ENTRYPOINT [ "/bin/bash" ]


