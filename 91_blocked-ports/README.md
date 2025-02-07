# Extra Materials

In this lab you will learn how to get rid of an application blocking a specific port.

## Blocked Ports

```bash
# get process blocking the port
netstat -tulpan | grep 8088
ps aux | grep -i openlitespeed

# get & disable service
systemctl list-units | grep -i lshttpd
systemctl stop lshttpd
systemctl disable lshttpd
systemctl status lshttpd

# verify
netstat -tulpan | grep 8088

# get & remove package
apt list | grep -i openlitespeed
apt remove openlitespeed -y
```
