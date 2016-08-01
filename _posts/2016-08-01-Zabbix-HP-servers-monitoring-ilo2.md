---
layout: post
title: Zabbix监控HP服务器IPMI配置二
description: "Zabbix监控HP服务器IPMI配置二"
category: Zabbix
avatarimg: 
tags: [Zabbix]
duoshuo: true
---

# Zabbix监控HP服务器IPMI配置二

## 1.安装freeipmi

下载地址:

```bash
wget http://ftp.gnu.org/gnu/freeipmi/freeipmi-1.2.1.tar.gz 
tar -xvzf freeipmi-1.2.1.tar.gz
cd freeipmi-1.2.1

X32:
./configure --prefix=/usr --exec-prefix=/usr --sysconfdir=/etc --localstatedir=/var --mandir=/usr/share/man

X64:
./configure --prefix=/usr --exec-prefix=/usr --sysconfdir=/etc --localstatedir=/var --mandir=/usr/share/man --libdir=/usr/lib64

make install
```

## 2.下载脚本和模板

[ilo_discovery.pl](https://github.com/Volcano888/Volcano888.github.io/blob/master/soft-conf/Zabbix/ilo_discovery.pl)

[ipmi_proliant.pl](https://github.com/Volcano888/Volcano888.github.io/blob/master/soft-conf/Zabbix/ipmi_proliant.pl)

[ipmi_script_iLO_discovery.xml](https://github.com/Volcano888/Volcano888.github.io/blob/master/soft-conf/Zabbix/ipmi_script_iLO_discovery.xml)

把脚本ilo_discovery.pl和ipmi_proliant.pl放到 "externalscripts"文件夹下，具体看zabbix_server.conf下的设置目录
默认路径是:/usr/lib/zabbix/externalscripts

ipmi_script_iLO_discovery.xml为模板，在zabbix界面导入

## 3.HP ILO配置
创建一个给zabbix用的账号，用于采集硬件的ipmi信息


## 4.创建主机和测试

使用以下命令测试，是否可以获取到硬件信息

```bash
检查freeipmi连接ilo
/usr/sbin/ipmi-sensors -D LAN2_0 -h 192.168.0.1 -u monitor -p P@$$w0rd -l USER -W discretereading --no-header-output --quiet-cache --sdr-cache-recreate --comma-separated-output --entity-sensor-names
```
效果图：
![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/zabbixipmi1.jpg)

脚本检查：

```bash
命令:
./ilo_discovery.pl xxx.xxx.xxx.xxx zabbix zabbix#ipmi sensor fan numeric
```

效果图：
![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/zabbixipmi2.jpg)

创建监控主机,因为是自定义监控，IPMI interface是不使用的

创建宏

{$ILO}   服务器IP
{$ILO_USER}  用户名
{$ILO_PASS}  密码

![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/zabbixipmi3.jpg)

添加导入的“Template IPMI Script iLO Discovery”模板


监控采集到数据如下：

![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/zabbixipmi4.jpg)



## 5.碰到的问题
报错
configure: error: libgcrypt required to build libfreeipmi


```
安装libgcrypt包
yum install install libgcrypt-devel -y

```

## 6.REF
[参考1](https://www.zabbix.com/forum/showthread.php?t=44968)