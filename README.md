# WDSwiftComponent
####1、基于rxswift的封装常用组件
####2、使用carthage管理第三方框架，不同于cocoapods
-**安装Carthage**

打开终端输入

`$ brew update`

`$ brew install carthage`

或者网站`https://github.com/Carthage/Carthage/releases`下载Carthage.pkg

安装完成后终端输入

`$ carthage version`

看到版本号就是安装成功

-**安装项目依赖的Carthage文件**

进入项目根目录执行

`$ open Carthage`

-**创建编辑Cartfile**

①、终端进入项目所在的根目录

`$ cd ~/Path/Project`

②、创建空的carthage文件

`$ touch Cartfile`

③、终端进入vim编辑Cartfile

`$ vim Cartfile `

④、添加需要的依赖文件

vim输入i进入编辑模式，添加例如：

`github "Alamofire/Alamofire" ~> 3.0`

指定Alamofire框架，版本为3.0
