---
layout: post
title: Python学习 Day1
description: "Python学习 Day1"
category: Python
avatarimg: 
tags: [Python]
duoshuo: true
---

## Python学习 Day1

学习一天的资料记录


### 1.用户输入



```
#!/usr/bin/env python
#_*_coding:utf-8_*_
 
 
#name = raw_input("What is your name?") #only on python 2.x
name = input("What is your name?")
print("Hello " + name )

```

输入密码时，如果想要不可见，需要利用getpass 模块中的 getpass方法，即：


```
#!/usr/bin/env python
# -*- coding: utf-8 -*-
  
import getpass
  
# 将用户输入的内容赋值给 name 变量
pwd = getpass.getpass("请输入密码：")
  
# 打印输入的内容
print(pwd)

```


### 2.模块


sys模块


```
#!/usr/bin/env python
# -*- coding: utf-8 -*-
 
import sys
 
print(sys.argv)
 
 
#输出
$ python test.py helo world
['test.py', 'helo', 'world']  #把执行脚本时传递的参数获取到了

```

os模块


```
#!/usr/bin/env python
# -*- coding: utf-8 -*-
 
import os
 
os.system("df -h") #调用系统命令

```

tab补全模块


```
#!/usr/bin/env python 
# python startup file 
import sys
import readline
import rlcompleter
import atexit
import os
# tab completion 
readline.parse_and_bind('tab: complete')
# history file 
histfile = os.path.join(os.environ['HOME'], '.pythonhistory')
try:
    readline.read_history_file(histfile)
except IOError:
    pass
atexit.register(readline.write_history_file, histfile)
del os, histfile, readline, rlcompleter

for Linux
```

保存后使用


```
[root@centos6 ~]# python
Python 2.7.10 (default, Oct 23 2015, 18:05:06)
[GCC 4.2.1 Compatible Apple LLVM 7.0.0 (clang-700.0.59.5)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> import tab

```

你会发现，上面自己写的tab.py模块只能在当前目录下导入，如果想在系统的何何一个地方都使用怎么办呢？ 此时你就要把这个tab.py放到python全局环境变量目录里啦，基本一般都放在一个叫 Python/2.7/site-packages 目录下，这个目录在不同的OS里放的位置不一样，用 print(sys.path) 可以查看python环境变量列表。


### 3.数据类型


#### 数字

int（整型）

在32位机器上，整数的位数为32位，取值范围为-2**31～2**31-1，即-2147483648～2147483647

在64位系统上，整数的位数为64位，取值范围为-2**63～2**63-1，即-9223372036854775808～9223372036854775807

long（长整型）

跟C语言不同，Python的长整数没有指定位宽，即：Python没有限制长整数数值的大小，但实际上由于机器内存有限，我们使用的长整数数值不可能无限大。

　　
注意，自从Python2.2起，如果整数发生溢出，Python会自动将整数数据转换为长整数，所以如今在长整数数据后面不加字母L也不会导致严重后果了。

float（浮点型）

浮点数用来处理实数，即带有小数的数字。类似于C语言中的double类型，占8个字节（64位），其中52位表示底，11位表示指数，剩下的一位表示符号。


complex（复数）

复数由实数部分和虚数部分组成，一般形式为x＋yj，其中的x是复数的实数部分，y是复数的虚数部分，这里的x和y都是实数。
注：Python中存在小数字池：-5 ～ 257

#### 布尔值

真或假
1 或 0

#### 字符串

"hello world"

字符串格式化输出


```
name = "alex"
print "i am %s " % name
  
#输出: i am alex

```

PS: 字符串是 %s;整数 %d;浮点数%f

字符串常用功能：

- 移除空白
- 分割
- 长度
- 索引
- 切片

#### 列表

创建列表


```
name_list = ['alex', 'seven', 'eric']
或
name_list ＝ list(['alex', 'seven', 'eric'])
```


基本操作：

- 索引
- 切片
- 追加
- 删除
- 长度
- 切片
- 循环
- 包含

#### 元组(不可变列表)

创建元组


```
ages = (11, 22, 33, 44, 55)
或
ages = tuple((11, 22, 33, 44, 55))
```


