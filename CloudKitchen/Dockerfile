FROM swift:5.2.3

WORKDIR /cloudkitchen

COPY . /cloudkitchen

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install git unzip build-essential autoconf libtool iputils-ping net-tools dnsutils

CMD swift CloudKitchen.swift
# CMD ping google.com 
