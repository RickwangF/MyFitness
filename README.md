# MyFitness

MyFitness是一款开源的运动健身App，它可以帮助你对运动进行记录，运动的方式有健走，跑步和骑行。

MyFitness会记录运动的时间，轨迹，速度，卡路里消耗量等信息。用户数据都保存在LeadCloud上。随时可以查看过去的里程和记录。MyFitness适配iPhoneX和iPhoneXs系列的全面屏手机，以下是iPhoneX iOS 12.1的App截图：

### 首页
在首页可以设置目标距离和时间，可以开启或关闭语音提示，可以选择运动的方式。

<table>
<tr>
<td><img style="width:500px;" src="http://lc-gytbbdn5.cn-n1.lcfile.com/49f3dc461c9489b6f4f4.png" /></td>
<td><img style="width:500px;" src="http://lc-gytbbdn5.cn-n1.lcfile.com/b64fecdeb13577b7167b.png" /></td>
</tr>
<tr>
<td><img style="width:500px;" src="http://lc-gytbbdn5.cn-n1.lcfile.com/61f27841d186e2affba9.png" /></td>
<td><img style="width:500px;" src="http://lc-gytbbdn5.cn-n1.lcfile.com/b0104db18b973c83ed5e.png" /></td>
</tr>
</table>

### 里程

里程中详细展示了用户使用MyFitness进行运动的里程列表和运动轨迹。

<table>
<tr>
<td><img style="width:500px;" src="http://lc-gytbbdn5.cn-n1.lcfile.com/0a71d192d37d67d3186f.png" /></td>
<td><img style="width:500px;" src="http://lc-gytbbdn5.cn-n1.lcfile.com/af8dddade606fc738d39.png" /></td>
</tr>
</table>

### 记录

记录中展示了用户一段时间以来的运动的小记录。

<table>
<tr>
<td><img style="width:500px;" src="http://lc-gytbbdn5.cn-n1.lcfile.com/9904ca1d9d84401c6569.png" /></td>
<td><img style="width:500px;" src="http://lc-gytbbdn5.cn-n1.lcfile.com/41b2ad877943ee400646.png" /></td>
</tr>
</table>

### 计时器

计时器会记录用户的GPS轨迹，运动时间，运动速度并上传到服务器，如果开启语音提示，还会根据设置的距离和时间进行j语音提示，每公里都会进行提示。

<table>
<tr>
<td><img style="width:500px;" src="http://lc-gytbbdn5.cn-n1.lcfile.com/ad039b11dcf51a9a565f.png" /></td>
<td><img style="width:500px;" src="http://lc-gytbbdn5.cn-n1.lcfile.com/24ac91fb74515a09d106.png" /></td>
</tr>
</table>

### 登录和注册

没什么特别的，就是注册和登录。

<table>
<tr>
<td><img style="width:500px;" src="http://lc-gytbbdn5.cn-n1.lcfile.com/dddada9d5f83b2236189.png" /></td>
<td><img style="width:500px;" src="http://lc-gytbbdn5.cn-n1.lcfile.com/1bfc01be24ce61a4e822.png" /></td>
</tr>
</table>

### 个人中心

个人信息设置和关于我们功能还没有做。

<table>
<tr>
<td>
<img src="http://lc-gytbbdn5.cn-n1.lcfile.com/4501156ab2acb5648a61.png"" style="width:500px;" />
</td>
<td>
<img src="http://lc-gytbbdn5.cn-n1.lcfile.com/6fdefe0f9a7f68c0b7cf.png" style="width:500px;" />
</td>
</tr>
</table>


### 合作

合作功能中展示了我的一些个人简介和App UI设计师的个人简介，还有一些有意思的东西。转场动画效果模仿AppStore。

<table>
<tr>
<td><img style="width:500px;" src="http://lc-gytbbdn5.cn-n1.lcfile.com/b9e7b493597d20b02150.png" /></td>
<td><img style="width:500px;" src="http://lc-gytbbdn5.cn-n1.lcfile.com/7c58653ee9fed3798220.png" /></td>
</tr>
</table>

以上展示了所有MyFitness现在完成的功能，App的基本功能已经全部完成，可以下载测试使用。

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




