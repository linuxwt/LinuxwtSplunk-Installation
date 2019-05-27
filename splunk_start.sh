#!/bin/bash
# description: splunk start script
# chkconfig: 2345 10 90 
[ -f /etc/init.d/functions ] &&  . /etc/init.d/functions || exit 1  
[ -f /usr/bin/lsof ] || yum -y install lsof  
start () {
    [ $(lsof -i:8089 | wc -l) -gt 0 ] && action "splunk start ..."  /bin/true || /opt/splunk/bin/splunk start
    sleep 10
    [ $(lsof -i:8089 | wc -l) -gt 0 ] && action "splunk start ..."  /bin/true
    return $RETVAL
}
stop () {
    [ $(lsof -i:8089 | wc -l) -eq 0 ] && action "rsyncd is not running..." /bin/true || /opt/splunk/bin/splunk stop
    sleep 10
    [ $(lsof -i:8089 | wc -l) -eq 0 ] && action "rsyncd is not running..." /bin/true
    return $RETVAL
}
main () {
    case $1 in
    start|START)
          start
           ;;
    stop|STOP)
          stop
           ;;
    restart|RESTART)
          stop
          sleep 10
          start
           ;;
    *)
           echo -e "Usage: $0 {start|stop|restart}"
           exit 1
           ;;
    esac
}
main $1
exit $RETVAL
