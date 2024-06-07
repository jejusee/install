#!/bin/bash

# /etc/os-release 파일을 읽고 배포판 정보 결정
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
    VERSION=$VERSION_ID
    ARCH=$(uname -m)
    
    echo "This is ${NAME}, version ${VERSION}, architecture ${ARCH}."
else
    echo "Unsupported Linux distribution."
    exit 1
fi

# 배포판 및 아키텍처에 따른 분기 처리
case "${DISTRO}" in
    centos)
        echo "This is CentOS, version ${VERSION}, architecture ${ARCH}."

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
        echo "This is Red Hat Enterprise Linux, version ${VERSION}, architecture ${ARCH}."

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
        echo "This is Fedora, version ${VERSION}, architecture ${ARCH}."

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
        echo "This is Debian, version ${VERSION}, architecture ${ARCH}."

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
        echo "This is Ubuntu, version ${VERSION}, architecture ${ARCH}."

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
        echo "This is Raspbian (for Raspberry Pi), version ${VERSION}, architecture ${ARCH}."
        
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
        echo "This is SUSE Linux Enterprise Server, version ${VERSION}, architecture ${ARCH}."

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

# 최종 상태 확인
docker --version
sudo systemctl status docker --no-pager
