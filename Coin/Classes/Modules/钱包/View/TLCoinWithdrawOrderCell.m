//
//  TLCoinWithdrawOrderCell.m
//  Coin
//
//  Created by  tianlei on 2018/1/17.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TLCoinWithdrawOrderCell.h"
#import "UILable+convience.h"
#import "UIColor+theme.h"
#import "TLUIHeader.h"
#import "CoinUtil.h"
#import "TLCoinWithdrawModel.h"
#import "NSString+Extension.h"
#import "NSString+Date.h"

@interface TLCoinWithdrawOrderCell()

//提现金额
@property (nonatomic, strong) UILabel *coinCountLbl;

//提现币种
//@property (nonatomic, strong) UILabel *coinTypelbl;

//提现手续费
@property (nonatomic, strong) UILabel *feelbl;

//提现状态
@property (nonatomic, strong) UILabel *statusLbl;

//提现时间
@property (nonatomic, strong) UILabel *applyTimeLbl;

@property (nonatomic, strong) UILabel *toAddressLbl;

@end

@implementation TLCoinWithdrawOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.coinCountLbl = [UILabel labelWithFrame:CGRectZero
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor whiteColor]
                                              font:[UIFont systemFontOfSize:14]
                                         textColor:[UIColor textColor]];
        [self.contentView addSubview:self.coinCountLbl];
        
        //
//        self.coinTypelbl = [UILabel labelWithFrame:CGRectZero
//                                      textAligment:NSTextAlignmentLeft
//                                   backgroundColor:[UIColor whiteColor]
//                                              font:[UIFont systemFontOfSize:14]
//                                         textColor:[UIColor themeColor]];
//        [self.contentView addSubview:self.coinTypelbl];
        
        //
        self.feelbl = [UILabel labelWithFrame:CGRectZero
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor whiteColor]
                                              font:[UIFont systemFontOfSize:14]
                                         textColor:[UIColor textColor]];
        [self.contentView addSubview:self.feelbl];
        
        //状态
        self.statusLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentLeft
                              backgroundColor:[UIColor whiteColor]
                                         font:[UIFont systemFontOfSize:14]
                                    textColor:[UIColor themeColor]];
        [self.contentView addSubview:self.statusLbl];
        
        //
        self.applyTimeLbl = [UILabel labelWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor whiteColor]
                                            font:[UIFont systemFontOfSize:14]
                                       textColor:[UIColor textColor]];
        [self.contentView addSubview:self.applyTimeLbl];
        
        //提币到哪个地址
        self.toAddressLbl = [UILabel labelWithFrame:CGRectZero
                                       textAligment:NSTextAlignmentLeft
                                    backgroundColor:[UIColor whiteColor]
                                               font:[UIFont systemFontOfSize:14]
                                          textColor:[UIColor textColor]];
        [self.contentView addSubview:self.toAddressLbl];
        self.toAddressLbl.numberOfLines = 0;
        self.toAddressLbl.lineBreakMode = NSLineBreakByCharWrapping;
        
        //
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(0.7);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        
        [self addLayout];
    }
    return self;
    
}

- (void)addLayout {
    
    //左边
    [self.coinCountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];
    
    [self.feelbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.coinCountLbl.mas_left);
        make.top.equalTo(self.coinCountLbl.mas_bottom).offset(10);
        
    }];
    
    //右边
    [self.statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.coinCountLbl.mas_top);
        
    }];
    
    [self.applyTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.statusLbl.mas_right);
        make.top.equalTo(self.statusLbl.mas_bottom).offset(10);
    }];
    
    [self.toAddressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.feelbl.mas_left);
        make.right.equalTo(self.statusLbl.mas_right);
        make.top.equalTo(self.applyTimeLbl.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);

    }];

}

- (void)setWithdrawModel:(TLCoinWithdrawModel *)withdrawModel {
    
    _withdrawModel = withdrawModel;
   
    
    NSString *countStr = [CoinUtil convertToRealCoin: _withdrawModel.amountString
                                                coin:_withdrawModel.channelType];
    
    NSString *normalCountStr = [NSString stringWithFormat:@"提币金额：%@ %@",countStr,_withdrawModel.channelType];
    self.coinCountLbl.attributedText = [self attrStrLeftLen:5 str:normalCountStr];
    
    //
    NSString *feeStr = [CoinUtil convertToRealCoin: _withdrawModel.feeString
                                             coin:_withdrawModel.channelType];
    
    NSString *feeNormalStr =  [NSString stringWithFormat:@"手续费：%@ %@",feeStr,_withdrawModel.channelType];
    self.feelbl.attributedText = [self attrStrLeftLen:4 str:feeNormalStr];
    
    //
    NSString *toAddressStr = [NSString stringWithFormat:@"提现地址：%@",_withdrawModel.payCardNo];
    self.toAddressLbl.attributedText = [self attrStrLeftLen:5 str:toAddressStr];;
    
    //
    self.statusLbl.text = [_withdrawModel statusName];
    self.applyTimeLbl.text = [NSString stringWithFormat:@"%@",[_withdrawModel.applyDatetime convertToDetailDate]];
    
}

- (NSMutableAttributedString *)attrStrLeftLen:(NSInteger)len str:(NSString *)str {
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor themeColor] range:NSMakeRange(len, str.length - len)];
    
    return attrStr;
    
}

@end
