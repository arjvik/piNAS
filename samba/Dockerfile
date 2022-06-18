FROM alpine:latest

RUN apk add shadow
RUN usermod -u 1000 nobody && groupmod -g 1000 nobody
RUN apk add samba

CMD ["smbd", "-F", "--no-process-group", "--debug-stdout", "-d", "2"]
