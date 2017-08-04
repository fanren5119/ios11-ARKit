//
//  ARSCNViewController.m
//  ARKitTestThree
//
//  Created by 王磊 on 2017/8/3.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "ARSCNViewController.h"
#import <ARKit/ARKit.h>
#import <SceneKit/SceneKit.h>

@interface ARSCNViewController () <ARSCNViewDelegate, ARSessionDelegate>

@property (nonatomic, strong) ARSCNView *scnView;
@property (nonatomic, strong) ARSession *session;
@property (nonatomic, strong) ARWorldTrackingSessionConfiguration *configuration;
@property (nonatomic, strong) SCNNode *planeNode;

@end

@implementation ARSCNViewController

- (ARSCNView *)scnView
{
    if (_scnView != nil) {
        return _scnView;
    }
    _scnView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
    _scnView.delegate = self;
    _scnView.session = self.session;
    _scnView.automaticallyUpdatesLighting = YES;
    return _scnView;
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

- (ARWorldTrackingSessionConfiguration *)configuration
{
    if (_configuration != nil) {
        return _configuration;
    }
    _configuration = [[ARWorldTrackingSessionConfiguration alloc] init];
    _configuration.planeDetection = ARPlaneDetectionHorizontal;
    _configuration.lightEstimationEnabled = YES;
    return _configuration;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view addSubview:self.scnView];
    [self.session runWithConfiguration:self.configuration];
}


#pragma -mark SCNView Delegate

- (void)renderer:(id <SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor;
{
    if ([anchor isMemberOfClass:[ARPlaneAnchor class]]) {
        NSLog(@"捕捉到平地");
        //1.获取捕捉到的平地锚点
        ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
        
        //创建一个3D物体模型，（系统捕捉到的平地是一个不规则的长方形，这里将其变成了长方形，并且对平地做了缩放）
        SCNBox *plane = [SCNBox boxWithWidth:planeAnchor.extent.x*0.3 height:0 length:planeAnchor.extent.x*0.3 chamferRadius:0];
        //使用Material渲染3D模型，（默认白色）
        plane.firstMaterial.diffuse.contents = [UIColor redColor];
        
        //创建一个基于3D模型的节点
        SCNNode *planeNode = [SCNNode nodeWithGeometry:plane];
        
        //设置节点的位置为捕捉的平地的锚点的中心位置，
        planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
        [node addChildNode:planeNode];
        
        //捕捉到平地之后，2s之后在平地上添加一个3D模型
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            SCNScene *scene = [SCNScene sceneNamed:@"Models.scnassets/vase/vase.scn"];
            SCNNode *vasenode = scene.rootNode.childNodes[0];
            vasenode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
            [node addChildNode:vasenode];
        });
    }
}

- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"开始刷新");
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"刷新结束");
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"移除节点");
}

#pragma -mark sessionDelegate

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame
{
//    NSLog(@"相机移动");
}

- (void)session:(ARSession *)session didAddAnchors:(NSArray<ARAnchor*>*)anchors
{
//    NSLog(@"添加锚点");
}

- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<ARAnchor*>*)anchors
{
//    NSLog(@"刷新锚点");
}

- (void)session:(ARSession *)session didRemoveAnchors:(NSArray<ARAnchor*>*)anchors
{
//    NSLog(@"移除锚点");
}
@end
