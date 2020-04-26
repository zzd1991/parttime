//
//  UINavigationController+JXTool.m
//  JiXuJianZhi
//
//  Created by John Mr on 2020/4/24.
//  Copyright © 2020 oneteam. All rights reserved.
//

#import "UINavigationController+JXTool.h"

@implementation UINavigationController (JXTool)

+ (UIViewController *)findBestViewController:(UIViewController*)vc
{
    if (vc.presentedViewController)
    {
        // Return presented view controller
        return [[self class] findBestViewController:vc.presentedViewController];
    }
    else if ([vc isKindOfClass:[UINavigationController class]])
    {
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [[self class] findBestViewController:svc.topViewController];
        else
            return vc;
    }
    else if ([vc isKindOfClass:[UITabBarController class]])
    {
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [[self class] findBestViewController:svc.selectedViewController];
        else
            return vc;
    }
    else
    {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}

// 获取当前控制器
+ (UIViewController *)jx_currentViewController
{
    // Find best view controller
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [[self class] findBestViewController:viewController];
}

// 获取上一控制器(导航）
+ (UIViewController *)jx_lastViewControllerOf:(UIViewController *)currentVC
{
    if (currentVC.navigationController.viewControllers.count == 1) return nil;
    NSInteger index = [currentVC.navigationController.viewControllers indexOfObject:currentVC];
    if (index > 0)
    {
        UIViewController *lastVC = [currentVC.navigationController.viewControllers objectAtIndex:(index-1)] ;
        return lastVC;
    }
    return nil;
}

// 获取上一控制器ClassName(导航)
+ (NSString *)jx_lastViewControllerNameOf:(UIViewController *)currentVC
{
    if (currentVC.navigationController.viewControllers.count == 1) return nil;
    NSInteger index = [currentVC.navigationController.viewControllers indexOfObject:currentVC];
    if (index > 0)
    {
        UIViewController *lastVC = [currentVC.navigationController.viewControllers objectAtIndex:(index-1)] ;
        NSString *lastVCName = NSStringFromClass([lastVC class]);
        return lastVCName;
    }
    return nil;
}

// pop到指定的VC，如果controllers不存在该VC，pop到RootVC
+ (void)jx_popToDestinationVC:(UIViewController *)destionationVC inVC:(UIViewController *)nowVC
{
    if (destionationVC && [nowVC.navigationController.viewControllers containsObject:destionationVC])
    {
        [nowVC.navigationController popToViewController:destionationVC animated:YES];
    }
    else
    {
        NSLog(@"controllers不存在该VC，pop到RootVC");
        [nowVC.navigationController popToRootViewControllerAnimated:YES];
    }
}

// pop到指定的VC，如果controllers不存在该VC，pop到RootVC
+ (void)jx_popToDestinationVCClassName:(NSString *)destionationVCClassName inVC:(UIViewController *)nowVC
{
    for (id tempVC in nowVC.navigationController.viewControllers)
    {
        if ([tempVC isKindOfClass:NSClassFromString(destionationVCClassName)])
        {
            UIViewController *destinationVC = (UIViewController *)tempVC;
            [nowVC.navigationController popToViewController:destinationVC animated:YES];
            return;
        }
    }
    NSLog(@"controllers不存在该VC，pop到RootVC");
    [nowVC.navigationController popToRootViewControllerAnimated:YES];
}


@end
