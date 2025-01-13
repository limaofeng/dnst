FROM cm2network/steamcmd

USER root

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y libcurl4-gnutls-dev:i386

USER steam

RUN ./steamcmd.sh +force_install_dir /home/steam/dst +login anonymous +app_update 343050 validate +quit

WORKDIR /home/steam/dst

COPY ./template /home/steam/dst/template
COPY ./scripts /home/steam/dst/scripts

EXPOSE 10888 10999 8766 27016
EXPOSE 10998 8765 27015

