#!/bin/bash
#######remote auto install Splunk Enterprise7.2.6###########
######ip.txt storage remote server ip address and root password########
#####default Splunk dir "/data"  user "wangshan" password "wangshan123"#######
#####splunk_install.sh is local script#################

remotesh () {
[[ -f /usr/bin/expect && -f /usr/bin/scp ]] || yum -y install lrzsz expect
/usr/bin/expect << EOF
set timeout 200
spawn scp splunk_install.sh ${ip}:/root
expect "password"
send "${passwd}\r"
set timeout 200
expect eof
exit
EOF

/usr/bin/expect << EOF
set timeout 200
spawn ssh ${ip} -o StrictHostKeyChecking=no /root/splunk_install.sh /data wangshan wangshan123
expect "password"
send "${passwd}\r"
set timeout 200
expect eof
exit
EOF
}

while read ip passwd
do
    remotesh
done < ip.txt
