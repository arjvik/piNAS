FROM busybox

RUN if [[ $(uname -m) == "arm64" ]]; then arch="arm64"; elif [[ $(uname -m) == "x86_64" ]]; then arch="amd64"; else false; fi && \
	wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-$arch -O /usr/sbin/cloudflared
