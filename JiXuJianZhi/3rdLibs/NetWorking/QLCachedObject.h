//
//  QLCachedObject.h
//  RTNetworking
//
//  Created by Jccc on 2017-09-26.
//  Copyright (c) 2017年 Yuntu inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLCachedObject : NSObject

@property (nonatomic, copy, readonly)   NSData *content;
@property (nonatomic, copy, readonly)   NSDate *lastUpdateTime;

@property (nonatomic, assign, readonly) BOOL isOutdated;
@property (nonatomic, assign, readonly) BOOL isEmpty;

- (instancetype)initWithContent:(NSData *)content;
- (void)updateContent:(NSData *)content;

@end
