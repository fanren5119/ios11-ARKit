## 1.AR技术简介
    增强现实技术（Augmented Reality，简称AR），是一种实时地计算摄影机影像的位置及角度
    并加上相应图像、视频、3D模型的技术，这种技术的目标是在屏幕上把虚拟实际套在现实实际
    并进行互动;

## 2.ARKit概述及特点介绍
    ARKit是2017年6月6日，苹果发布iOS 11系统所新增框架，它能够帮助我们以最简单快捷的方
    式实现AR技术功能；
    ARKit框架提供了两种AR技术，一种是基于3D场景（SceneKit）实现的增强现实，一种是基于
    2D场景（SpriktKit）实现的增强现实；
    要想实现AR效果，必须依赖于苹果的游戏引擎框架（3D引擎SceneKit，2D引擎SpriktKit）；
    由于目前ARKit框架本身只包含相机追踪，不能直接加载物体模型，所以只能依赖于游戏引擎加
    载ARKit；
    ARKit虽然是iOS 11新出的框架，但是并不是所有的iOS 11系统都可以使用，而是必须是处理
    器是A9及以上的才能使用，而苹果从iphone6s开始使用A9处理器，也就说说iphone6及以前不
    能使用ARKit；

## 3.RKit与SceneKit关系
[arkit.png];  
    在一个完整的虚拟增强现实体验中，ARKit框架值负责将真实花名转变为一个3D场景，这一个转
    变的过程分为两个环节：由ARCamera负责捕捉摄像头花名，有ARSession负责搭建3D长江；将
    虚拟物体显示在3D长江中是由SceneKit框架来完成的，每一个虚拟的物体都一个节点SCNNode，
    每一个节点构成了一个场景SCNScene，无数个场景构成了3D世界；

## 4.ARKit工作原理
### 4.1 ARSCNView与ARSession
    ARSCNView与ARCamera二者之间并没有直接的关系，他们之间通过AR会话，也就是ARKit中非常
    重量级的一个类ARSession来搭建沟通桥梁的；
    要想运行一个ARSession会话，必须执行一个称之为会话追踪配置的对象：ARSessionCOnfiguration，
    它主要的目的就是负责追踪相机在2D世界中的位置以及一些特征场景的捕捉（例如平面捕捉）这
    个类本省比较简单但是作用巨大；
    ARSessionConfiguration是一个父类，为了更好的看到增强现实的效果，苹果建议我们使用子
    类ARWroldTrackingSessionConfiguration；

### 4.2RWorldTrackingSessionConfiguration与ARFrame
    ARSession搭建沟通桥梁的主要由两个ARWorldTrackingSessionConfiguration与ARFrame；
    其中ARWorldTrackingSessionConfiguration的作用是跟踪设备的方向和位置，以及检测设备
    摄像头看到的现实世界的表面；他的内部实现了一系列非常庞大的算法计算以及调用了iphone必
    要的传感器来检测手机的移动以及旋转甚至是翻滚；
    当ARWorldTrackingSessionConfiguration计算出相机在3D世界中的位置时，他本身并不持有
    这个位置数据，而是将其计算出的位置数据交个ARSession去管理，而相机对应的数据位置对应
    的类是ARFRame，其中ARSession类中有一个属性currentFrame，维护的就是ARFrame这个对象；
    
## 5.ARKit工作流程
    ①   ARSCNView加载场景SCNScene；
    ②	SCNScene启动相机ARCamera开始捕捉场景；
    ③	捕捉场景后ARSCNView开始讲场景数据交给Session；
    ④	Session通通过管理ARSessionConfiguration实现场景的追踪并且返回一个ARFrame；
    ⑤	给ARSCNView的scene添加一个子节点（3D物体模型）
