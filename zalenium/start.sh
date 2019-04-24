winpty docker run --rm -ti --name zalenium -p 4444:4444 \
-v //var/run/docker.sock:/var/run/docker.sock \
-e timeZone=Asia/Shanghai \
--privileged dosel/zalenium start