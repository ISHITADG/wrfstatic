FROM ubuntu:16.04

#increase space and install dependencies
RUN apt-get update \
    && apt-get install -y udisks2\
    && apt-get install -y tmux\
    && apt-get install -y htop\
    && apt-get install -y gfortran\
    && apt-get install -y vim\
    && apt-get install -y csh\
    && apt-get install -y openssh-server\
    && apt-get install -y build-essential\
    && apt-get install -y wget\
    && apt-get install -y unzip\
    && apt-get install -y libboost-all-dev
    
# install mpich
RUN mkdir mpich-install\
    && cd mpich-install\
    && wget -L http://www.mpich.org/static/downloads/3.3.2/mpich-3.3.2.tar.gz \
    && tar xzf mpich-3.3.2.tar.gz \
    && cd mpich-3.3.2 \
    && mkdir mpich-install\
    && ./configure --prefix=/home/mpich-install 2>&1 | tee c.txt\
    && make 2>&1 | tee m.txt\
    && make install 2>&1 | tee mi.txt\
    && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/mpich-install/bin \
    && export PATH=$PATH:/home/mpich-install/bin \
    && cd ../..
    
# install openmpi
RUN mkdir openmi\
    && cd openmi\
    && wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.2.tar.gz\
    && tar -xvzf openmpi-4.0.2.tar.gz\
    && cd openmpi-4.0.2 \
    && ./configure --prefix=/home/openmi\
    && make all\
    && make install \
    && export LD_LIBRARY_PATH=/home/openmi/openmpi-4.0.2 \
    && export PATH=$PATH:/home/openmi/openmpi-4.0.2 \
    && cd ../..
    
#install zlib,hdf5,netcdf-c4.4,nectdf-fortran4
RUN wget -L https://github.com/Unidata/netcdf-c/archive/v4.4.1.1.tar.gz\
    && tar -xvzf v4.4.1.1.tar.gz \
    && wget -L https://github.com/Unidata/netcdf-fortran/archive/v4.4.4.tar.gz\
    && tar -xvzf v4.4.4.tar.gz\
    && wget -L ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4/hdf5-1.8.13.tar.gz\
    && tar -xvzf hdf5-1.8.13.tar.gz\
    && wget -L ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4/zlib-1.2.8.tar.gz\
    && tar -xvzf zlib-1.2.8.tar.gz\
    && rm *.tar.gz\
    && export F77=gfortran\
    && export FC=gfortran\
    && export CC=gcc\
    && export CXX=g++\
    && export CFLAGS=-fPIC\
    && cd ../zlib-1.2.8\
    && ZDIR=/usr/local\
    && ./configure --prefix=${ZDIR}\
    && make check\
    && make install\
    && cd ../hdf5-1.8.13\
    && ./configure --with-zlib=${ZDIR} --prefix=${H5DIR} --enable-hl\
    && make check\
    && make install\
    && cd ../cd netcdf-c-4.4.1.1\
    && NCDIR=/usr/local \
    && CPPFLAGS='-I${H5DIR}/include -I${ZDIR}/include' LDFLAGS='-L${H5DIR}/lib -L${ZDIR}/lib'\
    && ./configure --prefix=${NCDIR}\
    && make check\
    && make install\
    && export LD_LIBRARY_PATH=${NCDIR}/lib:${LD_LIBRARY_PATH}\
    && cd ../cd netcdf-fortran-4.4.4\
    && NFDIR=/usr/local \
    && export LD_LIBRARY_PATH=${NFDIR}/lib:${LD_LIBRARY_PATH}\
    && CPPFLAGS='-I${H5DIR}/include -I${ZDIR}/include' LDFLAGS='-L${H5DIR}/lib -L${ZDIR}/lib'\
    && ./configure --prefix=${NFDIR}\
    && make check\
    && make install\
    && cd ..

# configure & compile gfort wrf-hydro
RUN wget -L https://github.com/NCAR/wrf_hydro_nwm_public/archive/v5.1.1.tar.gz\
    && tar -xvzf v5.1.1.tar.gz\
    && rm v5.1.1.tar.gz\
    && cd wrf_hydro_nwm_public-5.1.1/trunk/NDHMS \
    && cp template/setEnvar.sh .\
    && export NETCDF=`nc-config --prefix`\
    && export NETCDF_INC="/usr/local/include"\
    && export NETCDF_LIB="/usr/local/lib"\
    && ./configure 2\
    && wget -L https://raw.githubusercontent.com/ISHITADG/wrfstatic/master/setEnvar.sh\
    && ./compile_offline_NoahMP.sh setEnvar.sh \
    && cd ../../..

# Run a test case
RUN wget -L https://github.com/NCAR/wrf_hydro_nwm_public/releases/download/v5.1.1/croton_NY_example_testcase.tar.gz\
    && tar -xvzf croton_NY_example_testcase.tar.gz\
    && rm croton_NY_example_testcase.tar.gz\
    && cd example_case/NWM \
    && cp ../../wrf_hydro_nwm_public-5.1.1/trunk/NDHMS/Run/*.TBL .\
    && cp ../../wrf_hydro_nwm_public-5.1.1/trunk/NDHMS/Run/wrf_hydro_NoahMP.exe .\
    && cp -r ../FORCING .

#see output --how to run model see later

#entrypoint cmd
ENTRYPOINT ["top", "-b"]
CMD ["-c"]

