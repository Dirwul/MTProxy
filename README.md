# MTProto Proxy

## 1. Ставим `git` и `docker`

```bash
sudo apt update && sudo apt install -y git openssl
sudo curl -fsSL https://get.docker.com | sh
```


## 2. Тянем репозиторий

```bash
git clone https://github.com/Dirwul/MTProxy.git
cd MTProxy
```

## 3. `.env`

Идем в настройки .env:

`nano .env`

В котором:

`MT_SECRET` - 16 байт секрета, генерируется: `openssl rand -hex 16`

`PUBLIC_IP` - наш публичный IP

`PORT` - HTTP порт

`SERVICE_PORT` - TCP порт

`PRIVATE_IP` - IP докер контейнера

`DOCKER_NETWORK` - подсеть используемая контейнером


## 4. Запускаем и радуемся

`docker compose up -d && docker compose logs -f`