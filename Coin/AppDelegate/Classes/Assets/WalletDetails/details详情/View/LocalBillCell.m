//
//  LocalBillCell.m
//  Coin
//
//  Created by shaojianfei on 2018/6/15.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "LocalBillCell.h"

@interface  LocalBillCell()

@property (nonatomic, strong) UIImageView *iconIV;

@property (nonatomic,strong) UILabel *moneyLbl;

@property (nonatomic,strong) UILabel *detailLbl;

//@property (nonatomic, strong) UILabel *dayLbl;

@property (nonatomic,strong) UILabel *timeLbl;
@property (nonatomic,strong) UILabel *introduceLab;

@end


@implementation LocalBillCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.iconIV = [[UIImageView alloc] init];
        self.iconIV.contentMode = UIViewContentModeScaleAspectFill;
        self.iconIV.layer.cornerRadius = 15;
        self.iconIV.clipsToBounds = YES;
        [self addSubview:self.iconIV];
        [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_top).offset(20);
            make.left.equalTo(self.mas_left).offset(15);
            make.width.height.equalTo(@30);
            
        }];
        
        //备注
        self.detailLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor clearColor]
                                            font:Font(14)
                                       textColor:kTextBlack];
        self.detailLbl.numberOfLines = 0;
//        self.detailLbl.height = [FONT(14) lineHeight];
        [self addSubview:self.detailLbl];
        
        [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(15);
            make.left.equalTo(self.iconIV.mas_right).offset(15);
            make.width.equalTo(@(kScreenWidth - 130));
            make.height.equalTo(@(14));
            //            make.right.equalTo(rightArrowIV.mas_left).offset(-15);
            
        }];

        self.timeLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:Font(12.0)
                                     textColor:kTextColor2];
        [self addSubview:self.timeLbl];
        
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.detailLbl.mas_bottom).offset(2);
            make.left.equalTo(self.iconIV.mas_right).offset(15);
            make.height.equalTo(@(14));
           
        }];
        
       
       
        //钱
        self.moneyLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor clearColor]
                                           font:Font(16.0)
                                      textColor:kTextColor];
//        self.moneyLbl.height = [Font(17.0) lineHeight];
        [self addSubview:self.moneyLbl];
        [self.moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_right).offset(-15);
            make.top.equalTo(@(15));
            
        }];
        
        self.introduceLab = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor clearColor]
                                            font:Font(12)
                                       textColor:kTextColor3];
        self.introduceLab.numberOfLines = 0;
        [self addSubview:self.introduceLab];
        
        [self.introduceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeLbl.mas_bottom).offset(2);
            make.left.equalTo(self.iconIV.mas_right).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.equalTo(@(14));
        }];
       
        
        UIView *line = [[UIView alloc] init];
        
        line.backgroundColor = kLineColor;
        
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.equalTo(@(1));
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
    
}

