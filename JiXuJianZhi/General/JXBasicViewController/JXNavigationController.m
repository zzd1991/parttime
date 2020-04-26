//
//  JZNavigationController.m
//  JiXuJianZhi
//
//  Created by John Mr on 2020/4/24.
//  Copyright © 2020 oneteam. All rights reserved.
//

#import "JXNavigationController.h"

@interface JXNavigationController ()

@end

@implementation JXNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Orientation
- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

@end
