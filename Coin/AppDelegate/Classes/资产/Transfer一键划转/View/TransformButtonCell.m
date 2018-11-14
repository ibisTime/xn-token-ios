//
//  TransformButtonCell.m
//  Coin
//
//  Created by 郑勤宝 on 2018/10/25.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "TransformButtonCell.h"

@implementation TransformButtonCell
{
    UILabel *_nameLabel;
    UIButton *selectButton;
    
    NSInteger selectRow;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = RGB(241, 242, 245);
//        selectRow = 0;
        
    }
    return self;
}

-(void)setModels:(NSMutableArray<CurrencyModel *> *)models
{
    for (int i = 0; i < models.count; i ++) {
        
        CoinModel *coin = [CoinUtil getCoinModel:models[i].currency];
        
        UIButton *backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        backButton.frame = CGRectMake(15 + i % 3 * ((SCREEN_WIDTH - 15)/3), 15 + i / 3 * 50, (SCREEN_WIDTH - 60)/3, 40);
//        backButton.backgroundColor = kWhiteColor;
        
        [backButton setBackgroundColor:kWhiteColor forState:(UIControlStateNormal)];
        [backButton setBackgroundColor:RGB(241, 242, 245) forState:(UIControlStateSelected)];
        if (i == 0) {
            backButton.selected = YES;
            selectButton = backButton;
        }
        
        kViewBorderRadius(backButton, 2, 1, kHexColor(@"#DEE0E5"));
        [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        backButton.tag = i;
        [self addSubview:backButton];
        
        self.photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 9, 22, 22)];
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:[coin.pic1 convertImageUrl]]];
        [backButton addSubview:self.photoImageView];
        
        _nameLabel = [UILabel labelWithFrame:CGRectMake(47, 0, (SCREEN_WIDTH - 60)/3 - 47, 40) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:[UIColor blackColor]];
        _nameLabel.text = models[i].currency;
        [backButton addSubview:_nameLabel];
        
    }
}

-(void)backButtonClick:(UIButton *)sender
{
//    selectRow = sender.tag;
    
    [_SelectDelegate SelectTheButton:sender];
    selectButton.selected = NO;
    sender.selected = !sender.selected;
    selectButton = sender;
    
    

}

@end
