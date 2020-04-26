//
//  NSMutableDictionary+Safety.h
//  JiXuJianZhi
//
//  Created by John Mr on 2020/4/24.
//  Copyright © 2020 oneteam. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (Safety)

- (void)SafetySetObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end

NS_ASSUME_NONNULL_END
