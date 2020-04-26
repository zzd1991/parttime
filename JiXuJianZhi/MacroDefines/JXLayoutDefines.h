//
//  JXLayoutDefines.h
//  JiXuJianZhi
//
//  Created by John Mr on 2020/4/24.
//  Copyright © 2020 oneteam. All rights reserved.
//

#ifndef JXLayoutDefines_h
#define JXLayoutDefines_h

/**
 * Screen Size(By Point)
 */
#define kJX_ScreenWidth    ([UIScreen mainScreen].bounds.size.width)
#define kJX_ScreenHeight   ([UIScreen mainScreen].bounds.size.height)

// 判断是否为iPhone X 系列
#define IPHONE_XSeries \
({BOOL isPhoneXSeries = NO;\
 if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {\
    isPhoneXSeries = YES; \
 }\
 if (@available(iOS 11.0, *)) {\
    isPhoneXSeries = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
 }\
(isPhoneXSeries);})


// Common height.
#define kJX_NavigationBarHeight  44.0
#define kJX_StatusBarHeight      (IPHONE_XSeries ? 44.0 : 20.0)
#define kJX_TopLayoutGuideHeight (kJX_NavigationBarHeight + kJX_StatusBarHeight)

/**
 *tabbar高度
 */
#define kJX_TabBarHeight (IPHONE_XSeries ? (49 + 34) : 49)
#define kJX_SafeAreaBottomHeight (IPHONE_XSeries ? 34.0 : 0.0)


// iPhone XR / XS Max 屏幕尺寸
#define kQL_WidthJX 414.0
#define kQL_HeightJX 896.0

// X
#define kQL_WidthX 375.0
#define kQL_HeightX 812.0

// 6p
#define kQL_Width6P 414.0
#define kQL_Height6P 736.0

// 6
#define kQL_Width6 375.0
#define kQL_Height6 667.0

// 5 | 5c | 5s
#define kQL_Width5 320.0
#define kQL_Height5 568.0

// 4 | 4s
#define kQL_Width4 320.0
#define kQL_Height4 480.0

// 物理点 为单位
#define JX_XX_11(value)     (1.0 * (value) * kJX_ScreenWidth / kQL_WidthX)

// 字体
// System font.
#define JX_System_Font(value)       [UIFont systemFontOfSize:ceil(JX_XX_11(value))]

// Bold system font.
#define JX_BoldSystemFont(value)    [UIFont boldSystemFontOfSize:ceil(JX_XX_11(value))]

// 设计图上 用到的 BarlowCondensed-Medium
#define JX_BarlowMedium_Font(value) [UIFont fontWithName:@"BarlowCondensed-Medium" size:ceil(JX_XX_11(value))];

// 设计图上 用到的 290-CAI978
#define JX_CAI978_Font(value) [UIFont fontWithName:@"290-CAI978" size:ceil(JX_XX_11(value))];

// 设计图上用到平方字体调用以下这三个方法
// DefaultFont.
#define JX_Default_Font(value)          JX_PingFangRegular_Font(value)

// Defalut MediumFont
#define JX_Default_Medium_Font(value)   JX_PingFangMedium_Font(value)

// NavigationTitle DefaultFont  粗体t调用此方法
#define JX_Navigation_Font(value)       JX_PingFangSemibold_Font(value)

// PingFangSC
#define JX_PingFangLight_Font(value)    [UIFont fontWithName:@"PingFangSC-Light" size:ceil(JX_XX_11(value))]
#define JX_PingFangRegular_Font(value)  [UIFont fontWithName:@"PingFangSC-Regular" size:ceil(JX_XX_11(value))]
#define JX_PingFangMedium_Font(value)   [UIFont fontWithName:@"PingFangSC-Medium" size:ceil(JX_XX_11(value))]
#define JX_PingFangSemibold_Font(value) [UIFont fontWithName:@"PingFangSC-Semibold" size:ceil(JX_XX_11(value))]


#endif /* JXLayoutDefines_h */
