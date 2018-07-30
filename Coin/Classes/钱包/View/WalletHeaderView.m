//
//  WalletHeaderView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "WalletHeaderView.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"
#import "TLUser.h"

@interface WalletHeaderView ()
//背景
@property (nonatomic, strong) UIImageView *bgIV;
@property (nonatomic, strong) UIImageView *bottomIV;
//汇率
@property (nonatomic, strong) UILabel *rateAmountLbl;
//左边国旗
@property (nonatomic, strong) UIImageView *leftFlag;
//右边国旗
@property (nonatomic, strong) UIImageView *rightFlag;


@property (nonatomic, strong) UIImageView *rightArrowIV;

//@property (nonatomic, strong) UIImageView *segmentLeft;
//
//@property (nonatomic, strong) UIImageView *segmentRight;


@end

@implementation WalletHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initRateView];

        //
        [self initSubvies];
        //汇率
        
    }
    return self;
}

#pragma mark - Init
- (void)initSubvies {
    
    self.backgroundColor = [UIColor whiteColor];
    self.userInteractionEnabled = YES;
   
    
    //text
  
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton = addButton;
    [addButton setImage:kImage(@"增加") forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addCurrent) forControlEvents:UIControlEventTouchUpInside];
    addButton.backgroundColor = kClearColor;
//    [self addSubview:addButton];
//    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(self.mas_right).offset(-10);
//        make.bottom.equalTo(self.mas_bottom).offset(15);
//        make.width.height.equalTo(@20);
//
//    }];
//    addButton.hidden = YES;
//    UIButton *codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.codeButton = codeButton;
//    [codeButton setImage:kImage(@"扫一扫-黑色") forState:UIControlStateNormal];
//    [codeButton addTarget:self action:@selector(codeChoose) forControlEvents:UIControlEventTouchUpInside];
//    codeButton.backgroundColor = kClearColor;
//    [self addSubview:codeButton];
//    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.right.equalTo(self.addButton.mas_left).offset(-20);
//        make.top.equalTo(self.mas_top).offset(15+kStatusBarHeight);
//        make.width.height.equalTo(@20);
//        
//    }];
    
    UILabel *equivalentBtn = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#333333") font:10];
//    equivalentBtn.text = [LangSwitcher switchLang:@"总资产(CNY" key:nil];
    
//    [equivalentBtn setImage:kImage(@"总资产") forState:UIControlStateNormal];
    
    
    
    self.equivalentBtn = equivalentBtn;
    [self addSubview:equivalentBtn];
    [equivalentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_whiteView.mas_bottom).offset(11);
        make.left.equalTo(self.mas_left).offset(19);
