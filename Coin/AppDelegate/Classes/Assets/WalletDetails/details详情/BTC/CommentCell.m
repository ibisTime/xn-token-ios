//
//  CommentCell.m
//  Coin
//
//  Created by shaojianfei on 2018/8/13.
//  Copyright © 2018年 chengdai. All rights reserved.
//
#import "TLUIHeader.h"
#import "CommentCell.h"
@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        //
        self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14.0];
        
        [self.contentView addSubview:self.titleLbl];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(15);
            //            make.width.equalTo(@60);
            make.top.equalTo(self.contentView.mas_top).offset(5);
            
//            make.right.equalTo(self.mas_right).offset(-55);

            
        }];
        
        self.rightLabel = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14.0];

        self.rightLabel.textAlignment = NSTextAlignmentLeft;
        self.rightLabel.numberOfLines = 0;
        [self.contentView addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {

            make.left.equalTo(self.titleLbl.mas_left);

            make.top.equalTo(self.titleLbl.mas_bottom).offset(4);

        }];

    }
    
    return self;
}

- (void)setUtModel:(utxoModel *)utModel
{
    _utModel = utModel;
    NSString *money;

    if (![utModel.value valid]) {
        money = [LangSwitcher switchLang:@"正在打包中,即将到账" key:nil];

    }else{
//        money = [CoinUtil convertToRealCoin:utModel.value coin:@"BTC"];

    }
//    NSString *money = [CoinUtil convertToRealCoin:utModel.value coin:@"BTC"];
    self.titleLbl.text = utModel.addr;
    
//    self.rightLabel.text = [NSString stringWithFormat:@"%@ BTC",utModel.value];
    self.rightLabel.text = [NSString stringWithFormat:@"%@ BTC",[CoinUtil convertToRealCoin:utModel.valueSat coin:@"BTC"]];
    if ([self.address isEqualToString:utModel.addr]) {
        self.titleLbl.textColor = kAppCustomMainColor;

        self.rightLabel.textColor = kAppCustomMainColor;
    }
}

@end
