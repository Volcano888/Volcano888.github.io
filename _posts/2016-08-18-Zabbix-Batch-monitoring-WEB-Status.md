---
layout: post
title: Zabbix监控WEB应用性能
description: "Zabbix监控WEB应用性能"
category: Zabbix
avatarimg: 
tags: [Zabbix]
duoshuo: true
---

## 1.介绍

使用zabbix_sender发送采集的WEB状态值，使用pycurl来采集WEB状态。

## 2.实现

Python脚本如下：


```
#!/usr/bin/env python
#coding=utf-8
import os
import sys
import fileinput
import pycurl
import logging

hostname = "linux-node2.example.com"
#IP from Zabbix Server or proxy where data should be send to.
zabbix_server = "192.168.xxx.xxx"
#zabbix_sender = "/usr/local/zabbix/bin/zabbix_sender"
zabbix_sender = "/usr/bin/zabbix_sender"
#If add url of website, please update list.
list = ['www.baidu.com','www.sina.com.cn']
#This list define zabbix key.
key = ['HTTP_ResSize','HTTP_ResTime','HTTP_ResCode','HTTP_ResSpeed']
#In the file to define the monitor host, key and value.
log_file = "/tmp/HTTP_Response.log"

logging.basicConfig(filename=log_file,level=logging.INFO,filemode='w')

run_cmd="%s -z %s -i %s > /tmp/HTTP_Response.temp" % (zabbix_sender,zabbix_server,log_file)
# print run_cmd

class Test():
        def __init__(self):
                self.contents = ''
        def body_callback(self,buf):
                self.contents = self.contents + buf

def Check_Http(URL):
        t = Test()
        #gzip_test = file("gzip_test.txt", 'w')
        c = pycurl.Curl()
        c.setopt(pycurl.WRITEFUNCTION,t.body_callback)
        #请求采用Gzip传输
        #c.setopt(pycurl.ENCODING, 'gzip')
        try:
            c.setopt(pycurl.CONNECTTIMEOUT, 60) #链接超时
            c.setopt(pycurl.URL,URL)
            c.perform() #执行上述访问网址的操作
        except pycurl.error:
            print "URL %s" % URL

        Http_Document_size = c.getinfo(c.SIZE_DOWNLOAD)
        # Http_Download_speed = round((c.getinfo(pycurl.SPEED_DOWNLOAD) /1024),2)
        Http_Download_speed = round((c.getinfo(pycurl.SPEED_DOWNLOAD) ),2)
        Http_Total_time = round((c.getinfo(pycurl.TOTAL_TIME) * 1000),2)
        Http_Response_code = c.getinfo(pycurl.HTTP_CODE)
        logging.info(hostname +' ' +key[0] + '[' + k + ']' + ' '+str(Http_Document_size))
        logging.info(hostname +' ' +key[1] + '[' + k + ']' + ' '+str(Http_Total_time))
        logging.info(hostname +' ' +key[2] + '[' + k + ']' + ' '+str(Http_Response_code))
        logging.info(hostname +' ' +key[3] + '[' + k + ']' + ' '+str(Http_Download_speed))


def runCmd(command):
    for u in list:
            URL = u
            global k
            if u.startswith('https:'):
                k = u.split('/')[2]
            else:
                k=u.split('/')[0]
                Check_Http(URL)

    for line in fileinput.input(log_file,inplace=1):
        print line.replace('INFO:root:',''),
    return os.system(command)
runCmd(run_cmd)
```

如果需要监控多个网站，修改list里的网站地址
添加计划任务,每5分钟采集一次
*/5 * * * * /home/check.py

检查zabbix_sender是否正常，可以使用下面命令


```
/usr/bin/zabbix_sender -z 192.168.10.126 -s "linux-node2.example.com" -k HTTP_ResCode[www.baidu.com] -o 200
```


## 3.Web端添加监控数值

监控key HTTP_ResTime[www.baidu.com]，HTTP_ResCode[www.baidu.com]，HTTP_ResSize[www.baidu.com]，HTTP_ResSpeed[www.baidu.com]分别表示HTTP的响应时间，状态吗，文档大小和下载速度。

![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/zabbixweb21.jpg)
![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/zabbixweb22.jpg)
![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/zabbixweb23.jpg)
![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/zabbixweb24.jpg)


## 4.REF
[参考1](http://www.zmzblog.com/2016/07/15/2016071514/)

