//
//  JXMainTabBarInfoManager.h
//  JiXuJianZhi
//
//  Created by John Mr on 2020/4/24.
//  Copyright © 2020 oneteam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXMainTabBarInfoManager : NSObject

/** 控制器 */
@property (nonatomic, strong, readonly) NSMutableArray *vcArr;

/** 标题 */
@property (nonatomic, strong, readonly) NSArray *titles;

/** icon */
@property (nonatomic, strong, readonly) NSArray *imageNameStrs;

/** selected icon */
@property (nonatomic, strong, readonly) NSArray *imageNameSelectedStrs;

/** 单例方法 */
+ (id)sharedInstance;

/** 初始化tabBar */
- (void)loadMainTabBar;

@end

NS_ASSUME_NONNULL_END
