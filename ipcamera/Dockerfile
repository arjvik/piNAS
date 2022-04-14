FROM golang:latest

RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg && rm -rf /var/lib/apt/lists/*

RUN go install github.com/blueimp/mjpeg-server@latest

WORKDIR /go/pkg/mod/github.com/blueimp/mjpeg-server@v1.3.0

CMD exec go run main.go -a 0.0.0.0:9000 -- ffmpeg -i "$CAMERA_FEED" -r 25 -f mpjpeg pipe:
