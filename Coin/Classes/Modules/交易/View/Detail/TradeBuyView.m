//
//  TradeBuyView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TradeBuyView.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import <UIScrollView+TLAdd.h>
#import <UIButton+WebCache.h>
#import "NSString+Extension.h"
#import "NSNumber+Extension.h"
#import "UILabel+Extension.h"
#import "UIButton+EnLargeEdge.h"
#import "UserStatistics.h"
#import "TLTextView.h"
#import "TLUser.h"
#import "AdsDetailBottomOpView.h"
#import "PayTypeModel.h"
#import "AdsDetailUserView.h"


#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"

@interface TradeBuyView ()<UITextFieldDelegate>

//用户资料
@property (nonatomic, strong) AdsDetailUserView *topUserView;

//留言
@property (nonatomic, strong) UIView *leaveMsgView;
//
@property (nonatomic, strong) TLTextView *leaveMsgTV;

//购买
@property (nonatomic, strong) UIView *buyView;
//可用余额
@property (nonatomic, strong) UILabel *leftAmountLbl;
//交易提醒
@property (nonatomic, strong) UILabel *tradeRemindLbl;
//底部
@property (nonatomic, strong) AdsDetailBottomOpView *bottomView;



@end

@implementation TradeBuyView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initScrollView];
        
        [self initTopView];
        //留言
        [self initLeaveMsg];
        //购买多少
        [self initBuyView];
        //交易提醒
        [self initTradePrompt];
        //购买按钮
        [self initBottomView];
        
    }
    return self;
}

#pragma mark Init
- (void)initScrollView {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.scrollView adjustsContentInsets];
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@(kSuperViewHeight - 60 - kBottomInsetHeight));
        
    }];
    
}

- (void)initTopView {
    
    //--//
    self.topUserView = [[AdsDetailUserView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 125)];
    [self.scrollView addSubview:self.topUserView];
    self.topUserView.userInteractionEnabled = YES;
    [self.topUserView addTarget:self action:@selector(goHomePage) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark- 这里有问题
- (void)initLeaveMsg {
    
    UIView *leaveMsgView = [[UIView alloc] initWithFrame:CGRectMake(0, 125, SCREEN_WIDTH, 150)];
    leaveMsgView.backgroundColor = kWhiteColor;
    self.leaveMsgView = leaveMsgView;
    [self.scrollView addSubview:leaveMsgView];
    
    TLTextView *textView = [[TLTextView alloc] initWithFrame:leaveMsgView.bounds];
    textView.font = Font(14.0);
    textView.placholder = [LangSwitcher switchLang:@"请写下您的广告留言吧" key:nil];
    textView.editable = NO;
    [leaveMsgView addSubview:textView];
    self.leaveMsgTV = textView;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@10);
        make.right.equalTo(@(-15));
        make.bottom.equalTo(@(-15));
        
    }];
    
}

