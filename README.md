# ChinaTownClient
使用unity3d xlua实现的桌游《唐人街》客户端

## 规则介绍
文字版：http://news.173zy.com/content/20110718/content-4936-1.html<br>
视频版：https://www.bilibili.com/video/av62419192/<br>

## 协议
与服务端相同，使用了protobuf2。而其对应的proto文件，可以在服务端获取<br>
https://github.com/DoreRandom/ChinaTownServer/tree/master/proto<br>

## Config
Assets/Scripts/GameConfig.cs:<br>
Url 资源地址<br>
Version 版本号<br>
AssetBundleOutputPath ab打包输出位置<br>

Assets/Lua/game/login/CLoginCtrl.lua:<br>
server 其中一个网关的ip,port<br>
## Server
https://github.com/DoreRandom/ChinaTownServer

## Demo
http://www.woodgame.top/client/商业街安装程序.exe

## 缺陷较多
本客户端实现较为简单，在众多方面存在问题，欢迎各位大佬给予指导。1767922548@qq.com