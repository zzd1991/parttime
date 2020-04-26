//
//  JXShouYeTableViewCell.m
//  JiXuJianZhi
//
//  Created by John Mr on 2020/4/26.
//  Copyright © 2020 oneteam. All rights reserved.
//

#import "JXShouYeTableViewCell.h"


@interface JXShouYeTableViewCell()

//@property(nonatomic,strong)XMMatchInfoModel             *model;

@property(nonatomic,strong)UIImageView         *jipinImgView;
@property(nonatomic,strong)UILabel             *locationLabel;
@property(nonatomic,strong)UILabel             *jobLabel;
@property(nonatomic,strong)UILabel             *jobTitleLabel;
@property(nonatomic,strong)UILabel             *moneyLabel;
@property(nonatomic,strong)UIImageView         *photoImgView;
@property(nonatomic,strong)UILabel             *positionLabel;

@end


@implementation JXShouYeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self initView];
        [self layoutUI];
    }
    return self;
}

- (void)setGetJobModel:(JXGetJobModel *)getJobModel
{
    _getJobModel = getJobModel;
    self.locationLabel.text = _getJobModel.address;
    self.jobLabel.text      = _getJobModel.jobs;
    self.jobTitleLabel.text = _getJobModel.title;
    self.moneyLabel.text    = _getJobModel.price;
    self.positionLabel.text = [NSString stringWithFormat:@"%@ | %@",_getJobModel.name,_getJobModel.position];

}

-(void)initView{
    [self.contentView addSubview:self.jipinImgView];
    [self.contentView addSubview:self.locationLabel];
    [self.contentView addSubview:self.jobLabel];
    [self.contentView addSubview:self.jobTitleLabel];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.positionLabel];
}

-(void)layoutUI{
    [self.jipinImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(JX_XX_11(15));
        make.top.equalTo(self.contentView).offset(JX_XX_11(22));
    }];
    
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jipinImgView.mas_right).offset(JX_XX_11(4));
        make.top.mas_equalTo(JX_XX_11(20));
    }];
    
    [self.jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-JX_XX_11(15));
        make.top.mas_equalTo(JX_XX_11(20));
    }];
    
    [self.jobTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(JX_XX_11(15));
        make.top.mas_equalTo(JX_XX_11(46));
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-JX_XX_11(15));
        make.top.mas_equalTo(JX_XX_11(46));
    }];
    
    [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(JX_XX_11(44));
        make.top.mas_equalTo(JX_XX_11(92));
    }];

}

#pragma mark - lazy

-(UIImageView *)jipinImgView {
    if (!_jipinImgView) {
        _jipinImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_Worry"]];
    }
    return _jipinImgView;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textColor = JX_UIColorFromHEX(0x666666);
        _locationLabel.font = JX_Default_Font(12);
        _locationLabel.text = @"河北省邯郸市邯山区桃园路38号";
    }
    return _locationLabel;
}

- (UILabel *)jobLabel {
    if (!_jobLabel) {
        _jobLabel = [[UILabel alloc] init];
        _jobLabel.textColor = JX_UIColorFromHEX(0x666666);
        _jobLabel.font = JX_Default_Font(12);
        _jobLabel.text = @"销售";
    }
    return _jobLabel;
}

- (UILabel *)jobTitleLabel {
    if (!_jobTitleLabel) {
        _jobTitleLabel = [[UILabel alloc] init];
        _jobTitleLabel.textColor = JX_UIColorFromHEX(0x333333);
        _jobTitleLabel.font = JX_Default_Font(16);
        _jobTitleLabel.text = @"兼职海报张贴员10人";
    }
    return _jobTitleLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = JX_UIColorFromHEX(0xFA6400);
        _moneyLabel.font = JX_Default_Font(16);
        _moneyLabel.text = @"300元/天";
    }
    return _moneyLabel;
}

-(UIImageView *)photoImgView {
    if (!_photoImgView) {
        _photoImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_Worry"]];
    }
    return _photoImgView;
}

- (UILabel *)positionLabel {
    if (!_positionLabel) {
        _positionLabel = [[UILabel alloc] init];
        _positionLabel.textColor = JX_UIColorFromHEX(0x666666);
        _positionLabel.font = JX_Default_Font(12);
        _positionLabel.text = @"Edward Nichols丨经理";
    }
    return _positionLabel;
}

@end
