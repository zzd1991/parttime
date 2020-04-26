//
//  JXTabBarController.h
//  JiXuJianZhi
//
//  Created by John Mr on 2020/4/24.
//  Copyright © 2020 oneteam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXTabBarController : UITabBarController

- (instancetype)initWithRootViewControllers:(NSArray *)controllers andTitles:(NSArray *)titles andImageNames:(NSArray *)imageNames andImageSelectedNames:(NSArray *)imageSelectedNames;

@end

NS_ASSUME_NONNULL_END
