//
//  MyAdvertiseCell.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "MyAdvertiseCell.h"

#import "NSString+Extension.h"
#import <UIButton+WebCache.h>
#import "NSNumber+Extension.h"
#import "NSString+CGSize.h"

#import "PayTypeModel.h"

@interface MyAdvertiseCell ()

//头像
@property (nonatomic, strong) UIButton *photoBtn;
//昵称
@property (nonatomic, strong) UILabel *nameLbl;
//交易、好评跟信任
@property (nonatomic, strong) UILabel *dataLbl;
//支付方式
@property (nonatomic, strong) UILabel *payTypeLbl;
//限额
@property (nonatomic, strong) UILabel *limitAmountLbl;
//价格
@property (nonatomic, strong) UILabel *priceLbl;
//交易方式
@property (nonatomic, strong) UIButton *tradeTypeBtn;

@end

@implementation MyAdvertiseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //头像
    CGFloat imgWidth = 40;
    
    self.photoBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"" key:nil] titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:20 cornerRadius:imgWidth/2.0];
    
    //    [self.photoBtn addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    self.photoBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:self.photoBtn];
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@(15));
        make.width.height.equalTo(@(imgWidth));
        
    }];
    
    //昵称
    self.nameLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    [self addSubview:self.nameLbl];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(15);
        make.left.equalTo(self.photoBtn.mas_right).offset(10);
        
    }];
    
    //支付方式
    self.payTypeLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor clearColor]
                                         font:Font(11)
                                    textColor:kClearColor];
    self.payTypeLbl.layer.cornerRadius = 3;
    self.payTypeLbl.clipsToBounds = YES;
    
    [self addSubview:self.payTypeLbl];
    [self.payTypeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLbl.mas_top);
        make.width.equalTo(@32);
        make.height.equalTo(@18);
        make.left.equalTo(self.nameLbl.mas_right).offset(6);
        
    }];
    
    //交易、好评跟信任
    self.dataLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
    
    [self addSubview:self.dataLbl];
    [self.dataLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameLbl.mas_bottom).offset(10);
        make.left.equalTo(self.nameLbl.mas_left);
        
    }];
    
    //限额
    self.limitAmountLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
    
    [self addSubview:self.limitAmountLbl];
    [self.limitAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.top.equalTo(self.dataLbl.mas_bottom).offset(10);
        
    }];
    
    //价格
    self.priceLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kRiseColor font:15.0];
    
    [self addSubview:self.priceLbl];
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(@(15));
        
    }];
    
    //交易方式
    self.tradeTypeBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"" key:nil] titleColor:kClearColor backgroundColor:kClearColor titleFont:14.0 cornerRadius:5];
    
    [self addSubview:self.tradeTypeBtn];
    [self.tradeTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.priceLbl.mas_right);
        make.width.equalTo(@(44));
        make.height.equalTo(@(24));
        make.top.equalTo(self.priceLbl.mas_bottom).offset(14);
        
    }];
    
    //分割线
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kLineColor;
    
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@(-0.5));
        make.height.equalTo(@0.5);
        
    }];
    
}

- (void)setAdvertise:(AdvertiseModel *)advertise {
    
    _advertise = advertise;
    
    UserInfo *userInfo = advertise.user;
    
    UserStatistics *userStatist = advertise.userStatistics;
    
    //头像
    if (userInfo.photo) {
        
        [self.photoBtn setTitle:@"" forState:UIControlStateNormal];
        
        [self.photoBtn sd_setImageWithURL:[NSURL URLWithString:[userInfo.photo convertImageUrl]] forState:UIControlStateNormal];
        
    } else {
        
        NSString *nickName = userInfo.nickname;
        
        NSString *title = [nickName substringToIndex:1];
        
        [self.photoBtn setTitle:title forState:UIControlStateNormal];
        
        [self.photoBtn setImage:nil forState:UIControlStateNormal];
    }
    
    self.nameLbl.text = userInfo.nickname;
    
    //支付方式
    PayTypeModel *payModel = [PayTypeModel new];
    
    payModel.payType = advertise.payType;
    
    self.payTypeLbl.text = payModel.text;
    
    CGFloat payW = self.payTypeLbl.text.length*11 + 10;
    
    [self.payTypeLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(payW));
    }];
    
    self.payTypeLbl.textColor = payModel.color;
    
    self.payTypeLbl.layer.borderColor = payModel.color.CGColor;
    self.payTypeLbl.layer.borderWidth = 0.5;
    
    
    //交易、好评跟信任
    self.dataLbl.text = [LangSwitcher switchLang:[NSString stringWithFormat:@"交易 %ld · 好评 %@ · 信任 %ld", userStatist.jiaoYiCount, userStatist.goodCommentRate, userStatist.beiXinRenCount] key:nil];
    //限额
    self.limitAmountLbl.text = [NSString stringWithFormat:@"%@: %@-%@ CNY", [LangSwitcher switchLang:@"限额" key:nil],[advertise.minTrade convertToSimpleRealMoney], [advertise.maxTrade convertToSimpleRealMoney]];
    //价格
    
    self.priceLbl.text = [NSString stringWithFormat:@"%@ CNY", [advertise.truePrice convertToSimpleRealMoney]];
    
    UIColor *tradeColor = kThemeColor;
    
    //交易方式
    [self.tradeTypeBtn setTitleColor:tradeColor forState:UIControlStateNormal];
    
    [self.tradeTypeBtn setTitle:advertise.statusTitle forState:UIControlStateNormal];
    
    self.tradeTypeBtn.layer.borderColor = tradeColor.CGColor;
    self.tradeTypeBtn.layer.borderWidth = 0.5;
    
    CGFloat btnW = [NSString getWidthWithString:advertise.statusTitle font:14.0] + 10;
    
    [self.tradeTypeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(btnW));
        
    }];
    
}

@end
