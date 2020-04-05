FROM ubuntu:16.04

ENV LD_LIBRARY_PATH=/mpich-install/bin:/openmi/openmpi-4.0.2:/usr/local/include:/usr/local/lib:/usr/local/bin:/usr/local
ENV PATH=/mpich-install/bin:/openmi/openmpi-4.0.2:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/local/include:/usr/local/lib
ENV NETCDF_LIB=/usr/local/lib
ENV NETCDF_INC=/usr/local/include
ENV NETCDF="nc-config --prefix"
ENV ZDIR=/usr/local
ENV H5DIR=/usr/local
ENV NCDIR=/usr/local
ENV NFDIR=/usr/local
ENV F77=gfortran
ENV FC=gfortran
ENV CC=gcc
ENV CXX=g++
ENV CFLAGS=-fPIC

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
    && apt-get install -y m4\
    && apt-get install -y libboost-all-dev
    
# install mpich
RUN mkdir mpich-install\
    && cd mpich-install\
    && wget -L http://www.mpich.org/static/downloads/3.3.2/mpich-3.3.2.tar.gz \
    && tar xzf mpich-3.3.2.tar.gz \
    && cd mpich-3.3.2 \
    && mkdir mpich-install\
    && ./configure --prefix=/mpich-install 2>&1 | tee c.txt\
    && make 2>&1 | tee m.txt\
    && make install 2>&1 | tee mi.txt\
    && cd ../..
    
# install openmpi
RUN mkdir openmi\
    && cd openmi\
    && wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.2.tar.gz\
    && tar -xvzf openmpi-4.0.2.tar.gz\
    && cd openmpi-4.0.2 \
    && ./configure --prefix=/openmi\
    && make all\
    && make install \
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
    && rm *.tar.gz \
    && cd zlib-1.2.8 \
    && ./configure --prefix=${ZDIR}\
    && make check \
    && make install \
    && cd ../hdf5-1.8.13 \
    && ./configure --with-zlib=${ZDIR} --prefix=${H5DIR} --enable-hl \
    && make check \
    && make install \
    && cd ../netcdf-c-4.4.1.1 \
    && CPPFLAGS='-I${H5DIR}/include -I${ZDIR}/include' LDFLAGS='-L${H5DIR}/lib -L${ZDIR}/lib'\
    && ./configure --prefix=${NCDIR}\
    && make check\
    && make install\
    && cd ../netcdf-fortran-4.4.4\
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
    && wget -L https://raw.githubusercontent.com/ISHITADG/wrfstatic/master/setEnvar.sh\
    && export NETCDF=`nc-config --prefix`\
    && ./configure 2\
    && ./compile_offline_NoahMP.sh setEnvar.sh \
    && cd ../../..

# Run a test case
RUN wget -L https://github.com/NCAR/wrf_hydro_nwm_public/releases/download/v5.1.1/croton_NY_example_testcase.tar.gz\
    && tar -xvzf croton_NY_example_testcase.tar.gz\
    && rm croton_NY_example_testcase.tar.gz\
    && cd example_case/NWM \
    && cp ../../wrf_hydro_nwm_public-5.1.1/trunk/NDHMS/Run/*.TBL .\
    && cp ../../wrf_hydro_nwm_public-5.1.1/trunk/NDHMS/Run/wrf_hydro_NoahMP.exe .\
    && cp -r ../FORCING .\
    && mpirun --allow-run-as-root -np 2 ./wrf_hydro_NoahMP.exe

#output in /example_case/NWM directory

#entrypoint cmd
ENTRYPOINT ["top", "-b"]
CMD ["-c"]

