//
//  QLCachedObject.m
//  RTNetworking
//
//  Created by Jccc on 2017-09-26.
//  Copyright (c) 2017年 Yuntu inc. All rights reserved.
//

#import "QLCachedObject.h"
#import "QLNetworkingConfigurationManager.h"

@interface QLCachedObject ()

@property (nonatomic, copy, readwrite) NSData *content;
@property (nonatomic, copy, readwrite) NSDate *lastUpdateTime;

@end

@implementation QLCachedObject

#pragma mark - Life cycle

- (instancetype)initWithContent:(NSData *)content
{
    if (self = [super init])
    {
        self.content = content;
    }
    return self;
}

#pragma mark - Public method

- (void)updateContent:(NSData *)content
{
    self.content = content;
}

#pragma mark - getters

- (BOOL)isEmpty
{
    return self.content == nil;
}

- (BOOL)isOutdated
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
    return timeInterval > [QLNetworkingConfigurationManager sharedInstance].cacheOutdateTimeSeconds ;
}

- (void)setContent:(NSData *)content
{
    _content = [content copy];
    self.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
}

@end
