//
//  ViewController.m
//  ARKitTestFive
//
//  Created by 王磊 on 2017/8/4.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "ViewController.h"
#import "ARSCNViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)respondsToButton:(id)sender
{
    ARSCNViewController *arscnVC = [[ARSCNViewController alloc] init];
    [self presentViewController:arscnVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
