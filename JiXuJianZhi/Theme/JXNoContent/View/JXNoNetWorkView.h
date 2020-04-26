//
//  JXNoNetWorkView.h
//  JiXuJianZhi
//
//  Created by John Mr on 2020/4/24.
//  Copyright © 2020 oneteam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXNoNetWorkView : UIView

@property (nonatomic, strong) UIImageView *contentImageView;

/** tips */
@property (nonatomic, copy) NSString *tips;

/** buttonTitle */
@property (nonatomic, copy) NSString *buttonTitle;

/** image */
@property (nonatomic, strong) UIImage *image;

/** buttonClickBlock */
@property (nonatomic, copy) void (^buttonClickBlock)(void);

@property (nonatomic, strong) UIButton *confirmBtn;

@end

NS_ASSUME_NONNULL_END
