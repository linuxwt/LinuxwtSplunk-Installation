#!/bin/bash
######script for installing Splunk Enterprise 7.2.6#####################################
######you can definite username password  directory of Splunk installation by yourself######
######default dir user password are /opt wangteng wangteng123#######

# judge the user of the scipt
[ ${UID} -ne 0 ] && { echo "the script need root.";exit 1; }

# judge whether exist postion arguments $1
# if $1 is null,default /opt
splunk_dir=${1:-"/opt"}

# set user password of splunk
splunk_user=${2:-"wangteng"}
splunk_password=${3:-"wangteng123"}

# configure dir of splunk installation
[ -d ${splunk_dir} ] || mkdir -p ${splunk_dir}

# download binary package and extract file
[ -f /usr/bin/wget ] && { cd /opt;wget https://download.splunk.com/products/splunk/releases/7.2.6/linux/splunk-7.2.6-c0bf0f679ce9-Linux-x86_64.tgz; } || yum -y install wget
yum -y install gzip zip &&  tar zvxf splunk-7.2.6-c0bf0f679ce9-Linux-x86_64.tgz -C ${splunk_dir}

# add splunk excute file into environment 
cat <<EOF>> /etc/profile
export SPLUNK_HOME=${splunk_dir}/splunk
export PATH=\$SPLUNK_HOME/bin:\$PATH
EOF

echo "source /etc/profile" >> /root/.bashrc

# start splunk first time ,set administrator user and password automatically
[ -f /usr/bin/expect ] || yum -y install expect
/usr/bin/expect << EOF
set timeout 200
spawn ${splunk_dir}/splunk/bin/splunk start --accept-license
expect "username"
send "${splunk_user}\r"
expect "password"
send "${splunk_password}\r"
expect "password"
send "${splunk_password}\r"
set timeout 200
expect eof
exit
EOF
