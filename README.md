# install
설치 스크립트

curl 설치
```
if [ -x "$(command -v apt)" ]; then  apt update -y && apt install -y curl; \
elif [ -x "$(command -v yum)" ]; then  yum install -y curl; \
elif [ -x "$(command -v dnf)" ]; then  dnf install -y curl; \
fi
```

docker
```
curl -fsSL "https://raw.githubusercontent.com/jejusee/install/main/docker.sh" | sudo bash
```
docker-compose
```
curl -fsSL "https://raw.githubusercontent.com/jejusee/install/main/docker-compose.sh" | sudo bash
```

git
```
curl -fsSL "https://raw.githubusercontent.com/jejusee/install/main/git.sh" | sudo bash
```

rclone
```
curl -fsSL "https://raw.githubusercontent.com/jejusee/install/main/rclone.sh" | sudo bash
```

flaskfarm
```
curl -fsSL "https://raw.githubusercontent.com/jejusee/install/main/flaskfarm.sh" | sudo bash
```
