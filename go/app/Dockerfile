FROM golang:1.11 as builder
WORKDIR /go/src/github.com/codephobia/the-dockering/go/app/src/
COPY src/main.go .
RUN go get -d -v ./... \
    && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

FROM scratch as app
WORKDIR /app/
COPY --from=builder /go/src/github.com/codephobia/the-dockering/go/app/src/main .
EXPOSE 8080
CMD ["./main"]