//        make.width.greaterThanOrEqualTo(@115);
        
    }];
    
    
    //总资产
    self.cnyAmountLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#333333") font:18.0];
    
    [self addSubview:self.cnyAmountLbl];
    [self.cnyAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(equivalentBtn.mas_bottom).offset(5);
        make.left.equalTo(equivalentBtn.mas_left);
        make.height.equalTo(@25);

    }];
    UIImageView *bottomIV = [[UIImageView alloc] init];
    bottomIV.image = kImage(@"秘钥背景");
    bottomIV.contentMode = UIViewContentModeScaleToFill;
    UISwipeGestureRecognizer *leftBottomSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBottomClick:)];
     UISwipeGestureRecognizer *rightBottomSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightBottomClick:)];
    
    // 设置轻扫的方向
    
    leftBottomSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [bottomIV addGestureRecognizer:leftBottomSwipe];
    
    rightBottomSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [bottomIV addGestureRecognizer:rightBottomSwipe];

    [self addSubview:bottomIV];
    bottomIV.userInteractionEnabled = YES;
    
    [bottomIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.equivalentBtn.mas_bottom).offset(53);
        make.left.equalTo(self.cnyAmountLbl.mas_left).offset(kWidth(120));
        make.height.equalTo(@(kHeight(120)));
        make.width.equalTo(@(kWidth(226)));
        
    }];
    self.bottomIV = bottomIV;
    UILabel *localLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:14.0];
    
    localLbl.text = [LangSwitcher switchLang:@"私钥钱包" key:nil];
    
    
    self.localLbl = localLbl;
    [self.bottomIV addSubview:localLbl];
    UIImageView *imageView  = [[UIImageView alloc] init];
    imageView.backgroundColor = kClearColor;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerClick)];
    [imageView addGestureRecognizer:tap];
    imageView.userInteractionEnabled = YES;
    [self.bottomIV addSubview:imageView];
    imageView.image = kImage(@"问号");
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.localLbl.mas_top);
        make.left.equalTo(self.localLbl.mas_right).offset(3);
        make.width.height.equalTo(@14);

    }];
    [localLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.bottomIV.mas_left).offset(kWidth(47));
        make.top.equalTo(self.bottomIV.mas_top).offset(kWidth(44));
        
    }];
    
    UILabel *LocalMoney = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:30.0];
    
    self.LocalMoney = LocalMoney;
    if ([TLUser user].localMoney) {
        if ([[TLUser user].localMoney isEqualToString:@"CNY"] ) {
            self.LocalMoney.text = @"¥0.00";
            
        }else{
            self.LocalMoney.text = @"$0.00";
            
            
        }
    }else{
        
        self.LocalMoney.text = @"¥0.00";

    }
    
    [self.bottomIV addSubview:LocalMoney];
    [LocalMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.bottomIV.mas_left).offset(kWidth(43));
        make.top.equalTo(self.localLbl.mas_bottom).offset(kHeight(3));
        
    }];
    
    UIImageView *bgIV = [[UIImageView alloc] init];
    bgIV.image = kImage(@"个人钱包");
    bgIV.contentMode = UIViewContentModeScaleToFill;
    
    [self addSubview:bgIV];
    bgIV.userInteractionEnabled = YES;

    [bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.equivalentBtn.mas_bottom).offset(37);
        make.left.equalTo(self.cnyAmountLbl.mas_left);
        make.height.equalTo(@(kHeight(150)));
        make.width.equalTo(@(kWidth(325)));

    }];
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeClick:)];
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightClick:)];
    // 设置轻扫的方向
    
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;

    
    [bgIV addGestureRecognizer:leftSwipe];
    [bgIV addGestureRecognizer:rightSwipe];


    self.bgIV = bgIV;
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#D3FFFF") font:14.0];
    
    textLbl.text = [LangSwitcher switchLang:@"个人账户" key:nil];
    self.textLbl = textLbl;
    [self.bgIV addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.bgIV.mas_left).offset(kWidth(47));
        make.top.equalTo(self.bgIV.mas_top).offset(kHeight(44));
        
    }];
    UIImageView *image  = [[UIImageView alloc] init];
    [self.bgIV addSubview:image];
    image.backgroundColor = kClearColor;

    image.image = kImage(@"问号");
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLbl.mas_top);
        make.left.equalTo(self.textLbl.mas_right).offset(3);
        make.width.height.equalTo(@14);
        
    }];
    image.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(localClick)];
    [image addGestureRecognizer:tap1];
    UILabel *privateMoney = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:30.0];
    
    self.privateMoney = privateMoney;
    [self.bgIV addSubview:privateMoney];
    [privateMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.bgIV.mas_left).offset(kWidth(43));
        make.top.equalTo(self.textLbl.mas_bottom).offset(kHeight(3));
        
    }];
    
