/bin/bash

# Making all required files if they are not existing. (This means
# you may add a Docker volume on /etc/ssh or /root to insert your
# own files.
test -f /etc/ssh/ssh_host_ecdsa_key || /usr/bin/ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -C '' -N ''
test -f /etc/ssh/ssh_host_rsa_key || /usr/bin/ssh-keygen -q -t rsa -f /etc/ssh/ssh_host_rsa_key -C '' -N ''
test -f /etc/ssh/ssh_host_ed25519_key || /usr/bin/ssh-keygen -q -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -C '' -N ''
test -f ~/.ssh/id_rsa || /usr/bin/ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ''
test -f ~/.ssh/id_rsa.pub || ssh-keygen -y -t rsa -f ~/.ssh/id_rsa > ~/.ssh/id_rsa.pub
test -f ~/.ssh/authorized_keys || /usr/bin/cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys

# Change the owner.
chown -R $USER:$USER ~/.ssh

# Show the private key.
/usr/bin/cat ~/.ssh/id_rsa
/usr/bin/echo ""
/usr/bin/echo "Please save the printed private RSA key and login using:"
/usr/bin/echo "\"ssh -i \${savedkey} root@\${ipaddress}\""

#Required in AWS Lambda
chmod 755 /var/empty/sshd

# Now start ssh.
/usr/sbin/sshd -p 5555 -D
