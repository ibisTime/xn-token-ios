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
        
        
        array = @[[NSString stringWithFormat:@"%@%@",[LangSwitcher switchLang:@"总资产" key:nil],[TLUser user].localMoney],[NSString stringWithFormat:@"%@%@",[LangSwitcher switchLang:@"总收益" key:nil],[TLUser user].localMoney]];
        for (int i = 0; i < 2; i ++) {
            
            UILabel *priceLabel = [UILabel labelWithFrame:CGRectMake(i % 2 * SCREEN_WIDTH/2, 20, SCREEN_WIDTH/2, 16) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(16) textColor:[UIColor blackColor]];
            priceLabel.text = @"≈0.00";
            [self addSubview:priceLabel];
            
            UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(i % 2 * SCREEN_WIDTH/2, priceLabel.yy + 7.5, SCREEN_WIDTH/2, 12) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(12) textColor:kHexColor(@"#bfbfbf")];
            nameLabel.text = array[i];
            [self addSubview:nameLabel];
            
        }
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 0.5, 20, 1, 36)];
        lineView.backgroundColor = kLineColor;
        [self addSubview:lineView];
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(15, 75, SCREEN_WIDTH - 30, 1)];
        lineView1.backgroundColor = kLineColor;
        [self addSubview:lineView1];
        
        
        
    }
    return self;
}

@end
