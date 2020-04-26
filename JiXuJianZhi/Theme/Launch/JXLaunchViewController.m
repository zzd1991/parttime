//
//  JXLaunchViewController.m
//  JiXuJianZhi
//
//  Created by John Mr on 2020/4/24.
//  Copyright © 2020 oneteam. All rights reserved.
//

#import "JXLaunchViewController.h"
#import "AppDelegate.h"
#import "JXMainTabBarInfoManager.h"

@interface JXLaunchViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView      *bannerScrollView;
@property (nonatomic, strong) NSMutableArray    *titleImgViewArr;
@property (nonatomic, strong) NSMutableArray    *subtitleImgViewArr;

@end

@implementation JXLaunchViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    self.view.backgroundColor = [UIColor redColor];
    
    self.bannerScrollView.contentSize = CGSizeMake(kJX_ScreenWidth * 3, kJX_ScreenHeight);
    [self.view addSubview:self.bannerScrollView];
//    [self.bannerScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.bottom.mas_equalTo(0);
//    }];
}

- (void)experBtn
{
    [[JXMainTabBarInfoManager sharedInstance] loadMainTabBar];
}

#pragma mark -  getter

- (UIScrollView *)bannerScrollView
{
    if (!_bannerScrollView) {
        _bannerScrollView = [[UIScrollView alloc] init];
        _bannerScrollView.delegate = self;
        _bannerScrollView.showsHorizontalScrollIndicator = NO;
        _bannerScrollView.pagingEnabled = YES;
        _bannerScrollView.bounces = NO;
    }
    return _bannerScrollView;
}

@end
