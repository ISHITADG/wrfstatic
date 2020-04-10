# This repository holds Static contents of the container (all of the below have already been installed in the docker container via the Dockerfile in this repo)
1. Prerequisites (hdf5,zlib,netcdf-c 4 and netcdf-f 4) <br/>
3. Mpich to be installed from http://www.mpich.org/static/downloads/3.3.2/mpich-3.3.2.tar.gz (ZIP file too large to be icluded in here )<br/>
4. wrfHydro v5 model source <br/>
5. Compiled wrf executable <br/>
6. Test case including rainfall, domain files, parameters: run.tar.gz <br/>
7. Dockerfile that creates this container image and install all above items 1-5 <br/>
8. script that runs executable (?)**-to be done <br/> 

## steps to create container from the above Dockerfile
sudo wget https://raw.githubusercontent.com/ISHITADG/dockerNDN/master/dockovs.sh;<br/>
bash dockovs.sh;<br/>
wget -L https://raw.githubusercontent.com/ISHITADG/wrfstatic/master/Dockerfile; <br/>
sudo docker build -t wrfishita .;<br/>
docker run -d --rm --name wrf1 wrfishita;<br/>
docker exec -it wrf1 bash <br/>
## *FOR GEORGE* test run inside the container 
cd /example_case/NWM/<br/>
mpirun -np 2 ./wrf_hydro_NoahMP.exe <br/>
// time /usr/bin/mpiexec --allow-run-as-root -np 4 -mca btl ^openib ./wrf_hydro_NoahMP.exe >output.txt;<br/>

## push docker
docker login --username=ishitadg;<br/>
enter password: Ishidock91* <br/>
docker tag wrfishita ishitadg/wrfhv5<br/>
docker push ishitadg/wrfhv5<br/>

## make changes to docker container and modify image
### TO PUSH
docker commit wrf1 ishitadg/wrfhv5<br/>
docker push ishitadg/wrfhv5<br/>
docker images<br/>
### TO PULL
docker pull ishitadg/wrfhv5<br/>
docker run -d --rm --name wrf3 ishitadg/wrfhv5<br/>
wget -L https://github.com/ISHITADG/wrfstatic/blob/master/FORCING.tar.gz?raw=true <br/>
mv FORCING.tar.gz?raw=true FORCING.tar.gz<br/>
tar -xvzf FORCING.tar.gz<br/>
wget -L https://raw.githubusercontent.com/ISHITADG/wrfstatic/master/hydro.namelist<br/>
wget -L https://raw.githubusercontent.com/ISHITADG/wrfstatic/master/namelist.hrldas<br/>
