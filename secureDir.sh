#!/bin/bash
# =====================================================
# Ubuntu 24.04 Directory Security Configuration Script
# =====================================================

echo "=== SECURING UBUNTU 24.04 DIRECTORIES ==="

# =====================================================
# ROOT DIRECTORY (/) PERMISSIONS
# =====================================================
echo "Setting root directory permissions..."
sudo chmod 755 /
sudo chown root:root /

# =====================================================
# HOME DIRECTORIES SECURITY
# =====================================================
echo "Securing home directories..."

# Main /home directory
sudo chmod 755 /home
sudo chown root:root /home

# Individual user home directories (adjust usernames as needed)
# Replace 'username' with actual usernames on your system
echo "Setting user home directory permissions..."
echo "NOTE: Replace 'username' with actual usernames"

# Example for typical user directories
# sudo chmod 750 /home/username
# sudo chown username:username /home/username

# Secure all existing user home directories
for user_home in /home/*; do
    if [ -d "$user_home" ]; then
        username=$(basename "$user_home")
        if id "$username" &>/dev/null; then
            sudo chmod 750 "$user_home"
            sudo chown "$username:$username" "$user_home"
            echo "Secured: $user_home"
        fi
    fi
done

# =====================================================
# CRITICAL SYSTEM DIRECTORIES
# =====================================================
echo "Securing critical system directories..."

# Boot directory
sudo chmod 700 /boot
sudo chown root:root /boot

# Configuration directories
sudo chmod 755 /etc
sudo chown root:root /etc

# Sensitive config files
sudo chmod 600 /etc/shadow
sudo chmod 600 /etc/gshadow
sudo chmod 644 /etc/passwd
sudo chmod 644 /etc/group
sudo chmod 600 /etc/ssh/sshd_config
sudo chmod 644 /etc/ssh/ssh_config

# =====================================================
# EXECUTABLE DIRECTORIES
# =====================================================
echo "Securing executable directories..."

# System binaries
sudo chmod 755 /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin
sudo chown root:root /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin

# Library directories
sudo chmod 755 /lib /lib64 /usr/lib /usr/lib64
sudo chown root:root /lib /lib64 /usr/lib /usr/lib64 2>/dev/null

# =====================================================
# LOG AND VARIABLE DIRECTORIES
# =====================================================
echo "Securing log and variable directories..."

# Log directories
sudo chmod 755 /var/log
sudo chown root:root /var/log
sudo chmod 640 /var/log/auth.log /var/log/syslog 2>/dev/null
sudo chmod 600 /var/log/secure 2>/dev/null

# Variable directories
sudo chmod 755 /var
sudo chown root:root /var
sudo chmod 1777 /var/tmp  # Sticky bit for tmp
sudo chmod 755 /var/www 2>/dev/null

# =====================================================
# TEMPORARY DIRECTORIES
# =====================================================
echo "Securing temporary directories..."

# Temporary directories with sticky bit
sudo chmod 1777 /tmp
sudo chmod 1777 /var/tmp
sudo chown root:root /tmp /var/tmp

# =====================================================
# PROCESS AND SYSTEM DIRECTORIES
# =====================================================
echo "Securing system process directories..."

# Process filesystem
sudo chmod 555 /proc 2>/dev/null
sudo chmod 555 /sys 2>/dev/null

# Device directory
sudo chmod 755 /dev
sudo chown root:root /dev

# =====================================================
# APPLICATION DIRECTORIES
# =====================================================
echo "Securing application directories..."

# Web server directories (if exists)
if [ -d "/var/www" ]; then
    sudo chmod 755 /var/www
    sudo chown root:root /var/www
    # Set proper permissions for web content
    find /var/www -type d -exec sudo chmod 755 {} \;
    find /var/www -type f -exec sudo chmod 644 {} \;
fi

# Database directories (MySQL/MariaDB)
if [ -d "/var/lib/mysql" ]; then
    sudo chmod 700 /var/lib/mysql
    sudo chown mysql:mysql /var/lib/mysql
fi

# SSH directory
sudo chmod 755 /etc/ssh
sudo chmod 600 /etc/ssh/ssh_host_*_key
sudo chmod 644 /etc/ssh/ssh_host_*_key.pub

# =====================================================
# USER SSH DIRECTORIES (run for each user)
# =====================================================
echo "Securing SSH directories for users..."

# Function to secure user SSH directory
secure_user_ssh() {
    local username=$1
    local ssh_dir="/home/$username/.ssh"
    
    if [ -d "$ssh_dir" ]; then
        sudo chmod 700 "$ssh_dir"
        sudo chown "$username:$username" "$ssh_dir"
        
        # SSH key files
        if [ -f "$ssh_dir/authorized_keys" ]; then
            sudo chmod 600 "$ssh_dir/authorized_keys"
            sudo chown "$username:$username" "$ssh_dir/authorized_keys"
        fi
        
        # Private keys
        find "$ssh_dir" -name "id_*" ! -name "*.pub" -exec sudo chmod 600 {} \;
        find "$ssh_dir" -name "id_*" ! -name "*.pub" -exec sudo chown "$username:$username" {} \;
        
        # Public keys
        find "$ssh_dir" -name "*.pub" -exec sudo chmod 644 {} \;
        find "$ssh_dir" -name "*.pub" -exec sudo chown "$username:$username" {} \;
        
        echo "Secured SSH directory for: $username"
    fi
}

# Apply to all users with home directories
for user_home in /home/*; do
    if [ -d "$user_home" ]; then
        username=$(basename "$user_home")
        if id "$username" &>/dev/null; then
            secure_user_ssh "$username"
        fi
    fi
done

# =====================================================
# CRON AND SCHEDULED TASKS
# =====================================================
echo "Securing cron directories..."

sudo chmod 755 /etc/cron.d /etc/cron.daily /etc/cron.hourly /etc/cron.monthly /etc/cron.weekly
sudo chmod 600 /etc/crontab
sudo chmod 700 /var/spool/cron 2>/dev/null

# =====================================================
# ADDITIONAL SECURITY MEASURES
# =====================================================
echo "Applying additional security measures..."

# Remove world-writable permissions on system files
find /etc -type f -perm -002 -exec sudo chmod o-w {} \; 2>/dev/null

# Secure sensitive files
sudo chmod 600 /etc/sudoers
sudo chmod 440 /etc/sudoers.d/* 2>/dev/null

# Secure service files
sudo chmod 644 /etc/systemd/system/*.service 2>/dev/null

echo "=== DIRECTORY SECURITY CONFIGURATION COMPLETED ==="
echo ""
echo "SUMMARY OF APPLIED PERMISSIONS:"
echo "/ (root)           -> 755 (root:root)"
echo "/home             -> 755 (root:root)" 
echo "/home/user        -> 750 (user:user)"
echo "/boot             -> 700 (root:root)"
echo "/etc              -> 755 (root:root)"
echo "/tmp              -> 1777 (root:root) with sticky bit"
echo "/var/log          -> 755 (root:root)"
echo "/var/www          -> 755 (root:root)"
echo "SSH directories   -> 700 (user:user)"
echo "SSH keys          -> 600/644 (user:user)"
echo ""
echo "RECOMMENDATION: Test all applications after applying these changes!"
