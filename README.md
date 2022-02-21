# Synergy破解版

由于经常会在办公室同时使用笔记本和办公台式机电脑，频繁切换显示器和键盘鼠标体验不是太好，因此找到了synergy这个工具，但是发现要钱，于是呼就尝试看有没有免费版本，网上有人推荐了github开源的synergy-core，我尝试编译通过后发现居然还要花钱买序列号，不能忍。。。继续找免费的，嗯，找到了，但是人家是在ubuntu-18.04上编译的，20.04上要装qt4的依赖但是我gpg过不去很麻烦，就整了个绿色安装版本，顺便整了个开机启动服务的脚本，爽歪歪。。。

由于里面有一些坑还真怕回头不用给忘记了，这里进行使用说明。。。


## 服务端 （你想使用的键鼠连接在的电脑，一般为台式机）

1. 首先使用脚本打开服务端界面：

```
bash synergy_service.sh start
```

2. 点击菜单Edit，将Use SSL encryption给去掉，不去掉鼠标键盘各种抖。。。

3. 选择Server， Configure interatively, 在里面添加一个屏幕，名字修改为想要添加电脑的hostname, 名字是定义电脑身份的id，很重要

4. 点击Apply，Start即可启动功能

5. 开机自启： 

```
bash synergy_service.sh start_service
```


## 客户端 （想被远程控制键鼠的电脑）

1. 修改synergy_service.sh脚本中的start函数，注释server，启用client并修改ip

```
start() # Start the service
{
 export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)
 # ./synergy # server
 ./synergyc 192.168.1.191 # client, please change to the server ip
}
```

2. 开机自启

```
bash synergy_service.sh start_service
```

## systemd服务状态查看

如果开机自启出现问题啥的，可以查看服务状态：

```
systemctl status synergy
```

查看log：

```
journalctl -u synergy
```

## 关闭开机自启服务

使用systemd关闭服务即可


```
systemctl disable synergy
```