//    self.segmentLeft = [[UIImageView alloc] init];
//    [self addSubview:self.segmentLeft];
//    self.segmentLeft.layer.cornerRadius = 4.0;
//    self.segmentLeft.clipsToBounds = YES;
//    self.segmentLeft.backgroundColor = kHexColor(@"#007AFF");
//    [self.segmentLeft mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_centerX).offset(-5);
//        make.bottom.equalTo(self.mas_bottom).offset(-5);
//        make.width.equalTo(@16);
//        make.height.equalTo(@8);
//
//    }];
//
//    self.segmentRight = [[UIImageView alloc] init];
//    [self addSubview:self.segmentRight];
//    self.segmentRight.layer.cornerRadius = 4.0;
//    self.segmentRight.clipsToBounds = YES;
//    self.segmentRight.backgroundColor = kHexColor(@"#C6D5DC");
//    [self.segmentRight mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_centerX).offset(5);
//        make.bottom.equalTo(self.mas_bottom).offset(-5);
//        make.width.equalTo(@8);
//        make.height.equalTo(@8);
//
//    }];
   
    //美元
//    self.usdAmountLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:15.0];
//    
//    self.usdAmountLbl.textAlignment = NSTextAlignmentCenter;
//
//    [self addSubview:self.usdAmountLbl];
//    [self.usdAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self.cnyAmountLbl.mas_bottom).offset(12);
//        make.left.equalTo(@0);
//        make.width.equalTo(@(kScreenWidth/2.0));
//
//    }];
//    
//    //港元
//    self.hkdAmountLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:15.0];
//    
//    self.hkdAmountLbl.textAlignment = NSTextAlignmentCenter;
//    
//    [self addSubview:self.hkdAmountLbl];
//    [self.hkdAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self.cnyAmountLbl.mas_bottom).offset(12);
//        make.left.equalTo(self.usdAmountLbl.mas_right);
//        make.width.equalTo(@(kScreenWidth/2.0));
//        
//    }];
    
}

-(void)swipeRightClick:(UISwipeGestureRecognizer *)swpie{
    
    
    NSLog(@"swipe right");
    [self setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.equivalentBtn.mas_bottom).offset(37);
            make.left.equalTo(self.mas_right).offset(30);
            make.height.equalTo(@(kHeight(150)));
            make.width.equalTo(@(kWidth(kScreenWidth-80)));
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (self.switchBlock) {
            self.switchBlock(0);
        }
        [self setNeedsUpdateConstraints];
        self.addButton.hidden = NO;
        
        [UIView animateWithDuration:0.5 animations:^{
            [self bringSubviewToFront:self.bottomIV];
            
            [self.bottomIV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.equivalentBtn.mas_bottom).offset(37);
                make.left.equalTo(self.cnyAmountLbl.mas_left);
                make.height.equalTo(@(kHeight(150)));
                make.width.equalTo(@(kWidth(325)));
                
            }];
            
            [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.equivalentBtn.mas_bottom).offset(53);
                make.left.equalTo(self.cnyAmountLbl.mas_left).offset(kWidth(120));
                make.height.equalTo(@(kHeight(120)));
                make.width.equalTo(@(kWidth(225)));
                
            }];
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


- (void)centerClick
{
   
    if (self.localBlock) {
        self.localBlock();
    }
}

- (void)localClick
{
    
    if (self.centerBlock) {
        self.centerBlock();
    }
    
}

