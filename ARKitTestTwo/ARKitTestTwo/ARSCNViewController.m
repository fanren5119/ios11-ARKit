//
//  ARSCNViewController.m
//  ARKitTestTwo
//
//  Created by 王磊 on 2017/8/3.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "ARSCNViewController.h"
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

@interface ARSCNViewController ()

@property (nonatomic, strong) ARSCNView *arscnView;
@property (nonatomic, strong) ARSession *arSession;
@property (nonatomic, strong) ARWorldTrackingSessionConfiguration *configuration;
@property (nonatomic, strong) SCNNode *planeNode;

@end

@implementation ARSCNViewController

- (ARSessionConfiguration *)configuration
{
    if (_configuration != nil) {
        return _configuration;
    }
    _configuration = [[ARWorldTrackingSessionConfiguration alloc] init];
    _configuration.planeDetection = ARPlaneDetectionHorizontal;
    _configuration.lightEstimationEnabled = YES;
    return _configuration;
}

- (ARSession *)arSession
{
    if (_arSession != nil) {
        return _arSession;
    }
    _arSession = [[ARSession alloc] init];
    return _arSession;
}

- (ARSCNView *)arscnView
{
    if (_arscnView != nil) {
        return _arscnView;
    }
    _arscnView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
    _arscnView.session = self.arSession;
    _arscnView.automaticallyUpdatesLighting = YES;
    return _arscnView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view addSubview:self.arscnView];
    
    [self.arSession runWithConfiguration:self.configuration];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    SCNScene *scene = [SCNScene sceneNamed:@"Models.scnassets/chair/chair.scn"];
    SCNNode *node = scene.rootNode.childNodes[0];
    node.position = SCNVector3Make(0, -1, -1);
    [self.arscnView.scene.rootNode addChildNode:node];
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
