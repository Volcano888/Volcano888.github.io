---
layout: post
title: Zabbbix 3.0 邮件告警配置实例
description: "Zabbbix 3.0 邮件告警配置实例"
category: Zabbix
avatarimg: 
tags: [Zabbix]
duoshuo: true
---

## Zabbbix3.0 告警的配置步骤
设置 1.Trigger ## 2. 配置用户 ## 3. 配置告警介质 ## 4. 设置 Action
如下介绍如何设置 Trigger

## 1.配置Trigger

定位到模板的 Trigger 入口

![image](https://raw.githubusercontent.com/Volcano888/Makedown-poto/master/mdphotos/Trigger1.png)

创建 Trigger

![image](https://raw.githubusercontent.com/Volcano888/Makedown-poto/master/mdphotos/Trigger2.png)

配置 Trigger

![image](https://raw.githubusercontent.com/Volcano888/Makedown-poto/master/mdphotos/Trigger3.png)

## 2.配置邮件告警介质

### 2.1 创建 Media
如下图示,创建媒介

![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/Media1.jpg)

填写邮件服务器信息：

![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/Media2.jpg)

### 2.2 创建并配置用户

创建用户：

![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/user1.jpg)

新建报警媒介：

![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/user2.jpg)

添加用户邮箱、告警时段、告警级别：

![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/user3.jpg)


## 3.创建 Actions

创建动作：

![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/action1.jpg)

动作的故障和恢复信息：

![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/action2.jpg)

动作的条件：

![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/action3.jpg)

动作的操作：

![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/action4.jpg)

操作的具体内容：
![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/Zabbix/action5.jpg)