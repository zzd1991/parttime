//
//  AXService.m
//  RTNetworking
//
//  Created by Jccc on 2017-09-15.
//  Copyright (c) 2017年 Yuntu inc. All rights reserved.
//

#import "QLService.h"
#import "NSObject+QLNetworkingMethods.h"

@interface QLService()

@property (nonatomic, weak, readwrite) id<QLServiceProtocol> child;

@end

@implementation QLService

- (instancetype)init
{
    if (self = [super init])
    {
        if ([self conformsToProtocol:@protocol(QLServiceProtocol)])
        {
            self.child = (id<QLServiceProtocol>)self;
        }
    }
    return self;
}

- (NSString *)urlGeneratingRuleByMethodName:(NSString *)methodName
{
    NSString *urlString = nil;
    if (self.apiVersion.length != 0)
    {
        urlString = [NSString stringWithFormat:@"%@/%@/%@", self.apiBaseUrl, self.apiVersion, methodName];
    }
    else
    {
        urlString = [NSString stringWithFormat:@"%@/%@", self.apiBaseUrl, methodName];
    }
    return urlString;
}

#pragma mark - getters and setters

- (NSString *)privateKey
{
    return self.child.isOnline ? self.child.onlinePrivateKey : self.child.offlinePrivateKey;
}

- (NSString *)publicKey
{
    return self.child.isOnline ? self.child.onlinePublicKey : self.child.offlinePublicKey;
}

- (NSString *)apiBaseUrl
{
    return self.child.isOnline ? self.child.onlineApiBaseUrl : self.child.offlineApiBaseUrl;
}

- (NSString *)apiVersion
{
    return self.child.isOnline ? self.child.onlineApiVersion : self.child.offlineApiVersion;
}

@end
