//
//  JXGetJobApi.m
//  JiXuJianZhi
//
//  Created by John Mr on 2020/4/26.
//  Copyright © 2020 oneteam. All rights reserved.
//

#import "JXGetJobApi.h"
#import "JXGetJobModel.h"

@implementation JXGetJobApi

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}

#pragma - QLAPIManager
- (NSString *)methodName
{
    return @"getparttimejob";
}

-(NSString *)serviceType
{
    return kJXBasicServiceKey;
}

-(QLAPIManagerRequestType)requestType
{
    return QLAPIManagerRequestTypeGet;
}

- (BOOL)shouldCache
{
    return NO;
}

#pragma make - QLAPIManagerDataReformer
-(id)manager:(QLAPIBaseManager *)manager reformData:(NSDictionary *)data{
    if([manager isKindOfClass:[self class]])
    {
        NSArray *getJobModelArr = [JXGetJobModel mj_objectArrayWithKeyValuesArray:data];

        return getJobModelArr;
    }
    return nil;
}

#pragma mark - QLAPIManagerValidator
-(BOOL)manager:(QLAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data{
    return  YES;
}

-(BOOL)manager:(QLAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data{
    return [JXResponseHandle processRespDictCodeZero:data];
}

@end
