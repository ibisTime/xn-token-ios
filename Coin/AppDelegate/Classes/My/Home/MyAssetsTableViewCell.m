//
//  MyAssetsTableViewCell.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/30.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "MyAssetsTableViewCell.h"

@implementation MyAssetsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *array;
//        NSString *localMoney;
        
        
        
        NSString *cnyStr;
        if ([[TLUser user].localMoney isEqualToString:@"USD"]) {
            cnyStr = @"（USD）";
        } else if ([[TLUser user].localMoney isEqualToString:@"KRW"])
        {
            cnyStr = @"（KRW）";
        }
        else{

            cnyStr = @"（CNY）";
        }
        
        
        
        array = @[[NSString stringWithFormat:@"%@%@",[LangSwitcher switchLang:@"总资产" key:nil],cnyStr],[NSString stringWithFormat:@"%@（BTC）",[LangSwitcher switchLang:@"总收益" key:nil]]];
        for (int i = 0; i < 2; i ++) {
            
            UILabel *priceLabel = [UILabel labelWithFrame:CGRectMake(i % 2 * SCREEN_WIDTH/2, 20, SCREEN_WIDTH/2, 16) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(16) textColor:[UIColor blackColor]];
            priceLabel.text = @"≈0.00";
            if (i == 0) {
                if ([TLUser isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"ALLPRICE"][@"allprice"]] == NO) {
                    priceLabel.text = [NSString stringWithFormat:@"≈%.2f",[[[NSUserDefaults standardUserDefaults] objectForKey:@"ALLPRICE"][@"allprice"] floatValue]];
                }
                self.allAssetsLabel = priceLabel;
            }else
            {
                self.earningsLabel = priceLabel;
            }
            [self addSubview:priceLabel];
            
            UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(i % 2 * SCREEN_WIDTH/2, priceLabel.yy + 7.5, SCREEN_WIDTH/2, 13) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(12) textColor:kHexColor(@"#bfbfbf")];
            nameLabel.text = array[i];
            [self addSubview:nameLabel];
            
        }
        
        
        
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 0.5, 20, 1, 36)];
        lineView.backgroundColor = kLineColor;
        [self addSubview:lineView];
        
        
        UILabel *promptLbl = [UILabel labelWithFrame:CGRectMake(0, lineView.yy + 10, SCREEN_WIDTH, 15) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(12) textColor:kHexColor(@"#0064ff")];
        promptLbl.text = [LangSwitcher switchLang:@"私钥账户未创建，显示部分资产" key:nil];
        [self addSubview:promptLbl];
        
        
        
        UIView *lineView1 = [[UIView alloc]init];
        lineView1.backgroundColor = kLineColor;
        [self addSubview:lineView1];
        
        if ([TLUser isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:MNEMONIC]] == YES) {
            promptLbl.hidden = NO;
            lineView1.frame = CGRectMake(15, 90, SCREEN_WIDTH - 30, 1);
        }
        else
        {
            promptLbl.hidden = YES;
            lineView1.frame = CGRectMake(15, 75, SCREEN_WIDTH - 30, 1);
        }
        
    }
    return self;
}

@end
