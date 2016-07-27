---
layout: post
title: Zabbix告警升级机制
description: "Zabbix告警升级机制"
category: Zabbix
avatarimg: 
tags: [Zabbix]
duoshuo: true
---

# Zabbix告警升级机制

随着监控项目的增多,有一些警告性质的报警可能不许要让领导收到，如果监控项长时间处于一个反复报警的状态时，可能是没有人去解决 也可能是他们无法去解决的时候，再去向上级发送告警  那么zabbix就可以通过它的告警机制去实现 它可以通过自定义时间段，发送消息、命令 从而形成一个梯度的报警机制。通过下图解释梯度报警的设置方法.

## 例子一：

![image](https://raw.githubusercontent.com/Volcano888/Makedown-poto/master/mdphotos/zaction1.jpg)

Default operation step duration:默认单步骤操作持续时间 最低是60秒

以上告警有两个等级梯度：设置的3600，间隔为1小时

第一梯度：第1、2 步发送告警给Admin用户 间隔时间是1小时，发送两次 直到故障恢复


第二梯度 :2小时后，第3、4、5步发送邮件给Guests用户，间隔时间是1小时,发送三次 直到故障恢复


## 例子二：

![image](https://raw.githubusercontent.com/Volcano888/Makedown-poto/master/mdphotos/zactions2.jpg)

Admin用户每隔1小时发送一次报警直到故障恢复，
用户Guests在故障后的3小时后，每隔120秒发送一次告警 共计发送3次