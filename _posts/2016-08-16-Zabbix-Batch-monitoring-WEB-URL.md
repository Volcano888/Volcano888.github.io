---
layout: post
title: 批量监控WEB地址
description: "批量监控WEB地址"
category: Zabbix
avatarimg: 
tags: [Zabbix]
duoshuo: true
---
## zabbix_agent配置

zabbix_agentd.conf设置
```
[root@zabbix3 externalscripts]# cat /etc/zabbix/zabbix_agentd.conf |grep ^[a-Z]
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Server=127.0.0.1
ServerActive=127.0.0.1
Hostname=Zabbix server
Include=/etc/zabbix/zabbix_agentd.d/*.conf
```

## Low level discovery 自动发现脚本

web_site_code_status脚本代码如下：

```
#!/bin/bash
source /etc/bashrc > /dev/null 2>&1
source /etc/profile > /dev/null 2>&1

#/usr/bin/curl -o /dev/null -s -w %{http_code} http://$1/

Web_SITE_discovery () {
	Web_SITE=($(cat /usr/lib/zabbix/externalscripts/Web.txt|grep -v "^#"))
	printf '{\n'
	printf '\t"data":[\n'
	for((i=0;i<${#Web_SITE[@]};++i))
	{
		num=$(echo $((${#Web_SITE[@]}-1)))
		if [ "$i" != ${num} ];
		then
			printf "\t\t{ \n"
			printf "\t\t\t\"{#SITENAME}\":\"${Web_SITE[$i]}\"},\n"
		else
			printf "\t\t{ \n"
			printf "\t\t\t\"{#SITENAME}\":\"${Web_SITE[$num]}\"}]}\n"
		fi
		}
	}
	web_site_code () {
		/usr/bin/curl -o /dev/null -s -w %{http_code} http://$1
	}
	case "$1" in
	web_site_discovery)
		Web_SITE_discovery
	;;
	web_site_code)
		web_site_code $2
	;;
	*)
	echo "Usage:$0 {Web_SITE_discovery|web_site_code [URL]}"
	;;
	esac
```

## 使用

运行脚本，输出格式如下


```
[root@zabbix3 zabbix_agentd.d]# /usr/lib/zabbix/externalscripts/web_site_code_status web_site_discovery
{
        "data":[
                { 
                        "{#SITENAME}":"www.9air.com"},
                { 
                        "{#SITENAME}":"www.juneyao.com"},
                { 
                        "{#SITENAME}":"oa.juneyao.net"}]}
```

## 在agent.conf里添加KEY

KEY信息如下：

```
[root@zabbix3 zabbix_agentd.d]# more web_site_discovery.conf 
UserParameter=web.site.discovery,/usr/lib/zabbix/externalscripts/web_site_code_status web_site_discovery
UserParameter=web.site.code[*],/usr/lib/zabbix/externalscripts/web_site_code_status web_site_code $1
```

使用zabbix_get测试


```
[root@zabbix3 zabbix_agentd.d]# zabbix_get -s 127.0.0.1 -k web_site_discovery
{
        "data":[
                { 
                        "{#SITENAME}":"www.9air.com"},
                { 
                        "{#SITENAME}":"www.juneyao.com"},
                { 
                        "{#SITENAME}":"oa.juneyao.net"}]}
```

再去Web管理端添加自动发现规则
![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/zabbixweb1.jpg)
![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/zabbixweb2.jpg)
![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/zabbixweb3.jpg)
![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/zabbixweb4.jpg)
![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/zabbixweb5.jpg)


## REF
参考《Zabbix企业级分布式监控系统》