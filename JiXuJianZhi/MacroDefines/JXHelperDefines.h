//
//  JXHelperDefines.h
//  JiXuJianZhi
//
//  Created by John Mr on 2020/4/24.
//  Copyright © 2020 oneteam. All rights reserved.
//

#ifndef JXHelperDefines_h
#define JXHelperDefines_h

// 获取版本号
#define MyShortVersionString     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// 获取app名称
#define MyAppDisplayName         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

// 用户登录
#define JX_IsLogin                 [MyUserManager sharedInstance].isLogin
#define My_CurrentToken            [MyUserManager sharedInstance].token
#define My_CurrentMobile           [MyUserManager sharedInstance].mobile

// 过审开关
#define My_AppStore_Reviewing      ([[MyMainTabBarInfoManager sharedInstance] appTrialStatus] == MyAppTrialStatusOpen)

// 指示线的高度
#define kMyIndicatorLineHeight     2

// Color
#define kMy_BgColor                JX_UIColorFromHEX(0xF3F4F8)

// iOS system version.
#define __JX_Version_Compare(v)                         [[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch]
#define JX_System_Version_Equal_To(v)                   (__JX_Version_Compare(v) == NSOrderedSame)
#define JX_System_Version_Greater_Than(v)               (__JX_Version_Compare(v) == NSOrderedDescending)
#define JX_System_Version_Greater_Than_Or_Equal_To(v)   (__JX_Version_Compare(v) != NSOrderedAscending)
#define JX_System_Version_Less_Than(v)                  (__JX_Version_Compare(v) == NSOrderedAscending)
#define JX_System_Version_Less_Than_Or_Equal_To(v)      (__JX_Version_Compare(v) != NSOrderedDescending)

#define JX_Is_iOS7       (JX_System_Version_Greater_Than(@"7.0"))
#define JX_Is_iOS8       (JX_System_Version_Greater_Than(@"8.0"))
#define JX_Is_iOS9       (JX_System_Version_Greater_Than(@"9.0"))
#define JX_Is_iOS10      (JX_System_Version_Greater_Than(@"10.0"))
#define JX_Is_iOS11      (JX_System_Version_Greater_Than(@"11.0"))

// Respond to selector.
#define JX_Delegate_Has_Method(delegate, selector) ((delegate) && ([delegate respondsToSelector:selector]))

// Weak Self.
#define JX_WS(weakSelf)                 __weak __typeof(&*self)weakSelf = self;

// Strong Self.
#define JX_SS(strongSelf, weakSelf)     __strong __typeof(weakSelf)strongSelf = weakSelf;

// AppDelegate.
#define JX_AppDelegate      (AppDelegate *)[[UIApplication sharedApplication] delegate]

// KeyWindow.
#define JX_KeyWindow        [UIApplication sharedApplication].keyWindow

// App DisplayName.
#define JX_AppDisplayName   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

// NSUserDefaults.
#define JX_UserDefaults_Synchronize     [[NSUserDefaults standardUserDefaults] synchronize]
#define JX_UserDefaults_Get(key)        [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define JX_UserDefaults_Set(value, key) \
{ \
[[NSUserDefaults standardUserDefaults] setObject:value forKey:key]; \
[[NSUserDefaults standardUserDefaults] synchronize]; \
} \

#define JX_UserDefaults_Remove(key)     [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];

// Path.
#define JX_Path_In_Documents(dir)    ([NSString stringWithFormat:@"%@/Documents/%@",   NSHomeDirectory(), dir])
#define JX_Path_In_Temp(dir)         ([NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), dir])

// GCD Thread.
#define JX_ExecuteInMain(block)        dispatch_async(dispatch_get_main_queue(), block)
#define JX_ExecuteInGlobal(block)      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define JX_SafeExecuteInMain(block) \
if ([NSThread isMainThread]) { \
block(); \
} else { \
dispatch_async(dispatch_get_main_queue(), block); \
}

// AppendString safety check
#define JX_SafetyStringByAppendingString(A, B) ((B) ? [(A) stringByAppendingString:(B)] : (A))

// 单例宏定义,.h文件如需声明加 +(instancetype)sharedInstance函数声明
#define JX_Share_Instance \
+(instancetype)sharedInstance { \
static dispatch_once_t once; \
static id instance; \
dispatch_once(&once, ^{ \
instance = [self new]; \
}); \
return instance; \
}

//---------------------------------------------------------------------------
// Log
//---------------------------------------------------------------------------
// 在Release模式下打开NSLog；在Debug模式下关闭NSLog
#ifdef __OPTIMIZE__
#define JXLog(...) {}
#else
#define JXLog(...) NSLog(__VA_ARGS__)
#endif

#define JX_Log_Function JXLog(@"__ %s __", __func__);


//--------单例模式--------
// @interface
#define singleton_interface(className) \
+ (className *)shared##className;

// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}


#endif /* JXHelperDefines_h */
