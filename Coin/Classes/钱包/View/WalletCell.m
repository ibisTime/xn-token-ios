//
//  WalletCell.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "WalletCell.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"
#import "NSNumber+Extension.h"

@interface WalletCell ()
//币种图标
@property (nonatomic, strong) UIImageView *coinIV;
//币种名称
@property (nonatomic, strong) UILabel *currencyNameLbl;
//币种金额
@property (nonatomic, strong) UILabel *amountLbl;
//冻结金额
@property (nonatomic, strong) UILabel *freezingAmountLbl;

@end

@implementation WalletCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.backgroundColor = kClearColor;
    
    CGFloat leftMargin = 15;
    
    //背景
    UIView *whiteView = [[UIView alloc] init];
    
    whiteView.backgroundColor = kWhiteColor;
    
    [self addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(leftMargin));
        make.top.bottom.equalTo(@0);
        make.right.equalTo(@(-leftMargin));
        
    }];
    
    //币种图标
    self.coinIV = [[UIImageView alloc] init];
    
    [whiteView addSubview:self.coinIV];
    [self.coinIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-leftMargin));
        make.top.equalTo(@10);
        
    }];
    
    //币种名称
    self.currencyNameLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kThemeColor font:14.0];
    
    [whiteView addSubview:self.currencyNameLbl];
    [self.currencyNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(leftMargin));
        make.top.equalTo(@(leftMargin));
        
    }];
    
    //币种金额
    self.amountLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:24.0];
    
    [whiteView addSubview:self.amountLbl];
    [self.amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.currencyNameLbl.mas_left);
        make.top.equalTo(self.currencyNameLbl.mas_bottom).offset(12);
        
    }];
    
    //冻结金额
    self.freezingAmountLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
    
    [whiteView addSubview:self.freezingAmountLbl];
    [self.freezingAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.currencyNameLbl.mas_left);
        make.top.equalTo(self.amountLbl.mas_bottom).offset(13);
        
    }];
    
    //分割线
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kLineColor;
    
    [whiteView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.mas_bottom).offset(-40);
        
    }];
    
    //底部操作按钮
    NSArray *textArr = @[@"充币", @"提币", @"账单"];
    
    NSArray *imgArr = @[@"充币", @"提币", @"账单"];
    
    CGFloat btnW = (kScreenWidth - 2*leftMargin)/3.0;
    
    [textArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *btn = [UIButton buttonWithTitle:textArr[idx] titleColor:kTextColor backgroundColor:kClearColor titleFont:13.0];
        
        [btn setImage:kImage(imgArr[idx]) forState:UIControlStateNormal];
        
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        
        btn.tag = self.tag + idx;
                
        [whiteView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(idx*btnW));
            make.top.equalTo(self.mas_bottom).offset(-40);
            make.width.equalTo(@(btnW));
            make.height.equalTo(@(40));
            
        }];
        
        if (idx != 2) {
            
            UIView *vLine = [[UIView alloc] init];
            
            vLine.backgroundColor = kLineColor;
            
            [whiteView addSubview:vLine];
            [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(btn.mas_right);
                make.centerY.equalTo(btn.mas_centerY);
                make.width.equalTo(@0.5);
                make.height.equalTo(@20);
                
            }];
        }
        
        if (idx == 0) {
            
            self.rechargeBtn = btn;
            
        } else if (idx == 1) {
            
            self.withdrawalsBtn = btn;
            
        } else {
            
            self.billBtn = btn;
        }
        
    }];
    
}

- (void)setCurrency:(CurrencyModel *)currency {
    
    _currency = currency;
    
    self.currencyNameLbl.text = _currency.getTypeName;
    
    self.coinIV.image = kImage(_currency.getImgName);
    
    self.amountLbl.text = [_currency.amount convertToSimpleRealMoney];
    
    self.freezingAmountLbl.text = [NSString stringWithFormat:@"冻结 %@", [_currency.frozenAmount convertToSimpleRealMoney]];
    
}

@end