-(void)swipeClick:(UISwipeGestureRecognizer *)swpie{
   
    
    NSLog(@"swipe left");

    [self setNeedsUpdateConstraints];

    [UIView animateWithDuration:0.5 animations:^{
        [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.equivalentBtn.mas_bottom).offset(37);
            make.right.equalTo(self.mas_left).offset(-30);
            make.height.equalTo(@(kHeight(150)));
            make.width.equalTo(@(kWidth(kScreenWidth-80)));
        }];

       
        [self layoutIfNeeded];

        
    } completion:^(BOOL finished) {
        if (self.switchBlock) {
            self.switchBlock(0);
        }
        [self setNeedsUpdateConstraints];
        self.addButton.hidden = NO;

        [UIView animateWithDuration:0.5 animations:^{
            [self bringSubviewToFront:self.bottomIV];

            [self.bottomIV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.equivalentBtn.mas_bottom).offset(37);
                make.left.equalTo(self.cnyAmountLbl.mas_left);
                make.height.equalTo(@(kHeight(150)));
                make.width.equalTo(@(kWidth(325)));
                
            }];
            
            [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.equivalentBtn.mas_bottom).offset(53);
                make.left.equalTo(self.cnyAmountLbl.mas_left).offset(kWidth(120));
                make.height.equalTo(@(kHeight(120)));
                make.width.equalTo(@(kWidth(225)));
                
            }];
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
        [self.bottomIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.equivalentBtn.mas_bottom).offset(37);
            make.left.equalTo(self.mas_right).offset(30);
            make.height.equalTo(@(kHeight(150)));
            make.width.equalTo(@(kWidth(325)));
        }];
        
        [self layoutIfNeeded];
        
        
    } completion:^(BOOL finished) {
        if (self.switchBlock) {
            self.switchBlock(1);
        }
        [UIView animateWithDuration:0.5 animations:^{
            self.addButton.hidden = YES;
            
            [self setNeedsUpdateConstraints];
            [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.equivalentBtn.mas_bottom).offset(37);
                make.left.equalTo(self.cnyAmountLbl.mas_left);
                make.height.equalTo(@(kHeight(150)));
                make.width.equalTo(@(kWidth(325)));
                
            }];
            [self bringSubviewToFront:self.bgIV];
            [self.bottomIV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.equivalentBtn.mas_bottom).offset(53);
                make.left.equalTo(self.cnyAmountLbl.mas_left).offset((kWidth(120)));
                make.height.equalTo(@(kHeight(120)));
                make.width.equalTo(@(kWidth(220)));
                
            }];
//            [self.segmentLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(self.mas_centerX).offset(-5);
//                make.bottom.equalTo(self.mas_bottom).offset(-5);
//                make.width.equalTo(@16);
//                make.height.equalTo(@8);
//
//            }];
//
//
//            [self.segmentRight mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.mas_centerX).offset(5);
//                make.bottom.equalTo(self.mas_bottom).offset(-5);
//                make.width.equalTo(@8);
//                make.height.equalTo(@8);
//
//            }];
            [self layoutIfNeeded];
            [self setNeedsDisplay];
            
        }];
        
        
    }];
    
    
}
-(void)swipeBottomClick:(UISwipeGestureRecognizer *)swpie{
  
    [UIView animateWithDuration:0.5 animations:^{
        [self setNeedsUpdateConstraints];
        [self.bottomIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.equivalentBtn.mas_bottom).offset(37);
            make.right.equalTo(self.cnyAmountLbl.mas_left).offset(-30);
            make.height.equalTo(@(kHeight(150)));
            make.width.equalTo(@(kWidth(325)));
        }];
        
        [self layoutIfNeeded];
        
        
    } completion:^(BOOL finished) {
        if (self.switchBlock) {
            self.switchBlock(1);
        }
        [UIView animateWithDuration:0.5 animations:^{
            self.addButton.hidden = YES;

            [self setNeedsUpdateConstraints];
            [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.equivalentBtn.mas_bottom).offset(37);
                make.left.equalTo(self.cnyAmountLbl.mas_left);
                make.height.equalTo(@(kHeight(150)));
                make.width.equalTo(@(kWidth(325)));
                
            }];
            [self bringSubviewToFront:self.bgIV];
            [self.bottomIV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.equivalentBtn.mas_bottom).offset(53);
                make.left.equalTo(self.cnyAmountLbl.mas_left).offset((kWidth(120)));
                make.height.equalTo(@(kHeight(120)));
                make.width.equalTo(@(kWidth(220)));
                
            }];
