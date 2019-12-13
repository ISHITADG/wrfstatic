FROM ubuntu:18.04

#increase space and install dependencies
RUN apt-get update \
    && sudo apt install -y udisks2\
    && sudo apt-get install -y tmux\
    && sudo apt-get install -y htop\
    && sudo apt-get install -y gfortran\
    && sudo apt-get install -y vim\
    && sudo apt-get install -y libboost-all-dev

#install netcdf
RUN apt-get install -y wget \
    && wget -L https://github.com/ISHITADG/wrf_hydro/raw/master/netcdf-3.6.3-beta1.tar.gz \
    && tar -xvzf netcdf-3.6.3-beta1.tar.gz  \
    && cd netcdf-3.6.3-beta1 \
    && export FC=gfortran \
    && mkdir /opt/netcdf \ 
    && mkdir /opt/netcdf/3.6.3 \
    && ./configure --prefix=/opt/netcdf/3.6.3 \
    && make \
    && make install \
    && export NETCDFHOME=/opt/netcdf/3.6.3 \
    && export NETCDFINC=/opt/netcdf/3.6.3/include \
    && export NETCDFLIB=/opt/netcdf/3.6.3/lib \
    && cd ..

# install OpenMPI
RUN mkdir openmi \
    && cd openmi \
    && wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.2.tar.gz \
    && tar -xvzf openmpi-4.0.2.tar.gz \
    && cd openmpi-4.0.2 \
    && ./configure --prefix=/home/openmi \
    && make all \
    && make install \
    && export LD_LIBRARY_PATH=/home/openmi/openmpi-4.0.2 \
    && export PATH=$PATH:/home/openmi/openmpi-4.0.2:/mnt/big/openmi

# install mpich
RUN apt-get install -y mpich \
    && apt-get install -y libswitch-perl \
    && apt-get install -y m4

# download compiled wrf parallel and compiler source code
RUN wget -L https://github.com/ISHITADG/wrf_hydro/blob/master/wrf_hydro_NoahMP.exe?raw=true \
    && wget -L https://github.com/ISHITADG/wrfstatic/blob/master/WRF_Hydro3.0.tar.gz?raw=true \
    && gunzip -c WRF_Hydro3.0.tar.gz | tar xopf - 

# download domain case
RUN wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=FILEID' -O- | sed -rn 's/.confirm=([0-9A-Za-z_]+)./\1\n/p')&id=1F2FEl-uob5XAvE5DU_u3TkFGw61iKQod" -O c4_1.tar.gz && rm -rf /tmp/cookies.txt\
    && gunzip -c c4_1.tar.gz | tar xopf - 

#download rainfall, parameter info and other files
RUN wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=FILEID' -O- | sed -rn 's/.confirm=([0-9A-Za-z_]+)./\1\n/p')&id=1Z0PiT8dRzrk8WLv6q5PA6LavE9Aq5R6d" -O forIshita.tgz && rm -rf /tmp/cookies.txt;
    && gunzip -c forIshita.tgz | tar xvf - 
#see output --how to run model see later

#entrypoint cmd
ENTRYPOINT ["top", "-b"]
CMD ["-c"]

