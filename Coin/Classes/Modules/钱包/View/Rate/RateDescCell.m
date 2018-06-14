//
//  RateDescCell.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "RateDescCell.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"
#import "NSString+Date.h"
#import "NSNumber+Extension.h"

@interface RateDescCell ()
//汇率
@property (nonatomic, strong) UIButton *rateLbl;
//左边国旗
@property (nonatomic, strong) UILabel *leftFlag;
//右边国旗
@property (nonatomic, strong) UIImageView *rightFlag;
//
@property (nonatomic, strong) UILabel *textLbl;

@end

@implementation RateDescCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        self.backgroundColor = kBackgroundColor;
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //汇率
    self.rateLbl = [UIButton buttonWithTitle:@"" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16];
    
//    self.rateLbl.textAlignment = NSTextAlignmentLeft;
//    self.rateLbl.backgroundColor = kAppCustomMainColor;
//    self.rateLbl.numberOfLines = 2;
    [self addSubview:self.rateLbl];
    self.rateLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.rateLbl.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//    self.rateLbl.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.rateLbl.layer.cornerRadius = 5;
    self.rateLbl.clipsToBounds = YES;
    [self.rateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.equalTo(@40);

        make.top.equalTo(@(10));
        
        
    }];
    
    //左边国旗
    self.leftFlag = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14.0];
    self.leftFlag.numberOfLines = 0;
    [self addSubview:self.leftFlag];
    [self.leftFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@20);
        make.top.equalTo(self.rateLbl.mas_bottom).offset(10);
        make.width.equalTo(@(kScreenWidth-40));

        
    }];
    
    self.rightFlag = [[UIImageView alloc] init];
    
    [self addSubview:self.rightFlag];
    self.rightFlag.contentMode = UIViewContentModeScaleToFill;
    self.rightFlag.image = kImage(@"已报名时间");
    [self.rightFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@20);
        make.top.equalTo(self.leftFlag.mas_bottom).offset(15);
        make.width.height.equalTo(@12);
        
        
    }];
    //计算规则
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:13.0];
    self.textLbl = textLbl;

    textLbl.numberOfLines = 0;
   
//    textLbl.text = [LangSwitcher switchLang:textLbl.text key:nil];
    [self addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.rightFlag.mas_right).offset(10);
        make.centerY.equalTo(self.rightFlag.mas_centerY).offset(0);

    }];
    
    UIView *line = [[UIView alloc] init];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.left.equalTo(@10);
        make.height.equalTo(@2);

    }];
    
    line.backgroundColor = kHexColor(@"#f8f8f8");
    
}

- (void)setRateModel:(RateModel *)rateModel {
    
    _rateModel = rateModel;
    
//    if ([rateModel.referCurrency isEqualToString:@"CNY"]) {
//
//    }
    [self.rateLbl setTitle:rateModel.smsTitle forState:UIControlStateNormal];
    self.rateLbl.enabled = NO;
    self.leftFlag.text = [NSString stringWithFormat:@"%@",rateModel.smsContent];
//    self.leftFlag.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",rateModel.imageName]];
    
    self.textLbl.text = [rateModel.pushedDatetime convertDate];
    
    [self layoutSubviews];
    
    rateModel.cellHeight = self.textLbl.yy+15;
    
}

@end
