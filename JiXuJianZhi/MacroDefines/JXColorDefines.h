//
//  JXColorDefines.h
//  JiXuJianZhi
//
//  Created by John Mr on 2020/4/24.
//  Copyright © 2020 oneteam. All rights reserved.
//

#ifndef JXColorDefines_h
#define JXColorDefines_h


#define JX_UIColorFromHEX(rgbValue) \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                    blue:((float)(rgbValue & 0xFF))/255.0 \
                    alpha:1.0]

#define QL_RGBAlpha(r, g, b, a)    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define QL_RGB(r, g, b)                QL_RGBAlpha(r, g, b, 1.0)


// 定义emoji表情范围
#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);


#endif /* JXColorDefines_h */