#### 字典（无序）

创建字典


```
person = {"name": "mr.wu", 'age': 18}
或
person = dict({"name": "mr.wu", 'age': 18})
```

常用操作：

- 索引
- 新增
- 删除
- 键、值、键值对
- 循环
- 长度

### 4.数据运算

算数运算：

![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/python/python1.png)

比较运算：

![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/python/python2.png)

赋值运算：

![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/python/python3.png)

逻辑运算：

![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/python/python4.png)

成员运算：

![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/python/python5.png)

身份运算：

![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/python/python6.png)

位运算：

![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/python/python7.png)


```
#!/usr/bin/python
  
a = 60            # 60 = 0011 1100
b = 13            # 13 = 0000 1101
c = 0
  
c = a & b;        # 12 = 0000 1100
print "Line 1 - Value of c is ", c
  
c = a | b;        # 61 = 0011 1101
print "Line 2 - Value of c is ", c
  
c = a ^ b;        # 49 = 0011 0001
print "Line 3 - Value of c is ", c
  
c = ~a;           # -61 = 1100 0011
print "Line 4 - Value of c is ", c
  
c = a << 2;       # 240 = 1111 0000
print "Line 5 - Value of c is ", c
  
c = a >> 2;       # 15 = 0000 1111
print "Line 6 - Value of c is ", c
```

运算符优先级：

![image](https://raw.githubusercontent.com/Volcano888/Volcano888.github.io/master/images/python/python8.png)

[参考](http://www.runoob.com/python/python-operators.html)


### 5.表达式if...else

场景一、用户登陆验证


```
# 提示输入用户名和密码
  
# 验证用户名和密码
#     如果错误，则输出用户名或密码错误
#     如果成功，则输出 欢迎，XXX!
 
 
#!/usr/bin/env python
# -*- coding:utf-8-*- 
  
import getpass
  
  
name = raw_input('请输入用户名：')
pwd = getpass.getpass('请输入密码：')
  
if name == "alex" and pwd == "cmd":
    print("欢迎，alex！")
else:
    print("用户名和密码错误")
```

场景二、猜年龄游戏

在程序里设定好你的年龄，然后启动程序让用户猜测，用户输入后，根据他的输入提示用户输入的是否正确，如果错误，提示是猜大了还是小了

```
#!/usr/bin/env python
# -*- coding: utf-8 -*-
 
 
my_age = 28
 
user_input = int(input("input your guess num:"))
 
if user_input == my_age:
    print("Congratulations, you got it !")
elif user_input < my_age:
    print("Oops,think bigger!")
else:
    print("think smaller!")
```

### 6.表达式for loop

最简单的循环10次


```
#_*_coding:utf-8_*_
__author__ = 'Alex Li'
 
 
for i in range(10):
    print("loop:", i )

输出：

loop: 0
loop: 1
loop: 2
loop: 3
loop: 4
loop: 5
loop: 6
loop: 7
loop: 8
loop: 9
```


需求一：还是上面的程序，但是遇到小于5的循环次数就不走了，直接跳入下一次循环


```
for i in range(10):
    if i<5:
        continue #不往下走了,直接进入下一次loop
    print("loop:", i )
```

需求二：还是上面的程序，但是遇到大于5的循环次数就不走了，直接退出


```
for i in range(10):
    if i>5:
        break #不往下走了,直接跳出整个loop
    print("loop:", i )
```


### 7.while loop 

上面的代码循环100次就退出吧

```
count = 0
while True:
    print("test1",count)
    count +=1
    if count == 100:
        print("test2")
        break
```

回到上面for 循环的例子，如何实现让用户不断的猜年龄，但只给最多3次机会，再猜不对就退出程序。


```
#!/usr/bin/env python
# -*- coding: utf-8 -*-
 
 
my_age = 28
 
count = 0
while count < 3:
    user_input = int(input("input your guess num:"))
 
    if user_input == my_age:
        print("Congratulations, you got it !")
        break
    elif user_input < my_age:
        print("Oops,think bigger!")
    else:
        print("think smaller!")
    count += 1 #每次loop 计数器+1
else:
    print("猜这么多次都不对")
```
