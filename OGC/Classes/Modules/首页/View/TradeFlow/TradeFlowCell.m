//
//  TradeFlowCell.m
//  OGC
//
//  Created by 蔡卓越 on 2018/3/14.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TradeFlowCell.h"
//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
#import "CoinUtil.h"
#import "NSString+Extension.h"

@interface TradeFlowCell()
//哈希
@property (nonatomic, strong) UILabel *codeLbl;
//from
@property (nonatomic, strong) UILabel *fromLbl;
//to
@property (nonatomic, strong) UILabel *toLbl;
//时间
@property (nonatomic, strong) UILabel *timeLbl;
//金额
@property (nonatomic, strong) UILabel *amountLbl;

@end

@implementation TradeFlowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"交易流水")];
    
    [self addSubview:iconIV];
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@15);
        make.width.equalTo(@11);
        make.height.equalTo(@13);
    }];
    //时间
    self.timeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor2
                                                font:15.0];
    [self addSubview:self.timeLbl];
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.centerY.equalTo(iconIV.mas_centerY);
        make.width.equalTo(@150);
    }];
    
    //哈希
    self.codeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor
                                                font:15.0];
    [self addSubview:self.codeLbl];
    [self.codeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconIV.mas_right).offset(10);
        make.centerY.equalTo(iconIV.mas_centerY);
        make.right.equalTo(self.timeLbl.mas_left).offset(-10);
    }];
    
    //from
    UILabel *fromTextLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                                  textColor:kAppCustomMainColor
                                                                       font:15.0];
    fromTextLbl.text = @"From";
    
    [self addSubview:fromTextLbl];
    [fromTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.codeLbl.mas_left);
        make.top.equalTo(self.codeLbl.mas_bottom).offset(12);
        make.width.equalTo(@40);
    }];
    self.fromLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor
                                                font:15.0];
    self.fromLbl.numberOfLines = 0;
    
    [self addSubview:self.fromLbl];
    [self.fromLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(fromTextLbl.mas_right).offset(10);
        make.top.equalTo(fromTextLbl.mas_top);
        make.right.equalTo(@(-15));
    }];
    //to
    UILabel *toTextLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kAppCustomMainColor
                                                        font:15.0];
    toTextLbl.text = @"To";
    
    [self addSubview:toTextLbl];
    [toTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.codeLbl.mas_left);
        make.top.equalTo(self.fromLbl.mas_bottom).offset(10);
        make.width.equalTo(@40);
    }];
    
    self.toLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor
                                                font:15.0];
    self.toLbl.numberOfLines = 0;

    [self addSubview:self.toLbl];
    [self.toLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.fromLbl.mas_left);
        make.top.equalTo(toTextLbl.mas_top);
        make.right.equalTo(@(-15));
    }];
    //金额
    self.amountLbl = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:kTextColor
                                                  font:12.0];
    
    [self addSubview:self.amountLbl];
    [self.amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.codeLbl.mas_left);
        make.top.equalTo(self.toLbl.mas_bottom).offset(12);
    }];
    
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
    
}

#pragma mark - Setting
- (void)setFlow:(TradeFlowModel *)flow {
    
    _flow = flow;

    _codeLbl.text = flow.code;
    _fromLbl.text = flow.tokenFrom;
    _toLbl.text = flow.tokenTo;
    _timeLbl.text = flow.creates;
    NSString *amount = [CoinUtil convertToRealCoin:flow.tokenValue
                                              coin:kOGC];
    _amountLbl.text = [NSString stringWithFormat:@"%@ %@", amount, kOGC];
    [self layoutSubviews];
    //
    flow.cellHeight = self.amountLbl.yy + 13;
    
}

@end