- (void)initBuyView {
    
    self.buyView = [[UIView alloc] init];
    self.buyView.backgroundColor = kWhiteColor;
    [self.scrollView addSubview:self.buyView];
    [self.buyView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.width.equalTo(@(kScreenWidth));
        make.top.equalTo(self.leaveMsgView.mas_bottom).offset(10);
        make.height.equalTo(@120);
    }];
    
    //想要购买多少
    UIButton *wantBuyBtn = [UIButton buttonWithTitle:
                            [LangSwitcher switchLang:@"你想购买多少?" key:nil]
                                          titleColor:kTextColor
                                     backgroundColor:kClearColor
                                           titleFont:15.0];
    
    [wantBuyBtn setImage:kImage(@"想要多少") forState:UIControlStateNormal];
    
    [self.buyView addSubview:wantBuyBtn];
    [wantBuyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@13);
        make.width.equalTo(@190);
        
    }];
    
    [wantBuyBtn setTitleRight];
    
    //可用余额
    self.leftAmountLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kThemeColor font:12.0];
    
    [self.buyView addSubview:self.leftAmountLbl];
    [self.leftAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(wantBuyBtn.mas_bottom).offset(13);
        
    }];
    
    //转换图标
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"切换")];
    
    [self.buyView addSubview:iconIV];
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.bottom.equalTo(@(-25));
        make.width.height.equalTo(@(24));
        
    }];
    
    CGFloat tfW = (kScreenWidth - 24 - 40)/2.0;
    //CNY
    self.cnyTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, 60, tfW, 44) leftTitle:@"CNY" titleWidth:55 placeholder:@""];
    self.cnyTF.delegate = self;
    self.cnyTF.keyboardType = UIKeyboardTypeDecimalPad;
    [self.buyView addSubview:self.cnyTF];
    
    [self.cnyTF addTarget:self action:@selector(ethDidChange:) forControlEvents:UIControlEventEditingChanged];

    [self.cnyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.centerY.equalTo(iconIV.mas_centerY);
        make.width.equalTo(@(tfW));
        
    }];
    
    //leftLine
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = kLineColor;
    [self.buyView addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.cnyTF.mas_left).offset(15);
        make.right.equalTo(self.cnyTF.mas_right);
        make.bottom.equalTo(@(-15));
        make.height.equalTo(@0.5);
        
    }];
    
    //ETH
    self.ethTF = [[TLTextField alloc] initWithFrame:CGRectMake(kScreenWidth/2.0 + 5, 65, tfW, 44)
                                          leftTitle:@"ETH"
                                         titleWidth:50
                                        placeholder: [LangSwitcher switchLang:@"请输入数值" key:nil]];
    
    self.ethTF.delegate = self;
    self.ethTF.keyboardType = UIKeyboardTypeDecimalPad;
    [self.ethTF addTarget:self action:@selector(cnyDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.buyView addSubview:self.ethTF];
    [self.ethTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconIV.mas_right).offset(5);
        make.centerY.equalTo(iconIV.mas_centerY);
        make.width.equalTo(@(tfW));
        
    }];
    
    //rightLine
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = kLineColor;
    [self.buyView addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.ethTF.mas_left).offset(15);
        make.right.equalTo(self.ethTF.mas_right);
        make.bottom.equalTo(@(-15));
        make.height.equalTo(@0.5);
        
    }];
}

- (void)initTradePrompt {
    
    self.tradePromptView = [[UIView alloc] init];
    
    self.tradePromptView.backgroundColor = kWhiteColor;
    
    [self.scrollView addSubview:self.tradePromptView];
    [self.tradePromptView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.width.equalTo(@(kScreenWidth));
        make.top.equalTo(self.buyView.mas_bottom).offset(10);
    }];
    
    //交易提醒
    UIImageView *tradeIV = [[UIImageView alloc] init];
    tradeIV.image = kImage(@"交易提醒");
    
    [self.tradePromptView addSubview:tradeIV];
    [tradeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@10);
        
    }];
    
    UILabel *tradePromptLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    [self.tradePromptView addSubview:tradePromptLbl];
    [tradePromptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(tradeIV.mas_right).offset(6);
        make.centerY.equalTo(tradeIV.mas_centerY);
        
    }];
    
    self.tradeTextLbl = tradePromptLbl;
    
    //text
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:13.0];
    
    textLbl.numberOfLines = 0;
    
    [self.tradePromptView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(tradePromptLbl.mas_bottom).offset(11);
        
        make.edges.mas_equalTo(UIEdgeInsetsMake(40, 15, 15, 15));

    }];
    
    self.tradeRemindLbl = textLbl;
    
}

- (void)initBottomView {
    
    self.bottomView = [[AdsDetailBottomOpView alloc] initWithFrame:CGRectMake(0, kSuperViewHeight - 50 - kBottomInsetHeight, kScreenWidth, 50 + kBottomInsetHeight)];
    [self addSubview:self.bottomView];
    self.bottomView.opType = AdsDetailBottomOpTypeBuy;
    
    //事件
    [self.bottomView.chatBtn addTarget:self action:@selector(link) forControlEvents:UIControlEventTouchUpInside];
    //
    [self.bottomView.opBtn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
   
}

#pragma mark - Setting
- (void)setAdvertise:(AdvertiseModel *)advertise {
    
    _advertise = advertise;
    self.topUserView.ads = advertise;

    self.cnyTF.placeholder = [NSString stringWithFormat:@"%@-%@ ",
                              [advertise.minTrade convertToSimpleRealMoney],
                              [advertise.maxTrade convertToSimpleRealMoney]];
    //留言
    self.leaveMsgTV.text = advertise.leaveMessage;
}

- (void)setLeftAmount:(NSString *)leftAmount {
    
    _leftAmount = leftAmount;
    self.leftAmountLbl.text = [NSString stringWithFormat:@"广告剩余可交易量: %@ ETH", [_leftAmount convertToSimpleRealCoin]];
    self.leftAmountLbl.text = [LangSwitcher switchLang:self.leftAmountLbl.text key:nil];
    
}

- (void)setTruePrice:(NSNumber *)truePrice {
    
    _truePrice = truePrice;
    self.advertise.truePrice = truePrice;
}


- (void)setUserId:(NSString *)userId {
    
    _userId = userId;
    CGFloat scrollheight = [self.advertise.userId isEqualToString:userId] ? kSuperViewHeight: kSuperViewHeight - 60 - kBottomInsetHeight;
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@(scrollheight));
    }];
    self.bottomView.hidden = [self.advertise.userId isEqualToString:userId] ? YES: NO;
    
}

