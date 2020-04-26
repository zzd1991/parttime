//
//  JXNoNetWorkView.m
//  JiXuJianZhi
//
//  Created by John Mr on 2020/4/24.
//  Copyright © 2020 oneteam. All rights reserved.
//

#import "JXNoNetWorkView.h"

@interface JXNoNetWorkView ()

@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation JXNoNetWorkView

#pragma mark - Life Cycle

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [self addSubview:self.contentImageView];
    [self addSubview:self.confirmBtn];
    [self addSubview:self.tipsLabel];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(JX_XX_11(142));
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentImageView.mas_bottom).offset(JX_XX_11(15));
        make.left.right.equalTo(self);
        make.height.mas_equalTo(JX_XX_11(14));
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(JX_XX_11(20));
        make.centerX.equalTo(self);
        make.width.mas_equalTo(JX_XX_11(115));
        make.height.mas_equalTo(JX_XX_11(44));
    }];
}

#pragma mark - Reponse

- (void)confirmBtnClick
{
    if (self.buttonClickBlock) {
        self.buttonClickBlock();
    }
}

#pragma mark - Setter And Getter

- (UIImageView *)contentImageView
{
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_connect_icon"]];
    }
    return _contentImageView;
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = JX_Default_Font(14);
        [_confirmBtn setTitleColor:JX_UIColorFromHEX(0xffffff) forState:UIControlStateNormal];
        _confirmBtn.layer.cornerRadius = JX_XX_11(22);
        _confirmBtn.clipsToBounds = YES;
        _confirmBtn.backgroundColor = JX_UIColorFromHEX(0x2F86F1);
        [_confirmBtn addTarget:self
                        action:@selector(confirmBtnClick)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textColor = JX_UIColorFromHEX(0x959698);
        _tipsLabel.font = JX_Default_Font(12);
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.text = @"网络出了小差，连接失败～";
    }
    return _tipsLabel;
}

- (void)setTips:(NSString *)tips
{
    _tips = tips;
    self.tipsLabel.text = tips;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.contentImageView.image = image;
}

- (void)setButtonTitle:(NSString *)buttonTitle
{
    _buttonTitle = buttonTitle;
    if (buttonTitle) {
        self.confirmBtn.hidden = NO;
        [self.confirmBtn setTitle:buttonTitle forState:UIControlStateNormal];
    } else {
        self.confirmBtn.hidden = YES;
    }
}

@end
