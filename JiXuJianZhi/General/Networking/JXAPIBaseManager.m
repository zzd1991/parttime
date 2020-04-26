//
//  JXAPIBaseManager.m
//  XMSport
//
//  Created by John on 2019/1/25.
//  Copyright © 2019 XMSport. All rights reserved.
//

#import "JXAPIBaseManager.h"

@interface JXAPIBaseManager () <QLAPIManagerValidator>

@end

@implementation JXAPIBaseManager

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}

#pragma mark - QLAPIManager
- (NSString *)methodName
{
    return @"";
}

- (NSString *)serviceType
{
    return kJXBasicServiceKey;
}

- (QLAPIManagerRequestType)requestType
{
    return QLAPIManagerRequestTypePost;
}

- (BOOL)shouldCache
{
    return NO;
}

#pragma mark - QLAPIManagerValidator

- (BOOL)manager:(QLAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return YES;
}

- (BOOL)manager:(QLAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    return [JXResponseHandle processRespDictCodeZero:data];
}

@end
