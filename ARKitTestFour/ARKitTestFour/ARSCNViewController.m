//
//  ARSCNViewController.m
//  ARKitTestFour
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
    if (self.planeNode != nil) {
        return;
    }
    SCNScene *scene = [SCNScene sceneNamed:@"Models.scnassets/ship.scn"];
    SCNNode *shipNode = scene.rootNode.childNodes[0];
    self.planeNode = shipNode;
    
    shipNode.scale = SCNVector3Make(0.5, 0.5, 0.5);
    shipNode.position = SCNVector3Make(0, -15, -15);
    //飞机的3D模型，可能有很多个子节点拼接，所以里面的子节点也要修改位置和大小，否则上面的修改会无效
    for (SCNNode *node in shipNode.childNodes) {
        node.scale = SCNVector3Make(0.5, 0.5, 0.5);
        node.position = SCNVector3Make(0, -15, -15);
    }
    [self.arscnView.scene.rootNode addChildNode:shipNode];
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
