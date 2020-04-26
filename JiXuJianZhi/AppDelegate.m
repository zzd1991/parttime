//
//  AppDelegate.m
//  JiXuJianZhi
//
//  Created by John Mr on 2020/4/24.
//  Copyright © 2020 oneteam. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"

#import "JXMainTabBarInfoManager.h"
#import "JXLaunchViewController.h"

@interface AppDelegate () <QLServiceFactoryDataSource>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 启动图片延时: 1秒
    [NSThread sleepForTimeInterval:1.5];
    
    [QLServiceFactory sharedInstance].dataSource = self;
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [[JXMainTabBarInfoManager sharedInstance] loadMainTabBar];

    [self.window makeKeyAndVisible];
//    }

    return YES;
}

#pragma mark - QLServiceFactoryDataSource

- (NSDictionary<NSString *,NSString *> *)servicesKindsOfServiceFactory
{
    return @{kJXBasicServiceKey: @"JXBasicService"};
}


@end
