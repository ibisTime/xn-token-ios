//
//  GuideTheFigureView.m
//  Coin
//
//  Created by 郑勤宝 on 2018/12/5.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "GuideTheFigureView.h"
#define CardWidth (SCREEN_WIDTH - 40)/2.3
@implementation GuideTheFigureView
{
    UIView *backView;
    UIImageView *boxImage;
    UIImageView *lineImg;
    UILabel *promptLbl1;
    
    UIImageView *directionImg;
    UIButton *iKonwBtn;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        imageView.image = kImage(@"引导图背景");
//        [self addSubview:imageView];
        
        backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.5;
        [self addSubview:backView];
        
//        (SCREEN_WIDTH - 40)/2.3 + 61 + 12 + 11 + 30)
        boxImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, kStatusBarHeight + (SCREEN_WIDTH - 40)/2.3 + 61 + 12 + 11 + 30, SCREEN_WIDTH - 30, 73.5)];
        boxImage.image = kImage(@"box");
        boxImage.backgroundColor = kWhiteColor;
//        boxImage.alpha = 0.5;
        [backView addSubview:boxImage];
        
        
        directionImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90, boxImage.yy + 5, 55, 50)];
        directionImg.image = kImage(@"手势(1)");
        [self addSubview:directionImg];
        
        lineImg = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(35), boxImage.yy + 5, kWidth(40), kHeight(65))];
        lineImg.image = kImage(@"LINE1");
        [self addSubview:lineImg];
        
        promptLbl1 = [UILabel labelWithFrame:CGRectMake(lineImg.xx + 10, lineImg.yy - 11, SCREEN_WIDTH - lineImg.xx - 10, 16) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:HGboldfont(16) textColor:kWhiteColor];
//        promptLbl1.text = [LangSwitcher switchLang:@"向左滑动，迅速打开/n充币、提币功能" key:nil];
        promptLbl1.attributedText = [UserModel ReturnsTheDistanceBetween:[NSString stringWithFormat:@"%@\n%@",[LangSwitcher switchLang:@"向左滑动，迅速打开" key:nil],[LangSwitcher switchLang:@"充币、提币功能" key:nil]]];
        promptLbl1.numberOfLines = 2;
        [promptLbl1 sizeToFit];
        [self addSubview:promptLbl1];
        
        iKonwBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"知道了" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:16];
        iKonwBtn.frame = CGRectMake(kWidth(115), promptLbl1.yy + 13, kWidth(90), kHeight(35));
        [iKonwBtn setBackgroundImage:kImage(@"btnBack") forState:(UIControlStateNormal)];
        iKonwBtn.centerX = promptLbl1.centerX;
        [iKonwBtn addTarget:self action:@selector(iKonwBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:iKonwBtn];
    }
    return self;
}

-(void)iKonwBtnClick
{
//    [UIView animateWithDuration:0.5 animations:^{
//
//    }];
    boxImage.hidden = YES;
    lineImg.hidden = YES;
    promptLbl1.hidden = YES;
    iKonwBtn.hidden = YES;
    directionImg.hidden = YES;
    
//    iconBtn.frame = CGRectMake(31 + i % 3 * (40 + 30), 61  + CardWidth + 11 + kStatusBarHeight - 5, 40, 40);
    
    UIImageView *squareBoxImg = [[UIImageView alloc]initWithFrame:CGRectMake(31 + 0 % 3 * (40 + 30) - 10, 61 + CardWidth + 11 + kStatusBarHeight - 10, 50, 50)];
    squareBoxImg.backgroundColor = kWhiteColor;
    squareBoxImg.image = kImage(@"引导图框");
//    squareBoxImg.alpha = 0.5;
    [backView addSubview:squareBoxImg];
    
    UIImageView *squareBoxImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(31- 10 + 1 % 3 * (40 + 30), 61 + CardWidth + 11 + kStatusBarHeight- 10, 50, 50)];
    squareBoxImg1.backgroundColor = kWhiteColor;
    squareBoxImg1.image = kImage(@"引导图框");
//    squareBoxImg1.alpha = 0.5;
    [backView addSubview:squareBoxImg1];
    
    UIImageView *squareBoxImg2 = [[UIImageView alloc]initWithFrame:CGRectMake(31- 10 + 2 % 3 * (40 + 30), 61 + CardWidth + 11 + kStatusBarHeight- 10, 50, 50)];
    squareBoxImg2.backgroundColor = kWhiteColor;
    squareBoxImg2.image = kImage(@"引导图框");
//    squareBoxImg2.alpha = 0.5;
    [backView addSubview:squareBoxImg2];
    
    UIImageView *lineView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, squareBoxImg.yy + 5, 1, 20)];
    lineView1.image = kImage(@"矩形4拷贝");
    lineView1.centerX = squareBoxImg.centerX;
    
    [self addSubview:lineView1];
    
    UIImageView *lineView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, squareBoxImg1.yy + 5, 1, 20)];
    lineView2.image = kImage(@"矩形4拷贝");
    lineView2.centerX = squareBoxImg1.centerX;
    [self addSubview:lineView2];
    
    UIImageView *lineView3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, squareBoxImg2.yy + 5, 1, 20)];
    lineView3.image = kImage(@"矩形4拷贝");
    lineView3.centerX = squareBoxImg2.centerX;
    [self addSubview:lineView3];
    
    UILabel *nameLabel1 = [UILabel labelWithFrame:CGRectMake(0, lineView1.yy + 5.5, kWidth(80), 16) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(15) textColor:kWhiteColor];
    nameLabel1.text = [LangSwitcher switchLang:@"通讯录" key:nil];
    
    nameLabel1.numberOfLines = 0;
    [nameLabel1 sizeToFit];
    nameLabel1.centerX = squareBoxImg.centerX;
    [self addSubview:nameLabel1];
    
    UILabel *nameLabel2 = [UILabel labelWithFrame:CGRectMake(0, lineView2.yy + 5.5, kWidth(80), 16) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(15) textColor:kWhiteColor];
    nameLabel2.text = [LangSwitcher switchLang:@"一键划转" key:nil];

    nameLabel2.numberOfLines = 0;
    [nameLabel2 sizeToFit];
    nameLabel2.centerX = squareBoxImg1.centerX;
    [self addSubview:nameLabel2];
    
    UILabel *nameLabel3 = [UILabel labelWithFrame:CGRectMake(0, lineView3.yy + 5.5, kWidth(80), 16) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(15) textColor:kWhiteColor];
    nameLabel3.text = [LangSwitcher switchLang:@"闪兑" key:nil];
    
    nameLabel3.numberOfLines = 0;
    [nameLabel3 sizeToFit];
    nameLabel3.centerX = squareBoxImg2.centerX;
    [self addSubview:nameLabel3];
    
    _iKonwBtn1 = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"知道了" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:16];
    _iKonwBtn1.frame = CGRectMake(kWidth(115), nameLabel2.yy + 13, kWidth(90), kHeight(35));
    [_iKonwBtn1 setBackgroundImage:kImage(@"btnBack") forState:(UIControlStateNormal)];
    _iKonwBtn1.centerX = nameLabel2.centerX;
    [_iKonwBtn1 addTarget:self action:@selector(iKonwBtnClick1) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_iKonwBtn1];
    
    
    
}

-(void)iKonwBtnClick1
{
//    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    [self removeFromSuperview];
    [[UserModel user].cusPopView dismiss];
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"GUIDETHEDFIGURE"];
}

@end
