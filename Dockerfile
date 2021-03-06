FROM python:3.7

ARG OSPREY_VERSION=3.2

# install OpenJDK java
RUN apt-get update && apt-get install -y openjdk-11-jdk
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/

# install pip and python packages
RUN pip install --no-cache --upgrade pip \
    && pip install --no-cache notebook pandas matplotlib nglview \
    && jupyter-nbextension enable nglview --py --sys-prefix

# install osprey
WORKDIR /tmp
RUN wget -O osprey.zip https://github.com/donaldlab/OSPREY3/releases/download/3.2.101/osprey-linux-python3-${OSPREY_VERSION}.zip \
    && unzip osprey.zip \
    && pip install --pre osprey-linux-python3-${OSPREY_VERSION}/wheelhouse/*.whl \
    && rm -r osprey-linux*

RUN sed -i 's/jvm.start(jre_path/jvm.start(None/g' /usr/local/lib/python3.7/site-packages/osprey/__init__.py

# create user with a home directory
ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
    
WORKDIR ${HOME}
USER ${USER}

COPY index.ipynb .
COPY 1CC8.ss.pdb .
