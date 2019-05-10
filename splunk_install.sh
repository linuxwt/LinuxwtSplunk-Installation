#!/bin/bash
######script for installing Splunk Enterprise 7.2.6#####################################
######you can definite username password  directory of Splunk installation by yourself######

# judge the user of the scipt
[ ${UID} -ne 0 ] && { echo "the script need root.";exit 1; }

# judge whether exist postion arguments $1
# if $1 is null,default /opt
splunk_dir=${1:-"/opt"}

# set user password of splunk
splunk_user=${2:?"please enter username for \$2"}
splunk_password=${3:?"please enter password for \$3"}

# configure dir of splunk installation
[ -d $1 ] && mkdir -p $1

# download binary package and extract file
[ -f /usr/bin/wget ] && { cd /opt;wget https://download.splunk.com/products/splunk/releases/7.2.6/linux/splunk-7.2.6-c0bf0f679ce9-Linux-x86_64.tgz; } || yum -y install wget
[[ -f /usr/bin/gzip && -f /usr/bin/unzip ]] && tar zvxf splunk-7.2.6-c0bf0f679ce9-Linux-x86_64.tgz -C $1 || yum -y install gzip unzip

# add splunk excute file into environment 
cat <<EOF>> /etc/profile
export SPLUNK_HOME=$1/splunk
export PATH=\$SPLUNK_HOME/bin:\$PATH
EOF

echo "source /etc/profile" >> /root/.bashrc

# start splunk first time ,set administrator user and password automatically
[ -f /usr/bin/expect ] || yum -y install expect
/usr/bin/expect << EOF
set timeout 200
spawn $1/splunk/bin/splunk start --accept-license
expect "username"
send "$2\r"
expect "password"
send "$3\r"
expect "password"
send "$3\r"
set timeout 200
expect eof
exit
EOF