//            [self.segmentLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(self.mas_centerX).offset(-5);
//                make.bottom.equalTo(self.mas_bottom).offset(-5);
//                make.width.equalTo(@16);
//                make.height.equalTo(@8);
//
//            }];
//
//
//            [self.segmentRight mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.mas_centerX).offset(5);
//                make.width.equalTo(@8);
//                make.height.equalTo(@8);
//                make.bottom.equalTo(self.mas_bottom).offset(-5);
//
//            }];
            [self layoutIfNeeded];
            [self setNeedsDisplay];

        }];
       

    }];
    
}
- (void)addCurrent
{
    
    if (_addBlock) {
        _addBlock();
    }
    
    
}
- (void)codeChoose
{
    
    if (self.codeBlock) {
        self.codeBlock();
    }
    
    
}

- (void)initRateView {
    //白色背景
    UIView *whiteView = [[UIView alloc] init];
    
    whiteView.backgroundColor = kWhiteColor;
    self.whiteView = whiteView;
    [self addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.top.equalTo(@(kStatusBarHeight));
        make.height.equalTo(@(kHeight(40)));
        
    }];
   
    
    //左边国旗
    self.leftFlag = [[UIImageView alloc] init];
    
    [whiteView addSubview:self.leftFlag];
    [self.leftFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(whiteView.mas_centerY);
        
    }];
    
    //汇率
    self.rateAmountLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:12.0];
    
    [whiteView addSubview:self.rateAmountLbl];
    self.rateAmountLbl.userInteractionEnabled = YES;
    [self.rateAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.leftFlag.mas_right).offset(10);
        make.centerY.equalTo(whiteView.mas_centerY);
//        make.right.equalTo(self.rightArrowIV.mas_left).offset(10);


    }];
    [self.rateAmountLbl sizeToFit];
    //点击手势
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRate:)];
    
    [self.rateAmountLbl addGestureRecognizer:tapGR];
    //右边国旗
    self.rightFlag = [[UIImageView alloc] init];
    
    [whiteView addSubview:self.rightFlag];
    [self.rightFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.rateAmountLbl.mas_right).offset(10);
        make.centerY.equalTo(whiteView.mas_centerY);

    }];
    
    //右箭头
    UIImageView *rightArrowIV = [[UIImageView alloc] initWithImage:kImage(@"关闭")];
    self.rightArrowIV = rightArrowIV;
    rightArrowIV.userInteractionEnabled = YES;
    UITapGestureRecognizer *leftSwipe = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    
    // 设置轻扫的方向
    [rightArrowIV addGestureRecognizer:leftSwipe];
    
    [whiteView addSubview:rightArrowIV];
    [rightArrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(whiteView.mas_right).offset(-15);
        make.centerY.equalTo(self.leftFlag.mas_centerY);
        make.width.height.equalTo(@(16));

    }];
}

- (void)tapClick: (UITapGestureRecognizer* )tap
{
//    [self.whiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.right.top.bottom.equalTo(0);
//    }];
//     [self.whiteView removeFromSuperview];
     self.whiteView.hidden = YES;
    
    [self.equivalentBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kStatusBarHeight+15));
        make.left.equalTo(self.mas_left).offset(19);
    }];
    if (self.clearBlock) {
        self.clearBlock();
    }
    
}

#pragma mark - Setting
- (void)setUsdRate:(NSString *)usdRate {
    
    _usdRate = usdRate;
//    if ([LangSwitcher currentLangType] == LangTypeEnglish) {
//        
//    }
    if ([LangSwitcher currentLangType] == LangTypeSimple) {
        self.leftFlag.image = kImage(@"公告");

    }else{
        self.leftFlag.image = kImage(@"NOTICE");

        
    }
        
        
    
    self.rateAmountLbl.text =[NSString stringWithFormat:@"  |  %@",usdRate];
    
//    self.rightFlag.image = kImage(@"中国国旗");
    
}

- (void)setHkdRate:(NSString *)hkdRate {
    
    _hkdRate = hkdRate;
    
}

#pragma mark - Events
- (void)clickRate:(UITapGestureRecognizer *)tapGR {
    
    if (_headerBlock) {
        
        _headerBlock();
    }
}

@end
