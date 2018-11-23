//
//  AssetsHeadView.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/22.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "AssetsHeadView.h"
#define CardWidth (SCREEN_WIDTH - 40)/2.3
@implementation AssetsHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self announcement];
        [self initView];
        
    }
    return self;
}


-(void)announcement
{
    UIButton *announcementBackBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [announcementBackBtn setBackgroundColor:RGB(243, 243, 243) forState:(UIControlStateNormal)];
    announcementBackBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    [announcementBackBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    announcementBackBtn.tag = 100;
    [self addSubview:announcementBackBtn];
    
    
    UIButton *iconBtn = [UIButton buttonWithTitle:@"公告" titleColor:kHexColor(@"#0165ff") backgroundColor:kClearColor titleFont:12];
    iconBtn.frame = CGRectMake(12, 0, iconBtn.width, 50);
    [iconBtn sizeToFit];
    iconBtn.frame = CGRectMake(12, 0, iconBtn.width + 10, 50);
    [iconBtn SG_imagePositionStyle:(SGImagePositionStyleRight) spacing:2.5 imagePositionBlock:^(UIButton *button) {
        [button setImage:kImage(@"公告") forState:(UIControlStateNormal)];
    }];
    
    
    
    [self addSubview:iconBtn];
    
    UIImageView *youImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 12 - 7.5, 17.5, 7.5, 15)];
    youImg.image = kImage(@"更多");
    [self addSubview:youImg];
    
//    UIButton *announcementBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor grayColor] backgroundColor:kClearColor titleFont:12];
//    announcementBtn.frame = CGRectMake(iconBtn.xx + 10, 0, SCREEN_WIDTH - iconBtn.xx - 30, 50);
//    [self addSubview:announcementBtn];
    UILabel *announcementlbl = [UILabel labelWithFrame:CGRectMake(iconBtn.xx + 10, 0, SCREEN_WIDTH - iconBtn.xx - 30, 50) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(12) textColor:[UIColor grayColor]];
    self.announcementlbl = announcementlbl;
    [self addSubview:announcementlbl];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, (SCREEN_WIDTH - 40)/2.3 + 61 + 12 + 11 + 30 - 1, SCREEN_WIDTH - 30, 1)];
    lineView.backgroundColor = kLineColor;
    [self addSubview:lineView];
}


-(void)initView
{
    
    UIImageView *bottomIV = [[UIImageView alloc] initWithFrame:CGRectMake(26, 61, SCREEN_WIDTH - 40, CardWidth)];
    bottomIV.image = kImage(@"私钥钱包背景");
    bottomIV.contentMode = UIViewContentModeScaleToFill;
    self.bottomIV = bottomIV;
    [self addSubview:bottomIV];
    
    UISwipeGestureRecognizer *leftBottomSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBottomClick:)];
    UISwipeGestureRecognizer *rightBottomSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightBottomClick:)];
    // 设置轻扫的方向
    leftBottomSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [bottomIV addGestureRecognizer:leftBottomSwipe];
    rightBottomSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [bottomIV addGestureRecognizer:rightBottomSwipe];
    
    bottomIV.userInteractionEnabled = YES;
    
    
    
    UIImageView *topIV = [[UIImageView alloc] initWithFrame:CGRectMake(12, 61, SCREEN_WIDTH - 40, CardWidth)];
    topIV.image = kImage(@"个人钱包背景");
    topIV.contentMode = UIViewContentModeScaleToFill;
    self.topIV = topIV;
    [self addSubview:topIV];
    
    UISwipeGestureRecognizer *lefttopSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeTopClick:)];
    UISwipeGestureRecognizer *righttopSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightTopClick:)];
    // 设置轻扫的方向
    lefttopSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [topIV addGestureRecognizer:lefttopSwipe];
    righttopSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [topIV addGestureRecognizer:righttopSwipe];
    topIV.userInteractionEnabled = YES;
    
    NSArray *array = @[@"通讯录",@"转账(1)",@"快速登录"];
    for (int i = 0; i < 3; i ++) {
        UIButton *iconBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [iconBtn setImage:kImage(array[i]) forState:(UIControlStateNormal)];
        iconBtn.frame = CGRectMake(31 + i % 3 * (40 + 30), 61 + CardWidth + 11, 30, 30);
        [iconBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        iconBtn.tag = 101 + i;
        [self addSubview:iconBtn];
//        iconBtn.backgroundColor = [UIColor redColor];
        
    }
    
    UIButton *addButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [addButton setImage:kImage(@"+") forState:(UIControlStateNormal)];
    addButton.frame = CGRectMake(SCREEN_WIDTH - 30 - 12, 61 + CardWidth + 11, 30, 30);
    [addButton addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    addButton.tag = 104;
    [self addSubview:addButton];
    
}


-(void)btnClick:(UIButton *)sender
{
    [_delegate AssetsHeadViewDelegateSelectBtn:sender.tag - 100];
}

-(void)swipeRightTopClick:(UISwipeGestureRecognizer *)swpie{
    
    
    
    
    NSLog(@"swipe right");
    [self setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.5 animations:^{
//        [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.equivalentBtn.mas_bottom).offset(37);
//            make.left.equalTo(self.mas_right).offset(30);
//            make.height.equalTo(@(kHeight(150)));
//            make.width.equalTo(@(kWidth(kScreenWidth-80)));
//        }];
        self.topIV.frame = CGRectMake(SCREEN_WIDTH, 61, SCREEN_WIDTH - 40, CardWidth);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {

        [self setNeedsUpdateConstraints];

        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.bottomIV.frame =  CGRectMake(12, 61, SCREEN_WIDTH - 40, CardWidth);
            [self bringSubviewToFront:self.bottomIV];

            self.topIV.frame = CGRectMake(26, 61, SCREEN_WIDTH - 40, CardWidth);
            [_delegate SlidingIsWallet:@"私钥钱包"];
            [self layoutIfNeeded];
            [self setNeedsDisplay];
            
        }];
        
    }];
    
    
}



