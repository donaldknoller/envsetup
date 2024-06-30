#!/bin/bash

# Function to install and configure fail2ban
setup_fail2ban() {
    echo "Setting up fail2ban..."
    sudo apt-get install -y fail2ban

    # Create a local configuration file
    sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

    # Configure fail2ban
    sudo tee /etc/fail2ban/jail.local > /dev/null <<EOT
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 5
bantime = 3600
EOT

    # Restart fail2ban to apply changes
    sudo systemctl restart fail2ban
    echo "fail2ban setup completed."
}

# Function to install and configure logwatch
setup_logwatch() {
    echo "Setting up logwatch..."
    sudo apt-get install -y logwatch

    # Configure logwatch to send daily emails
    sudo tee /etc/cron.daily/00logwatch > /dev/null <<EOT
#!/bin/bash
/usr/sbin/logwatch --output mail --mailto root --detail high
EOT

    sudo chmod +x /etc/cron.daily/00logwatch
    echo "logwatch setup completed."
}

# Function to install additional useful tools
install_additional_tools() {
    echo "Installing additional tools..."
    sudo apt-get install -y \
        htop \
        iotop \
        ncdu \
        tmux \
        vim \
        unattended-upgrades

    # Configure unattended-upgrades for automatic security updates
    sudo dpkg-reconfigure -plow unattended-upgrades

    echo "Additional tools installed."
}

# Function to set up a basic iptables logging
setup_iptables_logging() {
    echo "Setting up basic iptables logging..."
    sudo iptables -A INPUT -j LOG --log-prefix "IPTables-Dropped: " --log-level 4
    sudo apt-get install -y iptables-persistent
    sudo netfilter-persistent save
    echo "iptables logging setup completed."
}

# Function to harden SSH configuration
harden_ssh() {
    echo "Hardening SSH configuration..."
    sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
    sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
    sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    sudo systemctl restart ssh
    echo "SSH hardening completed."
}

# Main function
main() {
    # Update package list
    sudo apt-get update

    setup_fail2ban
    setup_logwatch
    install_additional_tools
    setup_iptables_logging
    harden_ssh

    echo "All additional security and monitoring tools have been set up."
}

# Run the main function
main

echo "Setup script completed. Please review the configurations and reboot the system if necessary."