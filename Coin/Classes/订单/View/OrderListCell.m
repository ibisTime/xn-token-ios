//
//  OrderListCell.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "OrderListCell.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import "NSString+Extension.h"
#import <UIButton+WebCache.h>
#import "NSNumber+Extension.h"

@interface OrderListCell ()

//头像
@property (nonatomic, strong) UIButton *photoBtn;
//昵称
@property (nonatomic, strong) UILabel *nameLbl;
//交易金额
@property (nonatomic, strong) UILabel *amountLbl;
//交易方式(购买/出售)
@property (nonatomic, strong) UILabel *tradeTypeLbl;
//订单状态
@property (nonatomic, strong) UILabel *statusLbl;
//编号
@property (nonatomic, strong) UILabel *orderCodeLbl;

@end

@implementation OrderListCell

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
    
    self.photoBtn = [UIButton buttonWithTitle:@"" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:20 cornerRadius:imgWidth/2.0];
    
    self.photoBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:self.photoBtn];
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(15));
        make.width.height.equalTo(@(imgWidth));
        make.centerY.equalTo(@0);
        
    }];
    
    //昵称
    self.nameLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:16.0];
    
    [self addSubview:self.nameLbl];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(15);
        make.left.equalTo(self.photoBtn.mas_right).offset(10);
        
    }];
    
    //交易方式
    self.tradeTypeLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor clearColor]
                                         font:Font(11)
                                    textColor:kClearColor];
    self.tradeTypeLbl.layer.cornerRadius = 3;
    self.tradeTypeLbl.clipsToBounds = YES;
    
    [self addSubview:self.tradeTypeLbl];
    [self.tradeTypeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLbl.mas_top);
        make.width.equalTo(@32);
        make.height.equalTo(@18);
        make.left.equalTo(self.nameLbl.mas_right).offset(6);
        
    }];
    
    //交易金额
    self.amountLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
    
    [self addSubview:self.amountLbl];
    [self.amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameLbl.mas_bottom).offset(10);
        make.left.equalTo(self.nameLbl.mas_left);
        
    }];
    
    //订单状态
    self.statusLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14.0];
    
    [self addSubview:self.statusLbl];
    [self.statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(@(15));
        
    }];
    
    //编号
    self.orderCodeLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
    
    [self addSubview:self.orderCodeLbl];
    
    [self.orderCodeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.statusLbl.mas_right);
        make.top.equalTo(self.statusLbl.mas_bottom).offset(10);
        
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

- (void)setOrder:(OrderModel *)order {
    
    _order = order;

    NSString *nickName = order.isBuy ? order.sellUserInfo.nickname: order.buyUserInfo.nickname;
    
    NSString *photo = order.isBuy ? order.sellUserInfo.photo: order.buyUserInfo.photo;
    
//    头像
    if (photo) {

        [self.photoBtn setTitle:@"" forState:UIControlStateNormal];

        [self.photoBtn sd_setImageWithURL:[NSURL URLWithString:[photo convertImageUrl]] forState:UIControlStateNormal];

    } else {

        NSString *title = [nickName substringToIndex:1];

        [self.photoBtn setTitle:title forState:UIControlStateNormal];

        [self.photoBtn setImage:nil forState:UIControlStateNormal];
    }

    self.nameLbl.text = nickName;

    //交易方式

    NSString *tradeText = order.isBuy ? @"购买": @"出售";

    UIColor *tradeColor = order.isBuy ? kPaleBlueColor: kThemeColor;

    self.tradeTypeLbl.text = tradeText;

    self.tradeTypeLbl.textColor = tradeColor;

    self.tradeTypeLbl.layer.borderColor = tradeColor.CGColor;
    self.tradeTypeLbl.layer.borderWidth = 0.5;
    
    
    //交易金额
    self.amountLbl.text = [NSString stringWithFormat:@"交易金额: %@CNY", [order.tradeAmount convertToRealMoneyWithNum:2]];
    
    //订单状态
    self.statusLbl.text = order.statusStr;
    
    //订单编号
    NSInteger count = order.code.length;
    
    NSString *code = [order.code substringFromIndex:count - 8];
    
    self.orderCodeLbl.text = [NSString stringWithFormat:@"编号: %@", code];
}

@end