// 交易提醒
- (void)setTradeRemind:(NSString *)tradeRemind {
    
    _tradeRemind = tradeRemind;
    //
    [self.tradeRemindLbl labelWithTextString:tradeRemind lineSpace:5];
    [self layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.tradePromptView.yy);
    
}

#pragma mark - Events
- (void)ethDidChange:(UITextField *)sender {
    
    if ([sender.text isEqualToString:@""]) {
        
        self.ethTF.text = @"";
        return ;
    }
    
    //ETH价格
    NSDecimalNumber *ethPrice = [NSDecimalNumber decimalNumberWithString:[self.advertise.truePrice convertToRealMoneyWithNum:4]];
    
    NSDecimalNumber *cny = [NSDecimalNumber decimalNumberWithString:sender.text];
    
    NSDecimalNumber *ethNum = [cny decimalNumberByDividingBy:ethPrice];
    //保留8位小数,第九位舍去
    self.ethTF.text = [[ethNum stringValue] convertToRealMoneyWithNum:8];
    self.tradeAmount = sender.text;
    self.tradeNum = [[ethNum stringValue] convertToRealMoneyWithNum:9];

}

#pragma mark- 金额输入
- (void)cnyDidChange:(UITextField *)sender {
    
    if ([sender.text isEqualToString:@""]) {
        
        self.cnyTF.text = @"";
        return ;
    }
    
    //ETH价格
    NSDecimalNumber *ethPrice = [NSDecimalNumber decimalNumberWithString:[self.advertise.truePrice convertToRealMoneyWithNum:4]];
    NSDecimalNumber *ethNum = [NSDecimalNumber decimalNumberWithString:sender.text];
    
    //
    NSDecimalNumber *cny = [ethNum decimalNumberByMultiplyingBy:ethPrice];
    self.cnyTF.text = [[cny stringValue] convertToRealMoneyWithNum:2];
    self.tradeAmount = [[cny stringValue] convertToRealMoneyWithNum:3];
    self.tradeNum = sender.text;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"] || [string isEqualToString:@""]) {//按下return
        return YES;
    }
    
    NSCharacterSet *cs;
    NSUInteger nDotLoc = [textField.text rangeOfString:@"."].location;
    
    NSInteger count = 0;
    
    if (NSNotFound == nDotLoc && 0 != range.location) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers] invertedSet];
        if ([string isEqualToString:@"."]) {
            return YES;
        }
        
    } else {
        
        cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers] invertedSet];
        if (textField.text.length >= 12) {
            
            return NO;
        }
    }
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest) {
        return NO;
    }
    
    if (textField == self.cnyTF) {
        
        count = 2;
        
    } else if (textField == self.ethTF) {
        
        count = 8;
    }
    
    if (NSNotFound != nDotLoc && range.location > nDotLoc + count) {
        
        return NO;  //小数点后面两位
    }
    
    if (NSNotFound != nDotLoc && range.location > nDotLoc && [string isEqualToString:@"."]) {
        return NO;  //控制只有一个小数点
    }
    return YES;
}

#pragma mark- 事件
- (void)buy {
    
    if (_tradeBlock) {
        
        _tradeBlock(TradeBuyTypeBuy);
    }
}

- (void)link {
    
    if (_tradeBlock) {
        
        _tradeBlock(TradeBuyTypeLink);
    }
}



- (void)goHomePage {
    
    if (_tradeBlock) {
        
        _tradeBlock(TradeBuyTypeHomePage);
    }
}

#pragma mark - UITextFieldDelegate
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//
//    UILabel *placeHolderLbl = [textField valueForKeyPath:@"_placeholderLabel"];
//
//    CGFloat tfW = (kScreenWidth - 24 - 40)/2.0;
//
//    placeHolderLbl.width = tfW;
//
//    return YES;
//}


@end
