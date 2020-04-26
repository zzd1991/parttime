//
//  AXServiceFactory.h
//  RTNetworking
//
//  Created by Jccc on 2017-09-12.
//  Copyright (c) 2017年 Yuntu inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLService.h"

@protocol QLServiceFactoryDataSource <NSObject>

/*
 * key为service的Identifier
 * value为service的Class的字符串
 */
- (NSDictionary<NSString *,NSString *> *)servicesKindsOfServiceFactory;

@end

@interface QLServiceFactory : NSObject

@property (nonatomic, weak) id<QLServiceFactoryDataSource> dataSource;

+ (instancetype)sharedInstance;
- (QLService<QLServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier;

@end
