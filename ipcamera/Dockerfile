FROM golang:latest

RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg && rm -rf /var/lib/apt/lists/*

RUN go get github.com/blueimp/mjpeg-server

WORKDIR /go/pkg/mod/github.com/blueimp/mjpeg-server@v1.3.0

CMD go run main.go -a 0.0.0.0:9000 -- ffmpeg -i "rtsp://$BASIC_AUTH@$CAMERA_IP/" -r 25 -f mpjpeg pipe:
