//
//  FindTheGameHeadCell.m
//  Coin
//
//  Created by 郑勤宝 on 2018/12/4.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "FindTheGameHeadCell.h"

@implementation FindTheGameHeadCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 90, 90)];
        headImage.image =  kImage(@"起始业背景");
        kViewRadius(headImage, 6.5);
        [self addSubview:headImage];
        
        
        
        UIButton *actionBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"开始游戏" key:nil] titleColor:kHexColor(@"#0064ff") backgroundColor:kClearColor titleFont:14];
        [actionBtn sizeToFit];
        actionBtn.frame = CGRectMake(SCREEN_WIDTH - 20 - actionBtn.width - 30, 12 + 20, actionBtn.width + 30, 40);
        kViewBorderRadius(actionBtn, 6.5, 1, kHexColor(@"#0064ff"));
        [self addSubview:actionBtn];
        
        UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(headImage.xx + 15, 20, SCREEN_WIDTH - headImage.xx - actionBtn.width - 20 - 30, 18) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:HGboldfont(18) textColor:[UIColor blackColor]];
        nameLabel.text = @"游戏名称";
        [self addSubview:nameLabel];
        
        UILabel *provenance = [UILabel labelWithFrame:CGRectMake(headImage.xx + 15, nameLabel.yy + 11 , SCREEN_WIDTH - headImage.xx - actionBtn.width - 20 - 30, 12) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(12) textColor:[UIColor blackColor]];
        provenance.text = @"网友游戏出品";
        [self addSubview:provenance];
        
        
        for (int i = 0; i <2 ; i ++) {
            UILabel *theLabel = [UILabel labelWithFrame:CGRectMake(headImage.xx + 15 + i % 2 * 60, provenance.yy + 8 , 56, 24) textAligment:(NSTextAlignmentCenter) backgroundColor:RGB(247, 201, 84) font:FONT(12) textColor:kWhiteColor];
            theLabel.text = @"博彩类";
            kViewRadius(theLabel, 12);
            [self addSubview:theLabel];
            
        }
        NSArray *array = @[@"评分",@"下载量",@"成交量"];
        NSArray *numberArray = @[@"",@"6856",@"88553ETH/天"];
        for (int i = 0; i < 3 ; i ++) {
            UILabel *attributeLabel = [UILabel labelWithFrame:CGRectMake(i % 3 * SCREEN_WIDTH/3, headImage.yy + 26, SCREEN_WIDTH/3, 14) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(12) textColor:RGB(146, 146, 146)];
            attributeLabel.text = [LangSwitcher switchLang:array[i] key:nil];
            [self addSubview:attributeLabel];
            
            
            if (i != 0) {
                UILabel *numberLabel = [UILabel labelWithFrame:CGRectMake(i % 3 * SCREEN_WIDTH/3, headImage.yy + 50, SCREEN_WIDTH/3, 14) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#000000")];
                numberLabel.text = numberArray[i];
                [self addSubview:numberLabel];
            }
            
            
        }
        
        for (int i = 0; i < 5; i ++) {
            UIImageView *garyImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3/2 - 50 + 10 + i % 5 * 12, headImage.yy + 50 + 2, 10, 10)];
            garyImg.image = kImage(@"多边形灰色");
            [self addSubview:garyImg];
            
            if (i == 4) {
                UILabel *numberLabel = [UILabel labelWithFrame:CGRectMake(garyImg.xx + 4, headImage.yy + 50, 40, 14) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#000000")];
                numberLabel.text = @"(4.0)";
                [self addSubview:numberLabel];
            }
        }
    }
    return self;
}

@end
