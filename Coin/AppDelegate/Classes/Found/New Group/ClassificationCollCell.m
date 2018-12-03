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
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *array = @[@"游戏类",@"工具类",@"咨询类"];
        for (int i = 0; i < 3; i ++) {
            UIButton *ClassificationBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:array[i] key:nil] titleColor:kHexColor(@"#acacac") backgroundColor:kClearColor titleFont:16];
            ClassificationBtn.frame = CGRectMake(10 + i % 3 * 106, 5, 100, 40);
            [ClassificationBtn setBackgroundImage:kImage(@"按钮类型背景") forState:(UIControlStateSelected)];
            [ClassificationBtn setBackgroundImage:kImage(@"按钮类型背景灰色") forState:(UIControlStateNormal)];
            [ClassificationBtn setTitleColor:kWhiteColor forState:(UIControlStateSelected)];
            if (i == 0) {
                ClassificationBtn.selected = YES;
                selectBtn = ClassificationBtn;
            }
            [ClassificationBtn addTarget:self action:@selector(ClassificationBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
            ClassificationBtn.tag = 200 + i;
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
}

@end
