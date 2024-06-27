#!/bin/bash

# Function to create a new user
create_user() {
    local username="ubunthu"
    local password="$1"

    echo "Creating new user: $username"
    sudo adduser --gecos "" --disabled-password "$username"
    echo "$username:$password" | sudo chpasswd

    # Add user to sudo group
    sudo usermod -aG sudo "$username"

    echo "User $username created successfully."
}

# Function to install Docker
install_docker() {
    echo "Installing Docker..."

    # Update the apt package index
    sudo apt-get update

    # Install packages to allow apt to use a repository over HTTPS
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Set up the stable repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker Engine
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    # Add the new user to the docker group
    sudo usermod -aG docker ubunthu

    echo "Docker installed successfully."
}

# Function to install Python
install_python() {
    echo "Installing Python..."

    sudo apt-get update
    sudo apt-get install -y python3 python3-pip python3-is-python

    echo "Python installed successfully."
}

# Main function
main() {
    if [ $# -eq 0 ]; then
        echo "Error: Password not provided."
        echo "Usage: $0 <new_password>"
        exit 1
    fi

    NEW_PASSWD="$1"

    create_user "$NEW_PASSWD"
    install_docker
    install_python

    echo "All tasks completed successfully."
}

# Run the main function
main "$@"