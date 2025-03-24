FROM alpine
RUN apk add openjdk21
ADD https://meta.fabricmc.net/v2/versions/loader/1.20.1/0.16.10/1.0.1/server/jar /fabric-server.jar
ADD https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar /packwiz-installer-bootstrap.jar
COPY --link . /pack
COPY <<EOT /start.sh
set -e
java -jar /packwiz-installer-bootstrap.jar -g -s server /pack/pack.toml
exec java -jar /fabric-server.jar nogui
EOT
VOLUME /app
WORKDIR /app
ENTRYPOINT ["sh", "/start.sh"]
EXPOSE 25565
