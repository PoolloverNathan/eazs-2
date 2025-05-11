FROM alpine
RUN apk add go
ENV GOBIN=/usr/local/bin
RUN go install github.com/packwiz/packwiz@latest
COPY --link . /pack
WORKDIR /pack
RUN packwiz refresh --build

FROM alpine
ADD https://meta.fabricmc.net/v2/versions/loader/1.20.1/0.16.10/1.0.1/server/jar /app/fabric-server.jar
ADD https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar /app/packwiz-installer-bootstrap.jar
COPY --link --from=0 /pack /app/pack
COPY <<EOT /app/start.sh
set -e
java -jar /app/packwiz-installer-bootstrap.jar -g -s server /app/pack/pack.toml
echo "eula=true" > /mnt/eula.txt
exec java -Xms4G -Xmx12G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar /app/fabric-server.jar nogui "\$@"
EOT

FROM amazoncorretto:21-alpine3.21
COPY --link --from=1 /app /app
WORKDIR /mnt
VOLUME /mnt
ENTRYPOINT ["sh", "/app/start.sh"]
EXPOSE 25565
EXPOSE 23443/udp
