FROM ubuntu:bionic

# Update base container install
RUN apt-get update
RUN apt-get upgrade -y

# Install GDAL dependencies
RUN apt-get install -y python3-pip locales

# Install dependencies for other packages
RUN apt-get install gcc g++
#RUN apt-get install jpeg-dev zlib-dev

# Ensure locales configured correctly
RUN locale-gen en_US.UTF-8
ENV LC_ALL='en_US.utf8'

# Set python aliases for python3
RUN echo 'alias python=python3' >> ~/.bashrc
RUN echo 'alias pip=pip3' >> ~/.bashrc

# This will install latest version of GDAL
RUN apt-get -y install python3-gdal
RUN apt-get -y install zip
RUN apt-get -y install ca-certificates 
ENV CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
RUN apt-get -y install wget
RUN apt-get -y install cmake
RUN apt-get -y install pkg-config
RUN apt-get -y install automake
RUN apt-get -y install libtool
RUN apt-get -y install sqlite3 libsqlite3-dev
RUN apt-get -y install git

# Copy function to a path
RUN mkdir -p /var/ecw/
# ADD . /var/ecw/

# Work Directory
WORKDIR /var/ecw/
# Install and downloading data
RUN wget http://dl.maptools.org/dl/fgs/releases/pre-1.0/fgs-dev/fgs-cache/libecwj2-3.3.20060906.tar.gz
RUN git clone -b 6.0 https://github.com/OSGeo/proj.4.git /var/ecw/proj
RUN git clone https://github.com/OSGeo/gdal.git /var/ecw/gdal
RUN tar -xvzf libecwj2-3.3.20060906.tar.gz


# Install libecw package
CMD ["cd", "/var/ecw/libecwj2-3.3.20060906/"]
CMD ["./configure"]
CMD ["make -j 16"]
CMD ["make install"]

# Install proj package
CMD ["mkdir", "/var/ecw/proj_install"]
CMD ["cd", "/var/ecw/proj"]
CMD ["bash", "autogen.sh"]
CMD ["./configure", "--prefix=/var/ecw/proj_install/"]
CMD ["make", "-j", "16"]
CMD ["make", "install"]

# Install gdal package
CMD ["cd","/var/ecw/gdal/gdal/"]
CMD ["./configure", "--with-proj=/var/ecw/proj_install/"]
CMD ["make", "-j" ,"16"]
CMD ["make", "install"]

# Update C env vars so compiler can find gdal
ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal
