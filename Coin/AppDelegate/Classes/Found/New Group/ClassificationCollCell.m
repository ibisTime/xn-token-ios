//
//  ClassificationCollCell.m
//  Coin
//
//  Created by 郑勤宝 on 2018/12/3.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "ClassificationCollCell.h"

@implementation ClassificationCollCell
{
    UIButton *selectBtn;
    UIView *blueView;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
        lineView.backgroundColor = kBackgroundColor;
        [self addSubview:lineView];
        
        NSArray *array = @[@"游戏类",@"工具类",@"资讯类"];
        for (int i = 0; i < 3; i ++) {
            UIButton *ClassificationBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:array[i] key:nil] titleColor:kHexColor(@"#acacac") backgroundColor:kClearColor titleFont:16];
            
            ClassificationBtn.frame = CGRectMake(28 , 10, ClassificationBtn.width, 40);
            [ClassificationBtn setTitleColor:kHexColor(@"#0064ff") forState:(UIControlStateSelected)];
            [ClassificationBtn setTitleColor:kHexColor(@"#acacac") forState:(UIControlStateNormal)];
            ClassificationBtn.titleLabel.font = HGboldfont(16);
            if (i == 0) {
                ClassificationBtn.selected = YES;
                selectBtn = ClassificationBtn;
            }
            [ClassificationBtn addTarget:self action:@selector(ClassificationBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
            ClassificationBtn.tag = 200 + i;
            [ClassificationBtn sizeToFit];
            
            
            
            
            
            if (i == 0) {
                ClassificationBtn.frame = CGRectMake(28 , 10, ClassificationBtn.width, 40);
                
                
                blueView = [[UIView alloc]initWithFrame:CGRectMake(ClassificationBtn.centerX - 10, 16 + 16 + 6 + 10 - 1.5, 20, 3)];
                blueView.backgroundColor = kHexColor(@"#0064ff");
                [self addSubview:blueView];
                
            }else
            {
                UIButton *button = [self viewWithTag:200 + i - 1];
                ClassificationBtn.frame = CGRectMake(button.xx + 21 ,  10, ClassificationBtn.width, 40);
            }

            
            
            
            [self addSubview:ClassificationBtn];
            
            
            
        }
        
    }
    return self;
}

-(void)ClassificationBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    selectBtn.selected = !selectBtn.selected;
    selectBtn = sender;
    [_delegate ClassificationDelegateSelectBtn:sender.tag - 200];
    [UIView animateWithDuration:0.3 animations:^{
        blueView.frame = CGRectMake(sender.centerX - 10, 16 + 16 + 6 + 10 - 1.5, 20, 3);
    }];
}

@end
