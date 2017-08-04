//
//  ARSCNViewController.m
//  ARKitTestFive
//
//  Created by 王磊 on 2017/8/4.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "ARSCNViewController.h"
#import <ARKit/ARKit.h>
#import <SceneKit/SceneKit.h>

@interface ARSCNViewController () <ARSessionDelegate>

@property (nonatomic, strong) ARSCNView *arscnView;
@property (nonatomic, strong) ARSession *session;
@property (nonatomic, strong) ARWorldTrackingSessionConfiguration *configuraton;
@property (nonatomic, strong) SCNNode *planeNode;


@end

@implementation ARSCNViewController

- (ARSCNView *)arscnView
{
    if (_arscnView != nil) {
        return _arscnView;
    }
    _arscnView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
    _arscnView.session = self.session;
    return _arscnView;
}

- (ARSession *)session
{
    if (_session != nil) {
        return _session;
    }
    _session = [[ARSession alloc] init];
    _session.delegate = self;
    return _session;
}

- (ARWorldTrackingSessionConfiguration *)configuraton
{
    if (_configuraton != nil) {
        return _configuraton;
    }
    _configuraton = [[ARWorldTrackingSessionConfiguration alloc] init];
    _configuraton.planeDetection = ARPlaneDetectionHorizontal;
    _configuraton.lightEstimationEnabled = YES;
    return _configuraton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view addSubview:self.arscnView];
    [self.session runWithConfiguration:self.configuraton];
}

#pragma -mark sessionDelegate

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame
{
    //相机移动时调用
    if (self.planeNode) {
        //捕捉到相机的位置，让节点随着相机移动而移动
        //根据官方文档，相机的位置参数在4*4矩阵的第三列
        self.planeNode.position = SCNVector3Make(frame.camera.transform.columns[3].x,frame.camera.transform.columns[3].y,frame.camera.transform.columns[3].z);
    }
}

#pragma -mark touch 添加飞机

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.planeNode removeFromParentNode];
    
    //1.使用场景加载scn文件（scn格式文件是一个基于3D建模的文件，使用3DMax软件可以创建，这里系统有一个默认的3D飞机）--------在右侧我添加了许多3D模型，只需要替换文件名即可
    SCNScene *scene = [SCNScene sceneNamed:@"Models.scnassets/lamp/lamp.scn"];
    //2.获取台灯节点（一个场景会有多个节点，此处我们只写，飞机节点则默认是场景子节点的第一个）
    //所有的场景有且只有一个根节点，其他所有节点都是根节点的子节点
    
    SCNNode *shipNode = scene.rootNode.childNodes[0];
    
    self.planeNode = shipNode;
    
    //台灯比较大，适当缩放一下并且调整位置让其在屏幕中间
    shipNode.scale = SCNVector3Make(0.5, 0.5, 0.5);
    shipNode.position = SCNVector3Make(0, -15,-15);
    ;
    //一个台灯的3D建模不是一气呵成的，可能会有很多个子节点拼接，所以里面的子节点也要一起改，否则上面的修改会无效
    for (SCNNode *node in shipNode.childNodes) {
        node.scale = SCNVector3Make(0.5, 0.5, 0.5);
        node.position = SCNVector3Make(0, -15,-15);
        
    }
    
    
    self.planeNode.position = SCNVector3Make(0, 0, -20);
    
    //3.绕相机旋转
    //绕相机旋转的关键点在于：在相机的位置创建一个空节点，然后将台灯添加到这个空节点，最后让这个空节点自身旋转，就可以实现台灯围绕相机旋转
    //1.为什么要在相机的位置创建一个空节点呢？因为你不可能让相机也旋转
    //2.为什么不直接让台灯旋转呢？ 这样的话只能实现台灯的自转，而不能实现公转
    SCNNode *node1 = [[SCNNode alloc] init];
    
    //空节点位置与相机节点位置一致
    node1.position = self.arscnView.scene.rootNode.position;
    
    //将空节点添加到相机的根节点
    [self.arscnView.scene.rootNode addChildNode:node1];
    
    
    // !!!将台灯节点作为空节点的子节点，如果不这样，那么你将看到的是台灯自己在转，而不是围着你转
    [node1 addChildNode:self.planeNode];
    
    
    //旋转核心动画
    CABasicAnimation *moonRotationAnimation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    
    //旋转周期
    moonRotationAnimation.duration = 30;
    
    //围绕Y轴旋转360度  （不明白ARKit坐标系的可以看笔者之前的文章）
    moonRotationAnimation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    //无限旋转  重复次数为无穷大
    moonRotationAnimation.repeatCount = FLT_MAX;
    
    //开始旋转  ！！！：切记这里是让空节点旋转，而不是台灯节点。  理由同上
    [node1 addAnimation:moonRotationAnimation forKey:@"moon rotation around earth"];
    
    
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
