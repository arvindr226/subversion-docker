#!/bin/bash
PositionalParamExists="$1"
if [ -z "${PositionalParamExists}" ]; then
 echo "Please enter proper Repository Name"
 exit;
fi
svnadmin create /var/lib/svn/$1
chmod -R 775 /var/lib/svn/$1
chown -R www-data:www-data /var/lib/svn/$1
echo "Enter user to assign existing user (default admin):"
read user
echo "<Location /svn/$1>
 AuthType Basic
 AuthName \"$1 Subversion Repository\"
 AuthUserFile /etc/global.htpasswd
 Require user admin $user
</Location>"
 >> /etc/apache2/mods-enabled/dav_svn.conf
#nano /etc/apache2/mods-enabled/dav_svn.conf
/etc/init.d/apache2 reload
