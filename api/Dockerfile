# Build Stage
FROM golang:1.20 AS builder
WORKDIR /app
COPY main.go .
RUN go mod init api && go mod tidy
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o server main.go

# Final Image
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/server .
CMD ["./server"]
EXPOSE 8080