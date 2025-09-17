# syntax=docker/dockerfile:1.6

# Etapa de build
FROM golang:1 AS builder

ARG GITHUB_TOKEN
ENV CGO_ENABLED=0
WORKDIR /app

# Instala git
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Cria o go.mod e main.go diretamente no container
RUN echo 'module github.com/jeffersmartins/Projeto-Publico\n\ngo 1.24.4\n\nrequire github.com/jeffersmartins/Submodulo-Privado v0.0.0\n\nreplace github.com/jeffersmartins/Submodulo-Privado => ./Submodulo-Privado' > go.mod

RUN echo 'package main\n\nimport (\n\t"fmt"\n\t"time"\n\n\tsubmod "github.com/jeffersmartins/Submodulo-Privado"\n)\n\nfunc main() {\n\tuser := submod.User{\n\t\tID:        1,\n\t\tName:      "Jefão",\n\t\tEmail:     "jefao@teste.com",\n\t\tCreatedAt: time.Now(),\n\t}\n\n\tfmt.Printf("Usuário: %+v\\n", user)\n}' > main.go

# Garante que o submódulo exista com conteúdo (repo privado)
RUN git clone https://$GITHUB_TOKEN@github.com/jeffersmartins/Submodulo-Privado.git Submodulo-Privado

# Debug: lista arquivos para verificar
RUN ls -la /app

# Baixa deps e compila binário enxuto
RUN go mod tidy \
    && go build -trimpath -ldflags "-s -w" -o /app/app ./main.go

# Etapa final mínima
FROM alpine:3.20
RUN apk add --no-cache ca-certificates
WORKDIR /app
COPY --from=builder /app/app /app/app

ENTRYPOINT ["/app/app"]
