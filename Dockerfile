FROM golang

# Required for building the Oracle DB driver
ADD oci8.pc /usr/lib/pkgconfig/oci8.pc

# Install Oracle Client (all commands in one RUN to save image size)
RUN apt-get update && apt-get install -y --no-install-recommends \
	unzip \
	libaio1 \

	&& apt-get clean \
    && rm -rf /var/lib/apt/lists/* \

    && wget https://github.com/Yepitis/docker-golang-oracle/raw/master/instantclient-basic-linux.x64-12.2.0.1.0.zip \
	&& wget https://github.com/Yepitis/docker-golang-oracle/raw/master/instantclient-sdk-linux.x64-12.2.0.1.0.zip \
	
    && unzip instantclient-basic-linux.x64-*.zip -d / \
    && unzip instantclient-sdk-linux.x64-*.zip -d / \
	
    && rm instantclient-*-linux.x64-*.zip \
    
    && ln -s /instantclient_12_2/libclntsh.so.11.1 /instantclient_12_2/libclntsh.so

# The package config doesn't seem to be enough, this is also required
ENV LD_LIBRARY_PATH /instantclient_12_2

RUN go get -d -v github.com/mattn/go-oci8