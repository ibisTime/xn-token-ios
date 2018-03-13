//
//  SettingCell.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "SettingCell.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

@interface SettingCell ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UIImageView *accessoryImageView;

@end

@implementation SettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconImageView];
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@20);
            make.height.equalTo(@20);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(20);
            
        }];
        
        //右边箭头
        self.accessoryImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.accessoryImageView];
        [self.accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@7);
            make.height.equalTo(@12);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            
        }];
        self.accessoryImageView.image = [UIImage imageNamed:@"更多-灰色"];
        
        self.rightLabel = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14.0];
        
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.accessoryImageView.mas_left).offset(-10);
            make.centerY.equalTo(@0);
            
        }];
        
        //
        self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14.0];
        
        [self.contentView addSubview:self.titleLbl];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(20);
            
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.lessThanOrEqualTo(self.accessoryImageView.mas_left);
        }];
        //开关
        UISwitch *sw = [[UISwitch alloc] init];
        
        [self addSubview:sw];
        [sw mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(@(-15));
            make.centerY.equalTo(@0);
            
        }];
        
        self.sw = sw;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kLineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.width.equalTo(self.mas_width);
            make.height.equalTo(@(kLineHeight));
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    return self;
    
}

- (void)setSettingModel:(SettingModel *)settingModel {
    
    self.iconImageView.image = [UIImage imageNamed:settingModel.imgName];
    self.titleLbl.text = settingModel.text;
    
}

- (void)setArrowHidden:(BOOL)arrowHidden {
    
    _arrowHidden = arrowHidden;
    
    _accessoryImageView.hidden = _arrowHidden;
    
}

- (void)setSwitchHidden:(BOOL)switchHidden {
    
    _switchHidden = switchHidden;
    
    _sw.hidden = switchHidden;
    
}

@end
