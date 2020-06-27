#
# youtube-dl Server Dockerfile
#
# https://github.com/manbearwiz/youtube-dl-server-dockerfile
#

FROM python:alpine

# VPN
ENV SURFSHARK_USER=
ENV SURFSHARK_PASSWORD=
ENV SURFSHARK_COUNTRY=
ENV SURFSHARK_CITY=
ENV CONNECTION_TYPE=tcp

HEALTHCHECK --interval=60s --timeout=10s --start-period=30s CMD curl -L 'https://ipinfo.io'

RUN apk add --update --no-cache openvpn wget unzip coreutils curl
WORKDIR /vpn
COPY startup.sh .

RUN chmod +x ./startvpn.sh
CMD [ "./startvpn.sh" ]

# youtube-dl server
RUN apk add --no-cache \
  ffmpeg \
  tzdata

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r requirements.txt

COPY . /usr/src/app

EXPOSE 8080

VOLUME ["/youtube-dl"]

CMD [ "python", "-u", "./youtube-dl-server.py" ]
