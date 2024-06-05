#!/bin/bash

# 최신 Docker 버전을 GitHub API를 통해 확인
latest_version=$(curl -s https://api.github.com/repos/docker/docker-ce/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')

# 현재 설치된 Docker 버전 확인
if command -v docker &> /dev/null; then
    current_version=$(docker version --format '{{.Server.Version}}')
    docker_installed=true
else
    current_version="none"
    docker_installed=false
fi

echo "현재 Docker 버전: $current_version"
echo "최신 Docker 버전: $latest_version"

if [ "$docker_installed" = true ] && [ "$current_version" = "$latest_version" ]; then
    read -p "이미 최신 버전의 Docker가 설치되어 있습니다. 다시 설치할까요? (y/N): " user_input
    user_input=${user_input:-n}
    if [[ "$user_input" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        reinstall=true
    else
        reinstall=false
    fi
else
    reinstall=true
fi

if [ "$reinstall" = true ]; then
    # Docker 설치 또는 업데이트 명령
    if [ -x "$(command -v apt-get)" ]; then
        # Debian 기반 배포판
        sudo apt-get update
        sudo apt-get remove docker docker-engine docker.io containerd runc
        sudo apt-get install -y \
            ca-certificates \
            curl \
            gnupg \
            lsb-release
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
            $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    elif [ -x "$(command -v yum)" ]; then
        # Red Hat 기반 배포판
        sudo yum remove docker \
                    docker-client \
                    docker-client-latest \
                    docker-common \
                    docker-latest \
                    docker-latest-logrotate \
                    docker-logrotate \
                    docker-engine
        sudo yum install -y yum-utils
        sudo yum-config-manager \
            --add-repo \
            https://download.docker.com/linux/centos/docker-ce.repo
        sudo yum install -y docker-ce docker-ce-cli containerd.io
    elif [ -x "$(command -v zypper)" ]; then
        # SUSE 기반 배포판
        sudo zypper remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
        sudo zypper install -y docker
    else
        echo "지원되지 않는 패키지 매니저입니다."
        exit 1
    fi

    # Docker 서비스 시작 및 활성화
    sudo systemctl start docker
    sudo systemctl enable docker
else
    echo "Docker 설치 또는 업데이트를 건너뜁니다."
fi

# Docker 데몬이 실행 중인지 확인
if ! sudo systemctl is-active --quiet docker; then
    echo "Docker 데몬이 실행 중이 아닙니다. 활성화합니다."
    sudo systemctl start docker
    sudo systemctl enable docker
else
    echo "Docker 데몬이 이미 실행 중입니다."
fi

# 최종 상태 확인
docker --version
sudo systemctl status docker --no-pager
