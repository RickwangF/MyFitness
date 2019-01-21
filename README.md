# MyFitness

MyFitness是一款开源的运动健身App，它可以帮助你对运动进行记录，运动的方式有健走，跑步和骑行。

MyFitness会记录运动的时间，轨迹，速度，卡路里消耗量等信息。用户数据都保存在LeadCloud上。随时可以查看过去的里程和记录。MyFitness适配iPhoneX和iPhoneXs系列的全面屏手机，以下是iPhoneX iOS 12.1的App截图：

### 首页
在首页可以设置目标距离和时间，可以开启或关闭语音提示，可以选择运动的方式。

![image](http://lc-gytbbdn5.cn-n1.lcfile.com/752b585eeeb3acc144ca.jpg)
![image](http://lc-gytbbdn5.cn-n1.lcfile.com/6fef4e60357580f46c85.jpg)
![image](http://lc-gytbbdn5.cn-n1.lcfile.com/6c4f97047c8dadd05b2b.jpg)

首页的运行效果展示：

![image](http://lc-gytbbdn5.cn-n1.lcfile.com/12276b770c57dc103466.gif)

开始运动的效果展示：

![image](http://lc-gytbbdn5.cn-n1.lcfile.com/54f783458dc6cef4713c.gif)

### 里程

里程中详细展示了用户使用MyFitness进行运动的里程列表和运动轨迹。

![image](http://lc-gytbbdn5.cn-n1.lcfile.com/64c4927461ab82d5adea.jpg)
![image](http://lc-gytbbdn5.cn-n1.lcfile.com/2d2bd3de33ef199615bc.jpg)

### 记录

记录中展示了用户一段时间以来的运动的小记录。

![image](http://lc-gytbbdn5.cn-n1.lcfile.com/33f779f42ef36a369ef8.jpg)

### 计时器

计时器会记录用户的GPS轨迹和运动时间，速度并上传到LeanCloud。

![image](http://lc-gytbbdn5.cn-n1.lcfile.com/b7fbc90f6ed3aefb4f56.jpg)

### 登录和注册

没什么特别的，就是注册和登录。

![image](http://lc-gytbbdn5.cn-n1.lcfile.com/5ced1f461cdb7a7009a5.jpg)
![image](http://lc-gytbbdn5.cn-n1.lcfile.com/a341e85e93e52cce92d1.jpg)

### 个人中心

个人信息设置和关于我们功能还没有做。

![image](http://lc-gytbbdn5.cn-n1.lcfile.com/a961c60f47add5367d43.jpg)

### 合作

合作功能中展示了我的一些个人简介和App UI设计师的个人简介，还有一些有意思的东西。转场动画效果模仿AppStore。

### 系统要求
iOS9 - iOS12

Xcode10

### 安装
将项目Clone下来之后，因为项目中有使用百度语音合成的SDK，没有将该SDK的静态库文件上传到Github，需要手动下载并放置在项目的BDSClientLib文件夹下。

下载地址[：https://ai.baidu.com/sdk#tts/](https://ai.baidu.com/sdk#tts/)

存放目录截图：
![image](http://lc-gytbbdn5.cn-n1.lcfile.com/e9da7ec74f3ece1be00d.png)

重新编译即可运行。

### ToDoList

- 完成个人中心的个人资料和关于我们的功能
- 加入用户隐私协议
- 加入App设置，如语音播报设置，缓存大小控制等
- 迁移LeanCloud数据到阿里云服务器，编写服务端代码
- AppStore上架

### 问题反馈

欢迎大家Fork和Star这个项目，编写MyFitness不为了赚钱，只为了贡献给开源一份力量。

有问题直接在Issues中添加。




