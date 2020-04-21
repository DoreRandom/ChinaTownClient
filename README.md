# ChinaTownClient
使用unity3d xlua实现的桌游《唐人街》客户端

## 规则介绍
文字版：http://news.173zy.com/content/20110718/content-4936-1.html<br>
视频版：https://www.bilibili.com/video/av62419192/<br>

## 协议
与服务端相同，使用了protobuf2。而其对应的proto文件，可以在服务端获取<br>
https://github.com/DoreRandom/ChinaTownServer/tree/master/proto<br>

## Config
Assets/Scripts/GameConfig.cs:
Url 资源地址
Version 版本号
AssetBundleOutputPath ab打包输出位置

Assets/Lua/game/login/CLoginCtrl.lua:
server 其中一个网关的ip,port
## Server
https://github.com/DoreRandom/ChinaTownServer