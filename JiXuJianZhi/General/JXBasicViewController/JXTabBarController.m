//
//  JXTabBarController.m
//  JiXuJianZhi
//
//  Created by John Mr on 2020/4/24.
//  Copyright © 2020 oneteam. All rights reserved.
//

#import "JXTabBarController.h"
#import "JXNavigationController.h"

#define kJXTabBarIconSize 24

@interface JXTabBarController ()

@property (nonatomic, assign) NSInteger tabbarIndexOfMessage;

@end

@implementation JXTabBarController

#pragma mark - Life Cycle

- (instancetype)initWithRootViewControllers:(NSArray *)controllers
                                  andTitles:(NSArray *)titles
                              andImageNames:(NSArray *)imageNames
                      andImageSelectedNames:(NSArray *)imageSelectedNames
{
    if (self = [super init]) {
        for (NSInteger i = 0; i <controllers.count; i++) {
            
            UIViewController *controller = controllers[i];

            JXNavigationController *navigationController = [[JXNavigationController alloc] initWithRootViewController:controllers[i]];
            controller.title = titles[i];
            [self addChildViewController:navigationController];
            
            UITabBarItem *item = controller.tabBarItem;
            [item setImage:[UIImage imageNamed:imageNames[i]]];
            [item setTitleTextAttributes:@{NSForegroundColorAttributeName:JX_UIColorFromHEX(0xFA6400)} forState:UIControlStateSelected];
            
            UIImage *selectImg = [UIImage imageNamed:imageSelectedNames[i]];
            selectImg = [selectImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [item setSelectedImage:selectImg];
            
            [UITabBar appearance].translucent = NO;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
