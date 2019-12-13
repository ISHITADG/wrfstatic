# This repository holds Static contents of the container
1. Prerequisite libraries <br/>
2. Netcdf <br/>
3. Mpich <br/>
4. Hydro compiler source <br/>
5. Compiled wrf executable <br/>
6. working directory: contains rainfall & parameters and other executables <br/>
## download rainfall, parameter info and other files
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=FILEID' -O- | sed -rn 's/.confirm=([0-9A-Za-z_]+)./\1\n/p')&id=1Z0PiT8dRzrk8WLv6q5PA6LavE9Aq5R6d" -O forIshita.tgz && rm -rf /tmp/cookies.txt;

7. Domain case <br/>
## download domain case
RUN wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=FILEID' -O- | sed -rn 's/.confirm=([0-9A-Za-z_]+)./\1\n/p')&id=1F2FEl-uob5XAvE5DU_u3TkFGw61iKQod" -O c4_1.tar.gz && rm -rf /tmp/cookies.txt

8. script that runs executable**-to be done <br/>
9. Dockerfile that creates this container image and install all above items 1-8 <br/>

sudo wget https://raw.githubusercontent.com/ISHITADG/dockerNDN/master/dockovs.sh; <br/>
bash dockovs.sh; <br/>
sudo docker build -t wrfp .; <br/>
docker save wrfp -o wrf.tar; <br/>
docker run -d --rm --name wrfstatic wrfp; <br/>
