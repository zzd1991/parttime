//
//  JXBaseViewController.m
//  JiXuJianZhi
//
//  Created by John Mr on 2020/4/24.
//  Copyright © 2020 oneteam. All rights reserved.
//

#import "JXBaseViewController.h"
#import "JXCommonTool.h"
#import "UINavigationController+JXTool.h"
#import "JXNoNetWorkView.h"


@interface JXBaseViewController () <UIGestureRecognizerDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) MBProgressHUD *hudView;

@end

@implementation JXBaseViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserTokenInvalidNotification object:nil];
//    JXDebugLog(@"dealloc - %@\n",NSStringFromClass([self class]));
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.backImgName = @"goBack";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = JX_UIColorFromHEX(0xF3F4F8);
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    [self setupNavigationBar];
    
//    [self addBackButton];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tokenInvalid:)
                                                 name:kUserTokenInvalidNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.barLineView.hidden = YES;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled  = true;
    }
    
    NSLog(@"进入%@",NSStringFromClass([self class]));
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [JXCommonTool resignCurrentFirstResponder];
    [self hideHUDView];
    NSLog(@"离开%@",NSStringFromClass([self class]));
}

- (void)addBackButton
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, JX_XX_11(50), 24)];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setImage:[[UIImage imageNamed:self.backImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton setImage:[[UIImage imageNamed:self.backImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
}

- (void)reloadNetRequest
{
    
}

#pragma mark - StatusBar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark -  NavigationBar

- (void)setupNavigationBar
{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:JX_UIColorFromHEX(0x323334), NSFontAttributeName:JX_Default_Medium_Font(18)}];
//    [navigationBar setBackgroundColor:[UIColor clearColor]];
    [navigationBar setBarTintColor:JX_UIColorFromHEX(0xFFFFFF)];
    [navigationBar setTintColor:[UIColor whiteColor]];
    [navigationBar setShadowImage:[UIImage new]];
    navigationBar.translucent = NO;
    
    UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
    self.barLineView = backgroundView.subviews.firstObject;
}

#pragma mark - Orientation

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)setInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

#pragma mark - Public Method

- (void)backAction:(id)sender
{
    [self popSelf];
}

- (void)popSelf
{
    if (_popToDestinationVC)
    {
        [UINavigationController jx_popToDestinationVC:_popToDestinationVC inVC:self];
        return;
    }
    else if (_popToDestiantionClassName)
    {
        [UINavigationController jx_popToDestinationVCClassName:_popToDestiantionClassName inVC:self];
        return;
    }
    else if (_ifPopToRootView)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (_ifDismissView)
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - token 失效

- (void)tokenInvalid:(NSNotification *)info
{
    // 清除登录信息
    // TODO...
    
//    QL_ExecuteInMain(^{
//        // TODO...
//    });
}

#pragma mark - HUD

- (void)showActivityHUD:(NSString *)text
{
    JX_ExecuteInMain( ^{
        self.hudView.bezelView.color = [UIColor clearColor];
        self.hudView.contentColor = [UIColor blackColor];
        
        [self.view bringSubviewToFront:self.hudView];
        self.hudView.detailsLabel.text = text;
        
        self.hudView.mode = MBProgressHUDModeIndeterminate;
        [self.hudView showAnimated:YES];
    });
}

- (void)textStateHUD:(NSString *)text
{
    for (UIImageView *imageView in self.hudView.subviews)
    {
        if ([imageView isKindOfClass:[UIImageView class]])
            imageView.hidden = YES;
    }
    
    if (text && text.length > 0)
    {
        JX_ExecuteInMain(^{
            self.hudView.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
            self.hudView.contentColor = [UIColor whiteColor];
            
            [self.view bringSubviewToFront:self.hudView];
            self.hudView.detailsLabel.text = text;
            self.hudView.minShowTime = 1.f;
            self.hudView.mode = MBProgressHUDModeText;
            [self.hudView showAnimated:YES];
            [self.hudView hideAnimated:NO afterDelay:1.3f];
        });
    }
    else
    {
        [self hideHUDView];
    }
}

- (void)textStateHUD:(NSString *)text finishBlock:(void (^)(void))finishBlock
{
    [self textStateHUD:text];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.3f*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (finishBlock) {
            finishBlock();
        }
    });
}

- (void)hideHUDView
{
    JX_ExecuteInMain(^{
        [self.hudView hideAnimated:NO afterDelay:0];
    });
}

#pragma mark - lazy

- (MBProgressHUD *)hudView
{
    if (_hudView == nil)
    {
        _hudView = [[MBProgressHUD alloc] initWithView:self.view];
        _hudView.label.text = nil;
        _hudView.detailsLabel.text = nil;
        _hudView.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//        _hudView.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
//        _hudView.contentColor = [UIColor whiteColor];
        _hudView.bezelView.color = [UIColor clearColor];
        _hudView.contentColor = [UIColor blackColor];
        _hudView.detailsLabel.textColor = [UIColor whiteColor];
        _hudView.detailsLabel.font = [UIFont systemFontOfSize:13.0f];
        
        [self.view addSubview:_hudView];
        [self.view bringSubviewToFront:_hudView];
    }
    return _hudView;
}

- (JXNoNetWorkView *)noNetView {
    if (!_noNetView) {
        _noNetView = [[JXNoNetWorkView alloc] init];
        @weakify(self)
        _noNetView.buttonClickBlock = ^{
            @strongify(self)
            [self reloadNetRequest];
        };
    }
    return _noNetView;
}

@end
