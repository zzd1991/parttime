//
//  AJKBaseManager.h
//  Jccc
//
//  Created by Jccc on 13-12-2.
//  Copyright (c) 2013年 Yuntu inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLURLResponse.h"
#import "QLNetworkEnum.h"
#import "QLAPIManagerInterceptor.h"
#import "QLAPIManagerValidator.h"
#import "QLAPIManager.h"
#import "QLAPIManagerDataReformer.h"

// 在调用成功之后的params字典里面，用这个key可以取出requestID
static NSString * const kQLAPIBaseManagerRequestID = @"kQLAPIBaseManagerRequestID";

@class QLAPIBaseManager;
#pragma mark - api回调
@protocol QLAPIManagerCallBackDelegate <NSObject>

@required
- (void)managerCallAPIDidSuccess:(QLAPIBaseManager *)manager;
- (void)managerCallAPIDidFailed:(QLAPIBaseManager *)manager;

@end

#pragma mark - 让manager能够获取调用API所需要的数据
@protocol QLAPIManagerParamSource <NSObject>

@required
- (NSDictionary *)paramsForApi:(QLAPIBaseManager *)manager;

@optional
//上传的接口需要实现此协议方法
- (id)dataForUploadApi:(QLAPIBaseManager *)manager;

@end


@interface QLAPIBaseManager : NSObject

@property (nonatomic, weak) id<QLAPIManagerCallBackDelegate> delegate;
@property (nonatomic, weak) id<QLAPIManagerParamSource>     paramSource;
@property (nonatomic, weak) id<QLAPIManagerValidator>       validator;
@property (nonatomic, weak) NSObject<QLAPIManager>          *child; //里面会调用到NSObject的方法，所以这里不用id
@property (nonatomic, weak) id<QLAPIManagerInterceptor>     interceptor;

/*
 baseManager是不会去设置errorMessage的，派生的子类manager可能需要给controller提供错误信息。所以为了统一外部调用的入口，设置了这个变量。
 派生的子类需要通过extension来在保证errorMessage在对外只读的情况下使派生的manager子类对errorMessage具有写权限。
 */
@property (nonatomic, copy, readonly)   NSString *errorMessage;
@property (nonatomic, readonly)         QLAPIManagerErrorType errorType;
@property (nonatomic, strong)           QLURLResponse *response;

@property (nonatomic, assign, readonly) BOOL isReachable;
@property (nonatomic, assign, readonly) BOOL isLoading;

- (id)fetchDataWithReformer:(id<QLAPIManagerDataReformer>)reformer;

//来去从服务器获得的错误信息
- (id)fetchFailedRequstMsg:(id<QLAPIManagerDataReformer>)reformer;

//尽量使用loadData这个方法,这个方法会通过param source来获得参数，这使得参数的生成逻辑位于controller中的固定位置
- (NSInteger)loadData;

- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

// 拦截器方法，继承之后需要调用一下super
- (BOOL)beforePerformSuccessWithResponse:(QLURLResponse *)response;
- (void)afterPerformSuccessWithResponse:(QLURLResponse *)response;

- (BOOL)beforePerformFailWithResponse:(QLURLResponse *)response;
- (void)afterPerformFailWithResponse:(QLURLResponse *)response;

- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params;
- (void)afterCallingAPIWithParams:(NSDictionary *)params;

/*
 用于给继承的类做重载，在调用API之前额外添加一些参数,但不应该在这个函数里面修改已有的参数。
 子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了
 QLAPIBaseManager会先调用这个函数，然后才会调用到 id<QLAPIManagerValidator> 中的 manager:isCorrectWithParamsData:
 所以这里返回的参数字典还是会被后面的验证函数去验证的。
 
 假设同一个翻页Manager，ManagerA的paramSource提供page_size=15参数，ManagerB的paramSource提供page_size=2参数
 如果在这个函数里面将page_size改成10，那么最终调用API的时候，page_size就变成10了。然而外面却觉察不到这一点，因此这个函数要慎用。
 
 这个函数的适用场景：
 当两类数据走的是同一个API时，为了避免不必要的判断，我们将这一个API当作两个API来处理。
 那么在传递参数要求不同的返回时，可以在这里给返回参数指定类型。
 
 具体请参考AJKHDXFLoupanCategoryRecommendSamePriceAPIManager和AJKHDXFLoupanCategoryRecommendSameAreaAPIManager
 */
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (void)cleanData;
- (BOOL)shouldCache;

- (void)successedOnCallingAPI:(QLURLResponse *)response;
- (void)failedOnCallingAPI:(QLURLResponse *)response withErrorType:(QLAPIManagerErrorType)errorType;

@end
