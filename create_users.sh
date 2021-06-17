#!/bin/sh

#sudo apt install apache2-utils
#or use docker
#docker run -entrypoint htpasswd httpd:2 -Bbn user 12345 > ./auth/.htpasswd

# -c - create new file
# -b - use command line input for password
# -B - use bcrypt algorithm (required by docker registry)
# -D - delete user

mkdir auth
# create new file with user
htpasswd -cbB ./auth/.htpasswd user 12345

# add user to existed file
#htpasswd -bB ./auth/.htpasswd user 12345

# delete user
#htpasswd -DbB ./auth/.htpasswd user 12345