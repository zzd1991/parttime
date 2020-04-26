//
//  JXBaseViewController.h
//  JiXuJianZhi
//
//  Created by John Mr on 2020/4/24.
//  Copyright © 2020 oneteam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JXNoNetWorkView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXBaseViewController : UIViewController

@property (nonatomic, strong) JXNoNetWorkView *noNetView;
@property (nonatomic, strong) NSString *backImgName;

@property (nonatomic, strong) UIView *barLineView;

@property (nonatomic, strong) UIViewController *popToDestinationVC; // 跳转回指定VC
@property (nonatomic, strong) NSString *popToDestiantionClassName;  // 跳转回指定class
@property (nonatomic, assign) BOOL ifPopToRootView;
@property (nonatomic, assign) BOOL ifDismissView;

- (void)backAction:(id)sender;
- (void)addBackButton;
- (void)setupNavigationBar;
- (void)reloadNetRequest;

- (void)popSelf;

- (void)setInterfaceOrientation:(UIInterfaceOrientation)orientation;

- (void)textStateHUD:(NSString *)text;
- (void)textStateHUD:(NSString *)text finishBlock:(void (^)(void))finishBlock;
- (void)showActivityHUD:(NSString *)text;
- (void)hideHUDView;

@end

NS_ASSUME_NONNULL_END
