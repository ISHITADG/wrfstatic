FROM ubuntu:18.04

#increase space and install dependencies
RUN apt-get update \
    && apt-get install -y udisks2\
    && apt-get install -y tmux\
    && apt-get install -y htop\
    && apt-get install -y gfortran\
    && apt-get install -y vim\
    && apt-get install -y csh\
    && apt-get install -y openssh-server\
    && apt-get install -y libboost-all-dev

#install netcdf
RUN apt-get install -y wget \
    && wget -L https://github.com/ISHITADG/wrf_hydro/raw/master/netcdf-3.6.3-beta1.tar.gz \
    && tar -xvzf netcdf-3.6.3-beta1.tar.gz  \
    && cd netcdf-3.6.3-beta1 \
    && export FC=gfortran \
    && mkdir /opt \
    && mkdir /opt/netcdf \
    && mkdir /opt/netcdf/3.6.3 \
    && ./configure --prefix=/opt/netcdf/3.6.3 \
    && make \
    && make install \
    && export NETCDFHOME=/opt/netcdf/3.6.3 \
    && export NETCDFINC=/opt/netcdf/3.6.3/include \
    && export NETCDFLIB=/opt/netcdf/3.6.3/lib \
    && cd ..

# install mpich
RUN apt-get install -y mpich \
    && apt-get install -y libswitch-perl \
    && apt-get install -y m4

# download compiled wrf parallel and compiler source code
RUN wget -L https://github.com/ISHITADG/wrf_hydro/blob/master/wrf_hydro_NoahMP.exe?raw=true \
    && mv wrf_hydro_NoahMP.exe?raw=true wrf_hydro_NoahMP.exe \
    && wget -L https://github.com/ISHITADG/wrfstatic/blob/master/WRF_Hydro3.0.tar.gz?raw=true \
    && mv WRF_Hydro3.0.tar.gz\?raw\=true WRF_Hydro3.0.tar.gz \
    && gunzip -c WRF_Hydro3.0.tar.gz | tar xopf -

# download a domain case
RUN wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1F2FEl-uob5XAvE5DU_u3TkFGw61iKQod' -O- | sed -rn 's/.confirm=([0-9A-Za-z_]+)./\1\n/p')&id=1F2FEl-uob5XAvE5DU_u3TkFGw61iKQod" -O c4_1.tar.gz && rm -rf /tmp/cookies.txt\
    && gunzip -c c4_1.tar.gz | tar xopf -

#download rainfall, parameter info and other files
RUN wget --no-check-certificate -r 'https://docs.google.com/uc?export=download&id=1G3ZGbzaQFlpD1JRhk1W7-WBtoGxLSRXe' -O wrkdir_rt125_forIshita_2017Jan.zip\
    && apt-get install -y unzip \
    && unzip wrkdir_rt125_forIshita_2017Jan.zip \
    && rm *.gz; rm *.zip

#see output --how to run model see later

#entrypoint cmd
ENTRYPOINT ["top", "-b"]
CMD ["-c"]