- (void)setBillModel:(BillModel *)billModel {
    
    _billModel = billModel;
    if ([billModel.direction isEqualToString:@"1"]) {
        self.moneyLbl.textColor = kHexColor(@"#47D047");
        NSString *countStr = [CoinUtil convertToRealCoin:_billModel.value
                                                    coin:self.currencyModel.symbol];
        if (![_billModel.value valid]) {
            self.moneyLbl.text = [NSString stringWithFormat:@"%@%@%@",countStr,self.currencyModel.symbol,[LangSwitcher switchLang:@"即将到账" key:nil]];

        }else{
            if ([_billModel.height isEqualToString:@"-1"]) {
                self.moneyLbl.text = [NSString stringWithFormat:@"%@%@%@",countStr,self.currencyModel.symbol,[LangSwitcher switchLang:@"即将到账" key:nil]];
            }else{
                
                NSString *countStr = [CoinUtil convertToRealCoin:_billModel.value
                                                            coin:self.currencyModel.symbol];
                self.moneyLbl.text = [NSString stringWithFormat:@"+%@ %@",countStr , self.currencyModel.symbol];
            }
          

        }
        
        self.introduceLab.text = [NSString stringWithFormat:@"%@",billModel.from];
        if ([self.currencyModel.symbol isEqualToString:@"BTC"]) {
            self.introduceLab.text = [NSString stringWithFormat:@"%@",billModel.txHash];

        }
        
    } else
    {
        
        self.moneyLbl.textColor = kHexColor(@"#FE4F4F");
        if (![_billModel.value valid]) {
            self.moneyLbl.text = [NSString stringWithFormat:@"%@",[LangSwitcher switchLang:@"同步打包中" key:nil]];
            
        }else{
            
            if ([_billModel.height isEqualToString:@"-1"]) {
                self.moneyLbl.text = [NSString stringWithFormat:@"%@",[LangSwitcher switchLang:@"同步打包中" key:nil]];
                
            }else{
                NSString *countStr = [CoinUtil convertToRealCoin:_billModel.value
                                                            coin:self.currencyModel.symbol];
                if ([countStr isEqualToString:@"0"]) {
                    self.moneyLbl.text = [NSString stringWithFormat:@"%@ %@", countStr, self.currencyModel.symbol];

                }else{
                    self.moneyLbl.text = [NSString stringWithFormat:@"-%@ %@", countStr, self.currencyModel.symbol];

                }

            }
  
        }
         self.introduceLab.text = [NSString stringWithFormat:@"%@",billModel.to];
        if ([self.currencyModel.symbol isEqualToString:@"BTC"]) {
            self.introduceLab.text = [NSString stringWithFormat:@"%@",billModel.txHash];
            
        }
    }
    self.timeLbl.text = [_billModel.transDatetime convertRedDate];
    
    if ([billModel.direction isEqualToString:@"0"]) {
        
        NSString *countStr = [CoinUtil convertToRealCoin:_billModel.value
                                                    coin:self.currencyModel.symbol];
        if ([countStr isEqualToString:@"0"]) {
            self.detailLbl.text = [LangSwitcher switchLang:@"执行合约"key:nil]; ;

        }else{
            self.detailLbl.text = [LangSwitcher switchLang:[NSString stringWithFormat:@"转账"] key:nil]; ;

        }
        self.iconIV.image = kImage(@"转账");


    }else
    {
         self.detailLbl.text = [LangSwitcher switchLang:[NSString stringWithFormat:@"收款"] key:nil]; ;
        self.iconIV.image  = kImage(@"收款");

    }
    [self layoutSubviews];
    _billModel.dHeightValue = self.detailLbl.frame.size.height == 1 ? 0: self.detailLbl.height;
    
}


-(void)setUsdtModel:(USDTRecordModel *)usdtModel
{
    self.introduceLab.text = [NSString stringWithFormat:@"%@",usdtModel.txid];
    self.timeLbl.text = [self UTCchangeDate:usdtModel.blockTime];
    
    
    NSString *countStr = [CoinUtil convertToRealCoin:usdtModel.amount
                                                coin:self.currencyModel.symbol];
    
    if ([self.currencyModel.address isEqualToString:usdtModel.referenceAddress]) {
        self.detailLbl.text = [LangSwitcher switchLang:[NSString stringWithFormat:@"收款"] key:nil]; ;
        self.iconIV.image  = kImage(@"收款");
        self.moneyLbl.textColor = kHexColor(@"#47D047");
        self.moneyLbl.text = [NSString stringWithFormat:@"%@ %@", countStr, self.currencyModel.symbol];
    }else
    {
        self.detailLbl.text = [LangSwitcher switchLang:[NSString stringWithFormat:@"转账"] key:nil]; ;
        self.iconIV.image = kImage(@"转账");
        self.moneyLbl.textColor = kHexColor(@"#FE4F4F");
        self.moneyLbl.text = [NSString stringWithFormat:@"-%@ %@", countStr, self.currencyModel.symbol];
    }
}

-(NSString *)UTCchangeDate:(NSString *)utc{
    
    NSTimeInterval time = [utc doubleValue];
    
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"MM-dd HH:mm"];
    
    NSString *staartstr=[dateformatter stringFromDate:date];
    
    return staartstr;
    
}



@end
