FROM amazonlinux:latest
LABEL maintainer jsuzuki20120311 <shukatu.2012.5.25@gmail.com>

ARG NODE_VERSION=12.18.3
ENV NODE_VERSION ${NODE_VERSION}

# nodenv Node.js install
RUN yum install gcc gcc-c++ make git openssl-devel bzip2 bzip2-devel zlib-devel readline-devel sqlite-devel libffi-devel tar zip -y && \
    git clone git://github.com/nodenv/nodenv.git /root/.nodenv && \
    git clone git://github.com/nodenv/node-build.git ~/.nodenv/plugins/node-build && \
    echo 'export PATH="$HOME/.nodenv/bin:$PATH"' >> /root/.bash_profile && \
    echo 'eval "$(nodenv init -)"' >> /root/.bash_profile && \
    source /root/.bash_profile && \
    /root/.nodenv/bin/nodenv install ${NODE_VERSION} && \
    /root/.nodenv/bin/nodenv global ${NODE_VERSION}

# miniconda install
RUN cd /root/ && mkdir downloads
WORKDIR /root/downloads
RUN curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O && \
    chmod +x ./Miniconda3-latest-Linux-x86_64.sh && \
    bash ./Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    source /root/.bashrc && \
    rm -r /root/downloads/
WORKDIR /

ENV PATH opt/conda/bin:/root/.nodenv/shims:/root/.nodenv/bin:$PATH

CMD [ "/bin/bash" ]
