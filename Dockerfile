FROM alpine
ADD https://meta.fabricmc.net/v2/versions/loader/1.20.1/0.16.10/1.0.1/server/jar /app/fabric-server.jar
ADD https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar /app/packwiz-installer-bootstrap.jar
COPY --link . /app/pack
COPY <<EOT /app/start.sh
set -e
java -jar /app/packwiz-installer-bootstrap.jar -g -s server /app/pack/pack.toml
exec java -jar /app/fabric-server.jar nogui
EOT

FROM alpine
RUN apk add openjdk21 libstdc++
COPY --link --from=0 /app /app
WORKDIR /mnt
VOLUME /mnt
ENTRYPOINT ["sh", "/app/start.sh"]
EXPOSE 25565
