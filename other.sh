#!/bin/bash

# Function to check if UFW is installed
check_ufw_installed() {
    if ! command -v ufw &> /dev/null; then
        echo "UFW is not installed. Installing now..."
        sudo apt-get update
        sudo apt-get install -y ufw
    else
        echo "UFW is already installed."
    fi
}

# Function to set up UFW rules
setup_ufw_rules() {
    echo "Setting up UFW rules..."

    # Reset UFW to default settings
    sudo ufw --force reset

    # Set default policies
    sudo ufw default deny incoming
    sudo ufw default allow outgoing

    # Allow SSH (port 22)
    sudo ufw allow ssh

    # Allow HTTP (port 80)
    sudo ufw allow http

    # Allow HTTPS (port 443)
    sudo ufw allow https

    # Allow ports 5000-9999 for general purpose TCP applications
    sudo ufw allow 5000:9999/tcp

    echo "UFW rules have been set up."
}

# Function to enable UFW
enable_ufw() {
    echo "Enabling UFW..."
    sudo ufw --force enable
    echo "UFW has been enabled."
}

# Function to display UFW status
show_ufw_status() {
    echo "Current UFW status:"
    sudo ufw status verbose
}

# Main function
main() {
    check_ufw_installed
    setup_ufw_rules
    enable_ufw
    show_ufw_status
}

# Run the main function
main

echo "UFW setup completed."