FROM golang as build
WORKDIR /app
COPY go.mod go.sum /app/
RUN go get
COPY main.go plugin.go /app/
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -a -tags netgo -o release/linux/amd64/drone-slack

FROM alpine:3.7
RUN apk add ca-certificates
COPY --from=build /app/release/linux/amd64/drone-slack /bin/
ENTRYPOINT ["/bin/drone-slack"]