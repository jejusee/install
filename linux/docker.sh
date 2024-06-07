#!/bin/bash

# /etc/os-release 파일을 읽고 배포판 정보 결정
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
    VERSION=$VERSION_ID
    ARCHITECTURE=$(uname -m)
    
    echo "This is ${NAME}, version ${VERSION}, architecture ${ARCHITECTURE}."
else
    echo "Unsupported Linux distribution."
    exit 1
fi

# 배포판 및 아키텍처에 따른 분기 처리
#
echo "docker 를 설치합니다."
case "${DISTRO}" in
    centos)
        # Uninstall old versions
        sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

        # Set up the repository
        sudo yum install -y yum-utils
        sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

         # Install Docker Engine(Latest)
         sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

         # Start Docker
         sudo systemctl start docker
        ;;
    rhel | "redhat")
        # Uninstall old versions
        sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine \
                  podman \
                  runc

        # Set up the repository
        sudo yum install -y yum-utils
        sudo yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

        # Install Docker Engine(Latest)
        sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

         # Start Docker
         sudo systemctl start docker
        ;;
    fedora)
        # Uninstall old versions
        sudo dnf remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

        # Set up the repository
        sudo dnf -y install dnf-plugins-core
        sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

        # Install Docker Engine(Latest)
        sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        
         # Start Docker
         sudo systemctl start docker && sudo systemctl enable docker
        ;;
    debian)
        # Uninstall old versions
        for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

        # Set up Docker's apt repository.
        # Add Docker's official GPG key:
        sudo apt-get update
        sudo apt-get install ca-certificates curl
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc
        
        # Add the repository to Apt sources:
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
          $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
          sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update

        # Install Docker Engine(Latest)
        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        ;;
    ubuntu)
        # Uninstall old versions
        for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

        # Set up Docker's apt repository.
        # Add Docker's official GPG key:
        sudo apt-get update
        sudo apt-get install ca-certificates curl
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc
        
        # Add the repository to Apt sources:
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
          $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
          sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update

        # Install Docker Engine(Latest)
        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        ;;
    raspbian)        
        # Uninstall old versions
        for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

        # Set up Docker's apt repository.
        # Add Docker's official GPG key:
        sudo apt-get update
        sudo apt-get install ca-certificates curl
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/raspbian/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc
        
        # Set up Docker's APT repository:
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/raspbian \
          $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
          sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update
        
        # Install Docker Engine(Latest)
         sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        ;;
    sles)
        #  OpenSUSE SELinux repository
        opensuse_repo="https://download.opensuse.org/repositories/security:/SELinux/openSUSE_Factory/security:SELinux.repo"
        sudo zypper addrepo $opensuse_repo

        # Uninstall old versions
        sudo zypper remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine \
                  runc

        # Set up the rpm repository
        sudo zypper addrepo https://download.docker.com/linux/sles/docker-ce.repo

        # Install Docker Engine(Latest)
        sudo zypper install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

        # Start Docker
        sudo systemctl start docker && sudo systemctl enable docker
        ;;
    *)
        echo "Unknown or unsupported Linux distribution."
        ;;
esac

echo "Docker Compose 를 설치합니다."
case $ARCHITECTURE in
    "x86_64")
        sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
        sudo chmod +x /usr/bin/docker-compose
        echo "Docker Compose 설치 완료."
        ;;
    "aarch64")
        sudo dnf install -y libffi libffi-devel openssl-devel python3 python3-pip python3-devel
        sudo pip3 install docker-compose
#        sudo mv /usr/local/bin/docker-compose /usr/bin/
        echo "Docker Compose 설치 완료."
        ;;
    *)
        echo "Unknown or unsupported architecture"
        ;;
   esac

# 설치 확인
echo "설치된 Docker 버전:"
docker --version

echo "설치된 Docker Compose 버전:"
docker-compose --version
