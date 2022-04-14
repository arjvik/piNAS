FROM alpine:latest

#RUN addgroup -g 1000 samba && adduser -u 1000 -G samba -g samba-user -S -H samba
RUN apk add shadow
RUN usermod -u 1000 nobody && groupmod -g 1000 nobody
RUN apk add samba

CMD ["smbd", "-i"]
