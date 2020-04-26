//
//  JXMainTabBarInfoManager.m
//  JiXuJianZhi
//
//  Created by John Mr on 2020/4/24.
//  Copyright © 2020 oneteam. All rights reserved.
//

#import "JXMainTabBarInfoManager.h"

#import "JXTabBarController.h"

#import "JXShouYeViewController.h"
#import "JXAllViewController.h"
#import "JXMineViewController.h"

@interface JXMainTabBarInfoManager ()

@property (nonatomic, strong, readwrite) NSMutableArray *vcArr;
@property (nonatomic, strong, readwrite) NSArray *titles;
@property (nonatomic, strong, readwrite) NSArray *imageNameStrs;
@property (nonatomic, strong, readwrite) NSArray *imageNameSelectedStrs;

@end

@implementation JXMainTabBarInfoManager

JX_Share_Instance

- (instancetype)init {
    if (self = [super init]) {
//        [self.appTrialCheckApi loadData];
    }
    return self;
}

#pragma mark - Public Method

- (void)loadMainTabBar
{
    JXBaseViewController *shouyeVC = [[JXShouYeViewController alloc] init];
    JXBaseViewController *allVC  = [[JXAllViewController alloc] init];
    JXBaseViewController *mineVC  = [[JXMineViewController alloc] init];

    [self.vcArr addObject:shouyeVC];
    [self.vcArr addObject:allVC];
    [self.vcArr addObject:mineVC];
    
    self.titles = @[@"首页",@"全部",@"我的"];
    self.imageNameStrs = @[@"icon_home",@"icon_sort",@"icon_me"];
    self.imageNameSelectedStrs = @[@"icon_home_sel",@"icon_sort_sel",@"icon_me_sel"];
    
    JXTabBarController *tabVC = [[JXTabBarController alloc] initWithRootViewControllers:self.vcArr andTitles:self.titles andImageNames:self.imageNameStrs andImageSelectedNames:self.imageNameSelectedStrs];
    
    [UIApplication sharedApplication].delegate.window.rootViewController = tabVC;
}

#pragma mark - Setter And Getter

- (NSMutableArray *)vcArr
{
    if (!_vcArr) {
        _vcArr = [NSMutableArray array];
    }
    return _vcArr;
}

- (NSArray *)imageNameStrs
{
    if (!_imageNameStrs) {
        _imageNameStrs = [NSArray array];
    }
    return _imageNameStrs;
}

- (NSArray *)titles
{
    if (!_titles) {
        _titles = [NSArray array];
    }
    return _titles;
}

- (NSArray *)imageNameSelectedStrs
{
    if (!_imageNameSelectedStrs) {
        _imageNameSelectedStrs = [NSArray array];
    }
    return _imageNameSelectedStrs;
}

@end
