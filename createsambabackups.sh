#!/bin/bash
#this script create user and group for samba user

USER="atakan" # unix user  valid users and admin users you can define with comma smith,john stc..
SAMBACONFIG="/etc/samba/smb.conf"
SAMBASHAREGROUP="smbshare"
BACKUPDIR="/backups"
BACKUPTEMPLATE=$(cat <<EOF
[backups]
comment =System Backup Dir
path = $BACKUPDIR
writeable = Yes
valid users = $USER
admin users = $USER
EOF
)
echo "Samba Share Group Created:$SAMBASHAREGROUP"
groupadd $SAMBASHAREGROUP
echo "user:$USER adding to group:$SAMBASHAREGROUP"
usermod -G $SAMBASHAREGROUP $USER
mkdir $BACKUPDIR
chown -R $USER:$SAMBASHAREGROUP $BACKUPDIR
echo "samba  template writing to smb.conf :"
echo "$BACKUPTEMPLATE"
echo "$BACKUPTEMPLATE" >> $SAMBACONFIG
echo "Please enter password for user: $USER:"
smbpasswd -a $USER # add user password for samba
echo "Added password to: $USER:"
echo "testing config file"
testparm # test samba config
service samba restart
