---
title: Python合并多个excl表格
date: 2021-01-07 20:28:06
permalink: /pages/5428de/
categories:
  - 学习
  - Python
tags:
  - python
---

今天收到领导的一个需求：有一个rar压缩文件，文件里有许多个zip压缩包，每个包里有些个xlsx表格，现在需要提取并合并这些表到一张表里；下载下来解压一看，我去！ 上百张表手工一张张合并得啥时候去了。越优秀的程序员越会偷懒，重复次数大于三次以上，手工是不可能的手工的，summer记录一波骚操作！

<!-- more -->

## linux中预先处理

### 1.解压rar文件
::: details
```shell
[root@new1 test]# wget http://www.rarlab.com/rar/rarlinux-x64-5.3.0.tar.gz
--2021-01-07 20:45:04--  http://www.rarlab.com/rar/rarlinux-x64-5.3.0.tar.gz
正在解析主机 www.rarlab.com (www.rarlab.com)... 51.195.68.162
正在连接 www.rarlab.com (www.rarlab.com)|51.195.68.162|:80... 已连接。
已发出 HTTP 请求，正在等待回应... 301 Moved Permanently
位置：https://www.rarlab.com/rar/rarlinux-x64-5.3.0.tar.gz [跟随至新的 URL]
--2021-01-07 20:45:06--  https://www.rarlab.com/rar/rarlinux-x64-5.3.0.tar.gz
正在连接 www.rarlab.com (www.rarlab.com)|51.195.68.162|:443... 已连接。
已发出 HTTP 请求，正在等待回应... 200 OK
长度：1149037 (1.1M) [application/x-gzip]
正在保存至: “rarlinux-x64-5.3.0.tar.gz”

100%[===================================================================================>] 1,149,037   13.1KB/s 用时 74s    

2021-01-07 20:46:21 (15.1 KB/s) - 已保存 “rarlinux-x64-5.3.0.tar.gz” [1149037/1149037])

[root@new1 test]# ll
总用量 71748
-rw-r--r-- 1 root root 72318378 1月   7 16:05 31号应用文件.rar
-rw-r--r-- 1 root root  1149037 11月 18 2015 rarlinux-x64-5.3.0.tar.gz
[root@new1 test]# tar xvf rarlinux-x64-5.3.0.tar.gz
rar/
rar/order.htm
rar/acknow.txt
rar/readme.txt
rar/rar_static
rar/default.sfx
rar/license.txt
rar/rarfiles.lst
rar/whatsnew.txt
rar/makefile
rar/rar
rar/unrar
rar/rar.txt
[root@new1 test]# cd rar/
[root@new1 rar]# make
mkdir -p /usr/local/bin
mkdir -p /usr/local/lib
cp rar unrar /usr/local/bin
cp rarfiles.lst /etc
cp default.sfx /usr/local/lib
[root@new1 rar]# cd ..
[root@new1 test]# unrar e 31号应用文件.rar

UNRAR 5.30 freeware      Copyright (c) 1993-2015 Alexander Roshal


Extracting from 31号应用文件.rar

Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
Extracting  xxxx.zip   OK 
All OK
[root@new1 test]# 
```
:::

- 这里解压了rar包 出现了很多zip包，领导需要提取的excl表就在这些zip包里

### 2.解压若干zip包获取xlsx文件
```shell
[root@new1 test]# ls *.zip | xargs -n1 unzip -o ##解压当前所有后缀为zip的文件注：以覆盖方式解压，unzip后面接上-o
[root@new1 test]# mkdir all  ## 创建一个新的目录 存放提取的xlsx文件
[root@new1 test]# find ./ -name "*.xlsx" -exec cp {}  ./all \;  ## 查找当前目录下所有后缀为xlsx的文件 cp到all文件夹中
```
- 此时咱们就获取到了所有表格文件了


## 利用python合并表格

### 脚本内容如下

```python
import os
import os.path
import pandas as pd
import numpy as np
import xlwt
import xlrd
from xlutils.copy import copy
from datetime import date,datetime

df=pd.DataFrame({'序号一':[],
                 '序号二':[],
                 '序号三':[],
                 '序号四':[],
                 '序号五':[],
                 '序号六':[]})
print(df)
for filename in os.listdir(r'C:\Users\Administrator\Documents\WeChat Files\wxid_5ib04hwft67222\FileStorage\File\2021-01\31号应用文件\all'):
    filename=r"C:\Users\Administrator\Documents\WeChat Files\wxid_5ib04hwft67222\FileStorage\File\2021-01\31号应用文件\all"+"/" +filename
    data = pd.read_excel(filename)
    print(data)
    df=pd.concat([df,data])
    print(df)
    df = df.reset_index(drop=True)
df.to_excel('汇总.xlsx',encoding='utf-8')
```
- 最后生成汇总.xlsx文件，打开微调下格式即可

**今天summer不加班，下班愉快💨**