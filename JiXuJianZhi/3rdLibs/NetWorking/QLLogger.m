//
//  AXLogger.m
//  RTNetworking
//
//  Created by Jccc on 2017-09-6.
//  Copyright (c) 2017年 Yuntu inc. All rights reserved.
//

#import "QLLogger.h"
#import "NSObject+QLNetworkingMethods.h"
#import "NSMutableString+QLNetworkingMethods.h"
#import "NSArray+QLNetworkingMethods.h"
#import "QLApiProxy.h"
#import "QLServiceFactory.h"

@interface QLLogger ()

@property (nonatomic, strong, readwrite) QLLoggerConfiguration *configParams;

@end

@implementation QLLogger

#pragma mark - Life cycle

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static QLLogger *sharedInstance;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.configParams = [[QLLoggerConfiguration alloc] init];
    }
    return self;
}

#pragma mark - Public

+ (void)logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName service:(QLService *)service requestParams:(id)requestParams httpMethod:(NSString *)httpMethod
{
#ifdef DEBUG
    BOOL isOnline = NO;
    if ([service respondsToSelector:@selector(isOnline)]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[service methodSignatureForSelector:@selector(isOnline)]];
        invocation.target = service;
        invocation.selector = @selector(isOnline);
        [invocation invoke];
        [invocation getReturnValue:&isOnline];
    }
    
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n**************************************************************\n*                       Request Start                        *\n**************************************************************\n\n"];
    
    [logString appendFormat:@"API Name:\t\t%@\n", [apiName QL_defaultValue:@"N/A"]];
    [logString appendFormat:@"Method:\t\t\t%@\n", [httpMethod QL_defaultValue:@"N/A"]];
    [logString appendFormat:@"Version:\t\t%@\n", [service.apiVersion QL_defaultValue:@"N/A"]];
    [logString appendFormat:@"Service:\t\t%@\n", [service class]];
    [logString appendFormat:@"Status:\t\t\t%@\n", isOnline ? @"online" : @"offline"];
    [logString appendFormat:@"Public Key:\t\t%@\n", [service.publicKey QL_defaultValue:@"N/A"]];
    [logString appendFormat:@"Private Key:\t%@\n", [service.privateKey QL_defaultValue:@"N/A"]];
    [logString appendFormat:@"Params:\n%@", requestParams];
    
    [logString QL_appendURLRequest:request];
    
    [logString appendFormat:@"\n\n**************************************************************\n*                         Request End                        *\n**************************************************************\n\n\n\n"];
    QLDebugLog(@"%@", logString);
#endif
}

+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response responseString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error
{
#ifdef DEBUG
    BOOL shouldLogError = error ? YES : NO;
    
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                        API Response                        =\n==============================================================\n\n"];
    
    [logString appendFormat:@"Status:\t%ld\t(%@)\n\n", (long)response.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode]];
    [logString appendFormat:@"Content:\n\t%@\n\n", responseString];
    if (shouldLogError) {
        [logString appendFormat:@"Error Domain:\t\t\t\t\t\t\t%@\n", error.domain];
        [logString appendFormat:@"Error Domain Code:\t\t\t\t\t\t%ld\n", (long)error.code];
        [logString appendFormat:@"Error Localized Description:\t\t\t%@\n", error.localizedDescription];
        [logString appendFormat:@"Error Localized Failure Reason:\t\t\t%@\n", error.localizedFailureReason];
        [logString appendFormat:@"Error Localized Recovery Suggestion:\t%@\n\n", error.localizedRecoverySuggestion];
    }
    
    [logString appendString:@"\n---------------  Related Request Content  --------------\n"];
    
    [logString QL_appendURLRequest:request];
    
    [logString appendFormat:@"\n\n==============================================================\n=                        Response End                        =\n==============================================================\n\n\n\n"];
    
    QLDebugLog(@"%@", logString);
#endif
}

+ (void)logDebugInfoWithCachedResponse:(QLURLResponse *)response methodName:(NSString *)methodName serviceIdentifier:(QLService *)service
{
#ifdef DEBUG
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                      Cached Response                       =\n==============================================================\n\n"];
    
    [logString appendFormat:@"API Name:\t\t%@\n", [methodName QL_defaultValue:@"N/A"]];
    [logString appendFormat:@"Version:\t\t%@\n", [service.apiVersion QL_defaultValue:@"N/A"]];
    [logString appendFormat:@"Service:\t\t%@\n", [service class]];
    [logString appendFormat:@"Public Key:\t\t%@\n", [service.publicKey QL_defaultValue:@"N/A"]];
    [logString appendFormat:@"Private Key:\t%@\n", [service.privateKey QL_defaultValue:@"N/A"]];
    [logString appendFormat:@"Method Name:\t%@\n", methodName];
    [logString appendFormat:@"Params:\n%@\n\n", response.requestParams];
    [logString appendFormat:@"Content:\n\t%@\n\n", response.contentString];
    
    [logString appendFormat:@"\n\n==============================================================\n=                        Response End                        =\n==============================================================\n\n\n\n"];
    QLDebugLog(@"%@", logString);
#endif
}


- (void)logWithActionCode:(NSString *)actionCode params:(NSDictionary *)params
{
    NSMutableDictionary *actionDict = [[NSMutableDictionary alloc] init];
    actionDict[@"act"] = actionCode;
    [actionDict addEntriesFromDictionary:params];
    NSDictionary *logJsonDict = @{self.configParams.sendActionKey:[@[actionDict] QL_jsonString]};
    [[QLApiProxy sharedInstance] callPOSTWithParams:logJsonDict serviceIdentifier:self.configParams.serviceType methodName:self.configParams.sendActionMethod success:nil fail:nil];
}

@end
