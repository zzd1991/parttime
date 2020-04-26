//
//  UINavigationController+JXTool.h
//  JiXuJianZhi
//
//  Created by John Mr on 2020/4/24.
//  Copyright © 2020 oneteam. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (JXTool)

// 获取当前控制器
+ (UIViewController *)jx_currentViewController;

// 获取上一控制器（导航）
+ (UIViewController *)jx_lastViewControllerOf:(UIViewController *)currentVC;

// 获取上一控制器ClassName（导航）
+ (NSString *)jx_lastViewControllerNameOf:(UIViewController *)currentVC;

// pop到指定的VC，如果controllers不存在该VC，pop到RootVC
+ (void)jx_popToDestinationVC:(UIViewController *)destionationVC inVC:(UIViewController *)nowVC;

// pop到指定的VC，如果controllers不存在该VC，pop到RootVC
+ (void)jx_popToDestinationVCClassName:(NSString *)destionationVCClassName inVC:(UIViewController *)nowVC;


@end

NS_ASSUME_NONNULL_END
