# install
설치 스크립트

기본 설치: curl, git
```
if [ -x "$(command -v apt)" ]; then  sudo apt update -y && sudo apt install -y curl git; \
elif [ -x "$(command -v yum)" ]; then  sudo yum install -y curl git; \
elif [ -x "$(command -v dnf)" ]; then  sudo dnf install -y curl git; \
elif [ -x "$(command -v zypper)" ]; then  sudo zypper refresh && sudo pacman -S curl git; \
elif [ -x "$(command -v pacman)" ]; then  sudo pacman -Sy && sudo dnf install -y curl git; \
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
