//
//  QLNetworkEnum.h
//  QLNetworking
//
//  Created by Zhong Junchi on 2017/9/19.
//  Copyright © 2017年 yuntu. All rights reserved.
//

#ifndef QLNetworkEnum_h
#define QLNetworkEnum_h

#if DEBUG
#define QLDebugLog(...)            printf("%s", [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#else
#define QLDebugLog(...)           
#endif


/*
 当产品要求返回数据不正确或者为空的时候显示一套UI，请求超时和网络不通的时候显示另一套UI时，使用这个enum来决定使用哪种UI。（安居客PAD就有这样的需求，sigh～）
 你不应该在回调数据验证函数里面设置这些值，事实上，在任何派生的子类里面你都不应该自己设置manager的这个状态，baseManager已经帮你搞定了。
 强行修改manager的这个状态有可能会造成程序流程的改变，容易造成混乱。
 */
typedef NS_ENUM (NSUInteger, QLAPIManagerErrorType){
    
    QLAPIManagerErrorTypeDefault,       /*** 没有产生过API请求，这个是manager的默认状态。 ***/
    QLAPIManagerErrorTypeSuccess,       /*** API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。 ***/
    QLAPIManagerErrorTypeNoContent,     /*** API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。 ***/
    QLAPIManagerErrorTypeParamsError,   /*** 参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。 ***/
    QLAPIManagerErrorTypeTimeout,       /*** 请求超时。QLAPIProxy设置的是20秒超时，具体超时时间的设置请自己去看QLAPIProxy的相关代码。 ***/
    QLAPIManagerErrorTypeNoNetWork      /*** 网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。 ***/
};


typedef NS_ENUM (NSUInteger, QLAPIManagerRequestType){
    
    QLAPIManagerRequestTypeGet,
    QLAPIManagerRequestTypePost,
    QLAPIManagerRequestTypePut,
    QLAPIManagerRequestTypeDelete,
    QLAPIManagerRequestTypeUpload,
    QLAPIManagerRequestTypeDownload
};


typedef NS_ENUM(NSUInteger, QLURLResponseStatus){
    
    QLURLResponseStatusSuccess,       /*** 作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的QLAPIBaseManager来决定。***/
    QLURLResponseStatusErrorTimeout,
    QLURLResponseStatusErrorNoNetwork /*** 默认除了超时以外的错误都是无网络错误。 ***/
};

#endif /* QLNetworkEnum_h */
