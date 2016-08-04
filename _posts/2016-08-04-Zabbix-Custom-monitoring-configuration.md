---
layout: post
title: Zabbix3.0 自定义监控项目配置
description: "Zabbix3.0 自定义监控项目配置"
category: Zabbix
avatarimg: 
tags: [Zabbix]
duoshuo: true
---

使用自定义监控项，添加自定义的监控项目。以添加监控Nginx Status为例子：

### 1、配置 Nginx 开启 nginx status
Nginx 配置文件中增加如下配置：

```
location /nginx-status {
	stub_status on;
	access_log   off;
	allow 127.0.0.1;
	allow 192.168.10.0/24;
	deny all;
}	
```

### 2、配置 nginx status 监控脚本


下载后根据自己的情况修改 nginx status 的 URL(Port/PATH)

测试脚本能正常获取数据
[nginx_status](https://github.com/itnihao/zabbix-book/blob/master/11-chapter/nginx_monitor/scripts/nginx_status)


```
#!/bin/bash

# function:monitor nginx  from zabbix
# License: GPL
# mail:admin@itnihao.com
# version 1.0 date:2012-12-09
# version 1.0 date:2013-01-15
# version 1.1 date:2014-09-05


#nginx.conf
######################################################################
#   server {
#        listen 127.0.0.1:80;
#        server_name 127.0.0.1;
#        location /nginxstatus {
#                 stub_status on;
#                 access_log off;
#                 allow 127.0.0.1;
#                 allow 192.168.10.0/24;
#                 deny all;        
#        }
#        location ~ ^/(phpfpmstatus)$ {
#                 include fastcgi_params;
#                 fastcgi_pass unix:/tmp/fpm.sock;
#                 fastcgi_param SCRIPT_FILENAME $fastcgi_script_name;
#        }
#    }
######################################################################


source /etc/bashrc >/dev/null 2>&1
source /etc/profile  >/dev/null 2>&1
nginxstatus=http://127.0.0.1/nginxstatus


# Functions to return nginx stats
function checkavailable {
    code=$(curl -o /dev/null -s -w %{http_code} ${nginxstatus})
    if [ "${code}" == "200" ]
    then
        return 1
    else
        echo  0
    fi
}
function active {
    checkavailable|| curl -s "${nginxstatus}" | grep 'Active' | awk '{print $3}'
}
function reading {
    checkavailable|| curl -s "${nginxstatus}" | grep 'Reading' | awk '{print $2}'
}
function writing {
    checkavailable|| curl -s "${nginxstatus}" | grep 'Writing' | awk '{print $4}'
}
function waiting {
    checkavailable|| curl -s "${nginxstatus}" | grep 'Waiting' | awk '{print $6}'
}
function accepts {
    checkavailable|| curl -s "${nginxstatus}" | awk NR==3 | awk '{print $1}'
}
function handled {
    checkavailable|| curl -s "${nginxstatus}" | awk NR==3 | awk '{print $2}'
}
function requests {
    checkavailable|| curl -s "${nginxstatus}" | awk NR==3 | awk '{print $3}'
}



case "$1" in
    nginx_site_dicovery)
        nginx_site_dicovery
        ;;
    active)
        active
        ;;
    reading)
        reading
        ;;
    writing)
        writing
        ;;
    waiting)
        waiting
        ;;
    accepts)
        accepts
        ;;
    handled)
        handled
        ;;
    requests)
        requests
        ;;
    *)
        echo "Usage: $0 {active |reading |writing |waiting |accepts |handled |requests }"
esac
```

### 3、增加 Zabbix 自定义监控项目的配置文件
配置文件一般放在/etc/zabbix/zabbix_agentd.d/下， 参考配置文件地址：
[userparameter_nginx.conf](https://github.com/itnihao/zabbix-book/blob/master/11-chapter/nginx_monitor/zabbix_agentd.d/userparameter_nginx.conf)

```
UserParameter=nginx.accepts,/etc/zabbix/scripts/nginx_status accepts
UserParameter=nginx.handled,/etc/zabbix/scripts/nginx_status handled
UserParameter=nginx.requests,/etc/zabbix/scripts/nginx_status requests
UserParameter=nginx.connections.active,/etc/zabbix/scripts/nginx_status active 
UserParameter=nginx.connections.reading,/etc/zabbix/scripts/nginx_status reading
UserParameter=nginx.connections.writing,/etc/zabbix/scripts/nginx_status writing
UserParameter=nginx.connections.waiting,/etc/zabbix/scripts/nginx_status waiting
```

添加配置文件后，重启 Zabbix Agent，然后使用 zabbix_get 测试是否能获取数据，比如：


```
[root@linux-node1 ~]# zabbix_get -s 192.168.10.123 -p 10050 -k "nginx.active"
1
[root@linux-node1 ~]# zabbix_get -s 192.168.10.123 -p 10050 -k "nginx.accepts"
2246493
```

在Zabbix Web添加自定义监控项。
