---
layout: post
title: PIWIK安装实践用
description: "PIWIK安装实践"
category: Monitor
avatarimg: 
tags: [Monitor,Web,Piwik]
duoshuo: true
---

## 1.Piwik介绍

Piwik是一个PHP和MySQL的开放源代码的Web统计软件，它给你一些关于你的网站的实用统计报告，比如网页浏览人数，访问最多的页面，搜索引擎关键词等等。

Piwik拥有众多不同功能的插件，你可以添加新的功能或是移除你不需要的功能，Piwik同样可以安装在你的服务器上面，数据就保存在你自己的服务器上面。你可以非常容易的插入统计图表到你的博客或是网站亦或是后台的控制面板中。安装完成后，你只需将一小段代码放到将要统计的网页中即可。

## 2.Piwik概况

Piwik支持插件，你可以通过插件扩展Piwik的功能，或者去掉一些不需要的功能。用户的界面支持Ajax技术是可定制的，你可以轻松拖放控件，定制自己需要的报告。

使用者独立拥有自己的统计数据，而不是寄存在服务商那里，这样就可以更灵活的使用统计数据，不用担心数据丢失问题。


Piwik是安装在服务器端的统计工具，安装过程很简单，但是需要服务器支持PHP5.1和MySQL。安装的时候上传Piwik到服务器端，然后打开浏览器，Piwik会自动运行安装，整个过程不超过5分钟。目前Piwik已支持中文。

## 3.安装环境

操作系统：centos 7


```

LAMP环境安装：


报错
[root@jypiwik html]# tail -f /var/log/nginx/piwik_error.log 
2016/08/25 15:20:51 [error] 11087#11087: *1 FastCGI sent in stderr: "Primary script unknown" while reading response header from upstream, client: 192.168.10.110, server: localhost, request: "GET /piwik/ HTTP/1.1", upstream: "fastcgi://127.0.0.1:9000", host: "192.168.10.137"

修改nginx配置文件
fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
修改为
fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;


mbstring需求
安装yum install php-mbstring 
在/etc/php.ini修改参数
重启服务


安装gd
yum install php-gd
yum install php-dom


PIWIK包下载：
wget http://builds.piwik.org/piwik.zip 

解压piwik
unzip piwik.zip 

添加权限
chown -R apache.apache /var/www/html/piwik 
chmod 0755 /var/www/html/piwik/tmp/    

移动piwik里面所有到/var/ww/html/目录下
mv piwik/* .

启动mysql
/etc/init.d/mysqld start

启动apache
/etc/init.d/httpd start 

设置mysql登录root密码
mysqladmin -uroot password '123456' 

创建piwik数据库
mysql> create database piwik;  

授权piwik用户管理piwik数据库
mysql> grant all on piwik.* to piwik@localhost identified by '123456';  

刷新权限
mysql> flush privileges;  
```



## 4.配置piwik

访问 Piwik 的 URL

