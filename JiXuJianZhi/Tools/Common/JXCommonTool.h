//
//  JXCommonTool.h
//  JiXuJianZhi
//
//  Created by John Mr on 2020/4/24.
//  Copyright © 2020 oneteam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
* 说明：
* 常用的tools，但涉及到具体的类的工具方法，比如NSString等，请放到Category里面，不要放在这里
*/
@interface JXCommonTool : NSObject


+ (void)resignCurrentFirstResponder;

/*
 * 给view绑定tap手势
 * tapBlock: 手势触发的block动作
 */
+ (void)addTappedBlockWith:(id)view andBlock:(void(^)(void))tapBlock;


@end

NS_ASSUME_NONNULL_END
