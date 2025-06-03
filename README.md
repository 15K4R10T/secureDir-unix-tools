# secureDir-unix-tools
Tools ini saya gunakan untuk mengatur secara otomatis semua chmod file dan directory yang berisi kredensial yang ada pada linux saya, dan ini berjalan dengan menggunakan script bash, silahkan coba, project ini saya buat untuk melaksanakan hardening task dengan lebih mudah

# Manuals 

sudo chmod +x secureDir.sh
./secureDir.sh

./secureDir.sh
=== SECURING UBUNTU 24.04 DIRECTORIES ===
Setting root directory permissions...
Securing home directories...
Setting user home directory permissions...
NOTE: Replace 'username' with actual usernames
Secured: /home/circuitz
Securing critical system directories...
Securing executable directories...
Securing log and variable directories...
Securing temporary directories...
Securing system process directories...
Securing application directories...
Securing SSH directories for users...
Secured SSH directory for: circuitz
Securing cron directories...
Applying additional security measures...
=== DIRECTORY SECURITY CONFIGURATION COMPLETED ===

SUMMARY OF APPLIED PERMISSIONS:
/ (root)           -> 755 (root:root)
/home             -> 755 (root:root)
/home/user        -> 750 (user:user)
/boot             -> 700 (root:root)
/etc              -> 755 (root:root)
/tmp              -> 1777 (root:root) with sticky bit
/var/log          -> 755 (root:root)
/var/www          -> 755 (root:root)
SSH directories   -> 700 (user:user)
SSH keys          -> 600/644 (user:user)

RECOMMENDATION: Test all applications after applying these changes!
