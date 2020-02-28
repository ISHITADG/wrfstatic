# This repository holds Static contents of the container (all of the below have already been installed in the docker container via the Dockerfile in this repo)
1. Prerequisites (hdf5,zlib,netcdf-c 4 and netcdf-f 4) <br/>
3. Mpich to be installed from http://www.mpich.org/static/downloads/3.3.2/mpich-3.3.2.tar.gz (ZIP file too large to be icluded in here )<br/>
4. wrfHydro v5 model source <br/>
5. Compiled wrf executable <br/>
6. Test case including rainfall, domain files, parameters: run.tar.gz <br/>
7. script that runs executable**-to be done <br/>
9. Dockerfile that creates this container image and install all above items 1-8 <br/>

## steps to create container from the above Dockerfile
sudo wget https://raw.githubusercontent.com/ISHITADG/dockerNDN/master/dockovs.sh;<br/>
bash dockovs.sh;<br/>
wget -L https://raw.githubusercontent.com/ISHITADG/wrfstatic/master/Dockerfile; <br/>
sudo docker build -t wrfishita .;<br/>
docker run -d --rm --name wrf1 wrfishita;<br/>
docker exec -it wrf1 bash <br/>
## test run inside the container 
cd /example_case/NWM/<br/>
mpirun -np 2 ./wrf_hydro_NoahMP.exe <br/>
// time /usr/bin/mpiexec --allow-run-as-root -np 4 -mca btl ^openib ./wrf_hydro_NoahMP.exe >output.txt;<br/>

## push docker
docker login --username=ishitadg;<br/>
enter password: Ishidock91* <br/>
docker tag wrfishita ishitadg/wrfhv5<br/>
docker push ishitadg/wrfhv5<br/>
