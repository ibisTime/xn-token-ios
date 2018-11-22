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
    [self addSubview:announcementBackBtn];
    
    
    UIButton *iconBtn = [UIButton buttonWithTitle:@"公告" titleColor:kHexColor(@"#0165ff") backgroundColor:kClearColor titleFont:12];
    iconBtn.frame = CGRectMake(12, 0, iconBtn.width, 50);
    [iconBtn sizeToFit];
    iconBtn.frame = CGRectMake(12, 0, iconBtn.width + 10, 50);
    [iconBtn SG_imagePositionStyle:(SGImagePositionStyleRight) spacing:2.5 imagePositionBlock:^(UIButton *button) {
        [button setImage:kImage(@"公告") forState:(UIControlStateNormal)];
    }];
    
    
    [announcementBackBtn addSubview:iconBtn];
    
    UIImageView *youImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 12 - 7.5, 17.5, 7.5, 15)];
    youImg.image = kImage(@"更多");
    [announcementBackBtn addSubview:youImg];
    
    UILabel *announcementlbl = [UILabel labelWithFrame:CGRectMake(iconBtn.xx + 10, 0, SCREEN_WIDTH - iconBtn.xx - 30, 50) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(12) textColor:[UIColor grayColor]];
    [announcementBackBtn addSubview:announcementlbl];
}


-(void)initView
{
    
    UIImageView *bottomIV = [[UIImageView alloc] initWithFrame:CGRectMake(24, 61, SCREEN_WIDTH - 40, CardWidth)];
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
    }
    
    
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
//        self.addButton.hidden = NO;
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.bottomIV.frame =  CGRectMake(12, 61, SCREEN_WIDTH - 40, CardWidth);
            [self bringSubviewToFront:self.bottomIV];

            self.topIV.frame = CGRectMake(24, 61, SCREEN_WIDTH - 40, CardWidth);

            [self layoutIfNeeded];
            [self setNeedsDisplay];
            
            
        }];
        
    }];
    
    
}



-(void)swipeTopClick:(UISwipeGestureRecognizer *)swpie{
    
    NSLog(@"swipe left");
    
    [self setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.5 animations:^{
//        [self.topIV mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.equivalentBtn.mas_bottom).offset(37);
//            make.right.equalTo(self.mas_left).offset(-30);
//            make.height.equalTo(@(kHeight(150)));
//            make.width.equalTo(@(kWidth(kScreenWidth-80)));
//        }];
        self.topIV.frame =  CGRectMake(-SCREEN_WIDTH, 61, SCREEN_WIDTH - 40, CardWidth);
        
        [self layoutIfNeeded];
        
        
    } completion:^(BOOL finished) {
//        if (self.switchBlock) {
//            self.switchBlock(0);
//        }
        [self setNeedsUpdateConstraints];
//        self.addButton.hidden = NO;
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.bottomIV.frame = CGRectMake(12, 61, SCREEN_WIDTH - 40, CardWidth);
            [self bringSubviewToFront:self.bottomIV];
            self.topIV.frame = CGRectMake(24, 61, SCREEN_WIDTH - 40, CardWidth);
//            [self.bottomIV mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.equivalentBtn.mas_bottom).offset(37);
//                make.left.equalTo(self.cnyAmountLbl.mas_left);
//                make.height.equalTo(@(kHeight(150)));
//                make.width.equalTo(@(kWidth(325)));
//
//            }];
//
//            [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.equivalentBtn.mas_bottom).offset(53);
//                make.left.equalTo(self.cnyAmountLbl.mas_left).offset(kWidth(120));
//                make.height.equalTo(@(kHeight(120)));
//                make.width.equalTo(@(kWidth(225)));
//
//            }];
            //            [self.segmentRight mas_remakeConstraints:^(MASConstraintMaker *make) {
            //                make.right.equalTo(self.mas_centerX).offset(-5);
            //                make.bottom.equalTo(self.mas_bottom).offset(-5);
            //                make.width.equalTo(@8);
            //                make.height.equalTo(@8);
            //
            //            }];
            //
            //
            //            [self.segmentLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
            //                make.left.equalTo(self.mas_centerX).offset(5);
            //                make.bottom.equalTo(self.mas_bottom).offset(-5);
            //                make.width.equalTo(@16);
            //                make.height.equalTo(@8);
            //
            //            }];
            [self layoutIfNeeded];
            [self setNeedsDisplay];
            
            
        }];
        
    }];
    
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
            self.bottomIV.frame = CGRectMake(24, 61, SCREEN_WIDTH - 36, CardWidth);

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
            self.bottomIV.frame = CGRectMake(24, 61, SCREEN_WIDTH - 40, CardWidth);


            [self layoutIfNeeded];
            [self setNeedsDisplay];
            
        }];
        
        
    }];
    
}




@end
