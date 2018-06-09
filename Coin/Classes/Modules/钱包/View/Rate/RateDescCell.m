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

#import "NSNumber+Extension.h"

@interface RateDescCell ()
//汇率
@property (nonatomic, strong) UILabel *rateLbl;
//左边国旗
@property (nonatomic, strong) UIImageView *leftFlag;
//右边国旗
@property (nonatomic, strong) UIImageView *rightFlag;
//
@property (nonatomic, strong) UILabel *textLbl;

@end

@implementation RateDescCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        self.backgroundColor = kWhiteColor;
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //汇率
    self.rateLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:16.0];
    
    self.rateLbl.textAlignment = NSTextAlignmentLeft;
    self.rateLbl.numberOfLines = 2;
    [self addSubview:self.rateLbl];
    [self.rateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-130);

        make.top.equalTo(@(20));
        
        
    }];
    
    //左边国旗
    self.leftFlag = [[UIImageView alloc] init];
    self.leftFlag.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.leftFlag];
    [self.leftFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top).offset(10);
        make.width.equalTo(@115);
        make.height.equalTo(@70);

        
    }];
    

    //计算规则
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
    
    textLbl.numberOfLines = 0;
   
//    textLbl.text = [LangSwitcher switchLang:textLbl.text key:nil];
    [self addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.rateLbl.mas_left);
        make.bottom.equalTo(self.mas_bottom).offset(-20);

    }];
    
    UIView *line = [[UIView alloc] init];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.left.equalTo(@10);
        make.height.equalTo(@2);

    }];
    
    line.backgroundColor = kHexColor(@"#f8f8f8");
    self.textLbl = textLbl;
    
}

- (void)setRateModel:(RateModel *)rateModel {
    
    _rateModel = rateModel;
    
//    if ([rateModel.referCurrency isEqualToString:@"CNY"]) {
//
//    }
    self.rateLbl.text = rateModel.title;
    self.textLbl.text = [NSString stringWithFormat:@"%@ · %@",rateModel.time,rateModel.soure];
    self.leftFlag.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",rateModel.imageName]];
    

    
//    [self layoutSubviews];
    
//    rateModel.cellHeight = self.textLbl.yy;
    
}

@end
