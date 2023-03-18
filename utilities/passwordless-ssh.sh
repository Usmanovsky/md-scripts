#!/bash/bin

# This helps set up passwordless login to remote machines.
# $1 is your email, 42 is the remote IP address.
ls -al ~/.ssh/id_*.pub
ssh-keygen -t rsa -b 4096 -C "$1"

ssh-copy-id $2
