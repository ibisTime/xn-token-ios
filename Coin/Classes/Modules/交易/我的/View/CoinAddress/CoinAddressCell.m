//
//  CoinAddressCell.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/28.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CoinAddressCell.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import "NSString+Extension.h"

#import <UIButton+WebCache.h>
#import "NSNumber+Extension.h"

@interface CoinAddressCell ()

//标签
@property (nonatomic, strong) UILabel *textLbl;
//认证状态
@property (nonatomic, strong) UILabel *statusLbl;
//地址
@property (nonatomic, strong) UILabel *addressLbl;

@end

@implementation CoinAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //图标
    UIView *iconView = [[UIView alloc] init];
    iconView.layer.borderWidth = 0.5;
    iconView.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
    [self.contentView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(@15);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        
    }];
    
    //address
    UILabel *addressTextLbl = [UILabel labelWithBackgroundColor:kThemeColor
                                                      textColor:kWhiteColor
                                                           font:9.0];
    addressTextLbl.text = @"Address";
    addressTextLbl.textAlignment = NSTextAlignmentCenter;
    [iconView addSubview:addressTextLbl];
    [addressTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@25);
        
    }];
    
    //Coin
    UILabel *coinTextLbl = [UILabel labelWithBackgroundColor:kWhiteColor
                                                   textColor:kTextColor
                                                        font:11.0];
    coinTextLbl.text = @"ETH";
    coinTextLbl.textAlignment = NSTextAlignmentCenter;
    [iconView addSubview:coinTextLbl];
    [coinTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.top.equalTo(addressTextLbl.mas_bottom);
        make.height.equalTo(@15);
        
    }];
    
    //地址状态
    self.statusLbl = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:kTextColor
                                                  font:15.0];
    self.statusLbl.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.statusLbl];
    [self.statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.width.equalTo(@50);
        
    }];
    
    //标签
    self.textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:16.0];
    self.textLbl.numberOfLines = 0;
    [self.contentView addSubview:self.textLbl];
    [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(iconView.mas_right).offset(10);
        make.right.equalTo(self.statusLbl.mas_left).offset(-10);
        
    }];
    
    //地址
    self.addressLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
    self.addressLbl.numberOfLines = 0;
    [self.contentView addSubview:self.addressLbl];
    [self.addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.textLbl.mas_bottom).offset(10);
        make.left.equalTo(self.textLbl.mas_left);
        
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        
    }];
    
    //分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kLineColor;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@(-0.5));
        make.height.equalTo(@0.5);
        
    }];
}

- (void)setAddressModel:(CoinAddressModel *)addressModel {
    
    _addressModel = addressModel;
    
    self.textLbl.text = addressModel.label;
    
    self.addressLbl.text = addressModel.address;
    
    self.statusLbl.text = [addressModel.status isEqualToString:@"0"] ? [LangSwitcher switchLang:@"未认证" key:nil]: [LangSwitcher switchLang:@"已认证" key:nil];
    
}

@end
