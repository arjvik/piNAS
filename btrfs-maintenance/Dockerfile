FROM alpine:latest

RUN apk add btrfs-progs curl

COPY btrfs-maintenance.sh /usr/local/bin

RUN chmod a+x /usr/local/bin/btrfs-maintenance.sh

ENTRYPOINT ["sh", "-c"]
CMD ["btrfs-maintenance.sh"]
