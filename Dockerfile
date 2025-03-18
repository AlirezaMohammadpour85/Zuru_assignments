# Build Stage
FROM golang:1.20 AS builder
WORKDIR /app
COPY api/main.go .
RUN go mod init api && go mod tidy
RUN go build -o server main.go

# Final Image
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/server .
CMD ["./server"]
EXPOSE 8080