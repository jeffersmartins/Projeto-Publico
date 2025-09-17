# syntax=docker/dockerfile:1.4
FROM golang:1.24.4 AS builder

# instala git
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# build-arg para passar o token do GitHub
ARG GITHUB_TOKEN

# clona o submódulo privado usando o token
RUN git clone https://$GITHUB_TOKEN@github.com/jeffersmartins/Submodulo-Privado.git Submodulo-Privado

# copia os arquivos do projeto público
COPY go.mod main.go ./

# garante que Go vai usar o submódulo local
RUN go mod tidy

# builda o binário
RUN go build -o app main.go

# imagem final minimalista
FROM debian:bookworm-slim
WORKDIR /app
COPY --from=builder /app/app .

CMD ["./app"]