-(void)swipeTopClick:(UISwipeGestureRecognizer *)swpie{
    
    NSLog(@"swipe left");
    
    [self setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.5 animations:^{

        self.topIV.frame =  CGRectMake(-SCREEN_WIDTH, 61, SCREEN_WIDTH - 40, CardWidth);
        
        [self layoutIfNeeded];
        
        
    } completion:^(BOOL finished) {
        [self setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.bottomIV.frame = CGRectMake(12, 61, SCREEN_WIDTH - 40, CardWidth);
            [self bringSubviewToFront:self.bottomIV];
            self.topIV.frame = CGRectMake(26, 61, SCREEN_WIDTH - 40, CardWidth);
            [_delegate SlidingIsWallet:@"私钥钱包"];
            [self layoutIfNeeded];
            [self setNeedsDisplay];
            
            
        }];
        
    }];
    
}


-(void)setUsdRate:(NSString *)usdRate
{
    self.announcementlbl.text = usdRate;
}

-(void)swipeRightBottomClick:(UISwipeGestureRecognizer *)swpie{
    
    
    [UIView animateWithDuration:0.5 animations:^{
        [self setNeedsUpdateConstraints];
        
        self.bottomIV.frame = CGRectMake(SCREEN_WIDTH, 61, SCREEN_WIDTH - 40, CardWidth);
        [self layoutIfNeeded];
        
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            [self setNeedsUpdateConstraints];
            
            self.topIV.frame = CGRectMake(12, 61, SCREEN_WIDTH - 40, CardWidth);
            [self bringSubviewToFront:self.topIV];
            self.bottomIV.frame = CGRectMake(26, 61, SCREEN_WIDTH - 36, CardWidth);

            [_delegate SlidingIsWallet:@"个人钱包"];
            [self layoutIfNeeded];
            [self setNeedsDisplay];
            
        }];
        
        
    }];
    
    
}
-(void)swipeBottomClick:(UISwipeGestureRecognizer *)swpie{
    
    
    [UIView animateWithDuration:0.5 animations:^{
        [self setNeedsUpdateConstraints];
        self.bottomIV.frame = CGRectMake(-SCREEN_WIDTH, 61, SCREEN_WIDTH - 40, CardWidth);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            [self setNeedsUpdateConstraints];
            self.topIV.frame = CGRectMake(12, 61, SCREEN_WIDTH - 40, CardWidth);
            [self bringSubviewToFront:self.topIV];
            self.bottomIV.frame = CGRectMake(26, 61, SCREEN_WIDTH - 40, CardWidth);

            [_delegate SlidingIsWallet:@"个人钱包"];
            [self layoutIfNeeded];
            [self setNeedsDisplay];
            
        }];
        
        
    }];
    
}




@end
