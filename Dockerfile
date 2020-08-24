FROM python:3.7

ARG OSPREY_VERSION=3.2

# install OpenJDK java
RUN apt-get update && apt-get install openjdk-8-jdk

# install pip and python packages
RUN pip install --no-cache --upgrade pip \
    && pip install --no-cache notebook pandas matplotlib nglview \
    && jupyter-nbextension enable nglview --py --sys-prefix

# install osprey
WORKDIR /tmp
RUN wget -O osprey.zip https://github.com/donaldlab/OSPREY3/releases/download/3.2.101/osprey-linux-python3-${OSPREY_VERSION}.zip \
    && unzip osprey.zip \
    && pip install osprey-linux-python3-${OSPREY_VERSION}/wheelhouse/*.whl \
    && rm -r osprey-linux*
    
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

COPY index.ipynb index.ipynb

