FROM golang:1.25.5-alpine3.22 AS builder
WORKDIR /app/
COPY go.mod go.sum /app/
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -v

FROM python:alpine
RUN apk update && apk upgrade
COPY --from=builder /app/yt-dlp-telegram-bot /app/yt-dlp-telegram-bot
COPY --from=builder /app/yt-dlp.conf /root/yt-dlp.conf

ENTRYPOINT ["/app/yt-dlp-telegram-bot"]
