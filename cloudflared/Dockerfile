FROM busybox AS tools

FROM milgradesec/cloudflared
COPY --from=tools /bin/busybox /bin/busybox

# Having difficulties with SHELL ["/bin/busybox", "sh", "-c"] ENTRYPOINT []
ENTRYPOINT ["/bin/busybox", "sh", "-c"]
