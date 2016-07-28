---
layout: post
title: Zabbix监控HP服务器IPMI配置
description: "Zabbix监控HP服务器IPMI配置"
category: Zabbix
avatarimg: 
tags: [Zabbix]
duoshuo: true
---
# Zabbix监控HP服务器IPMI配置

## 1.HP ILO设置
1.首选给HP ILO设置IP和创建用户（测试下来，只有administrator用户才能获取ipmi数据）

## 2.Zabbix设置

修改zabbix.conf文件


```
[root@zabbix3 ~]# cat /etc/zabbix/zabbix_server.conf |grep StartIPMIPollers
### Option: StartIPMIPollers
StartIPMIPollers=3

```

使用以下二个zabbix模板文件，导入到zabbix中

[IPMI_HP380G7.xml](https://github.com/Volcano888/Volcano888.github.io/blob/master/soft-conf/Zabbix/IPMI_HP380G7.xml) 

[IPMI_HP380G7.xml](https://github.com/Volcano888/Volcano888.github.io/blob/master/soft-conf/Zabbix/IPMI_HP380G8.xml) 

创建主机，使用IPMI接口
![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/zipmi1.jpg)
链接刚导入的模板
![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/zipmi2.jpg)
填写IPMI的验证信息：测试下来ILO3,认证算法可以默认，ILO4认证算法需要MD5
![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/zipmi3.jpg)
获取的数据如下
![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/zipmi4.jpg)



## 3.碰到的问题
如果想验证账号和测试ilo的联通性，可以使用ipmitool来测试
ipmitool -I lanplus -H xxx.xxx.xxxx.xxx -U admin  sdr
ipmitool -I lanplus -H xxx.xxx.xxxx.xxx -U admin -P 123456 power status

实际使用，发现zabbix使用这个方式，发现获取的数据不是你想要的。
后续再研究看看。


## 4.Ref

准备使用这个方式看看
https://www.zabbix.com/forum/showthread.php?t=44968