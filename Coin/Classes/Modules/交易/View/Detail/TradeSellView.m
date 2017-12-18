//
//  TradeSellView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TradeSellView.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import <UIScrollView+TLAdd.h>
#import <UIButton+WebCache.h>
#import "NSString+Extension.h"
#import "NSNumber+Extension.h"
#import "UILabel+Extension.h"
#import "UIButton+EnLargeEdge.h"
#import "AdsDetailBottomOpView.h"
#import "TLTextView.h"
#import "TLUser.h"
#import "AdsDetailUserView.h"
#import "PayTypeModel.h"

#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"

@interface TradeSellView ()<UITextFieldDelegate>

@property (nonatomic, strong) AdsDetailUserView *topUserView;

////用户资料
//@property (nonatomic, strong) adsdetail *topView;
////头像
//@property (nonatomic, strong) UIButton *photoBtn;
////昵称
//@property (nonatomic, strong) UILabel *nameLbl;
////支付方式
//@property (nonatomic, strong) UILabel *payTypeLbl;
////限额
//@property (nonatomic, strong) UILabel *limitAmountLbl;
////价格
//@property (nonatomic, strong) UILabel *priceLbl;

//留言
@property (nonatomic, strong) UIView *leaveMsgView;
//
@property (nonatomic, strong) TLTextView *leaveMsgTV;

//出售
@property (nonatomic, strong) UIView *sellView;
//可用余额
@property (nonatomic, strong) UILabel *leftAmountLbl;
//交易提醒
@property (nonatomic, strong) UILabel *tradeRemindLbl;
//底部
@property (nonatomic, strong) AdsDetailBottomOpView *bottomView;

@end

@implementation TradeSellView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        [self initScrollView];
        
        [self initTopView];
        //留言
        [self initLeaveMsg];
        //出售多少
        [self initSellView];
        //交易提醒
        [self initTradePrompt];
        //出售按钮
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

- (void)initSellView {
    
    self.sellView = [[UIView alloc] init];
    
    self.sellView.backgroundColor = kWhiteColor;
    
    [self.scrollView addSubview:self.sellView];
    [self.sellView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.width.equalTo(@(kScreenWidth));
        make.top.equalTo(self.leaveMsgView.mas_bottom).offset(10);
        make.height.equalTo(@120);
    }];
    
    //想要出售多少
    UIButton *wantSellBtn = [UIButton buttonWithTitle:@"你想出售多少?" titleColor:kTextColor backgroundColor:kClearColor titleFont:15.0];
    
    [wantSellBtn setImage:kImage(@"想要多少") forState:UIControlStateNormal];
    
    [self.sellView addSubview:wantSellBtn];
    [wantSellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@13);
        make.width.equalTo(@190);
        
    }];
    
    [wantSellBtn setTitleRight];
    
    //可用余额
    self.leftAmountLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kThemeColor font:12.0];
    
    [self.sellView addSubview:self.leftAmountLbl];
    [self.leftAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(wantSellBtn.mas_bottom).offset(13);
        
    }];
    
    //转换图标
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"切换")];
    
    [self.sellView addSubview:iconIV];
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
    
    [self.cnyTF addTarget:self action:@selector(ethDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.sellView addSubview:self.cnyTF];
    [self.cnyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.centerY.equalTo(iconIV.mas_centerY);
        make.width.equalTo(@(tfW));
        
    }];
    
    //leftLine
    UIView *leftLine = [[UIView alloc] init];
    
    leftLine.backgroundColor = kLineColor;
    
    [self.sellView addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.cnyTF.mas_left).offset(15);
        make.right.equalTo(self.cnyTF.mas_right);
        make.bottom.equalTo(@(-15));
        make.height.equalTo(@0.5);
        
    }];
    
    //ETH
    self.ethTF = [[TLTextField alloc] initWithFrame:CGRectMake(kScreenWidth/2.0 + 5, 65, tfW, 44) leftTitle:@"ETH" titleWidth:50 placeholder:@"请输入数值"];
    
    self.ethTF.delegate = self;
    
    self.ethTF.keyboardType = UIKeyboardTypeDecimalPad;
    
    [self.ethTF addTarget:self action:@selector(cnyDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.sellView addSubview:self.ethTF];
    [self.ethTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconIV.mas_right).offset(5);
        make.centerY.equalTo(iconIV.mas_centerY);
        make.width.equalTo(@(tfW));
        
    }];
    
    //rightLine
    UIView *rightLine = [[UIView alloc] init];
    
    rightLine.backgroundColor = kLineColor;
    
    [self.sellView addSubview:rightLine];
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
        make.top.equalTo(self.sellView.mas_bottom).offset(10);
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
    self.bottomView.opType = AdsDetailBottomOpTypeSell;
    
    //事件
    [self.bottomView.chatBtn addTarget:self action:@selector(link) forControlEvents:UIControlEventTouchUpInside];
    //
    [self.bottomView.opBtn addTarget:self action:@selector(sell) forControlEvents:UIControlEventTouchUpInside];
   
}

#pragma mark - Setting
- (void)setAdvertise:(AdvertiseModel *)advertise {
    
    _advertise = advertise;
    self.topUserView.ads = advertise;
    
    self.cnyTF.placeholder = [NSString stringWithFormat:@"%@-%@ ",[advertise.minTrade convertToSimpleRealMoney], [advertise.maxTrade convertToSimpleRealMoney]];
    //留言
    self.leaveMsgTV.text = advertise.leaveMessage;
}

- (void)setLeftAmount:(NSString *)leftAmount {
    
    _leftAmount = leftAmount;
    
//    self.leftAmountLbl.text = [NSString stringWithFormat:@"广告剩余可交易量: %@ ETH", [_leftAmount convertToSimpleRealCoin]];
    self.leftAmountLbl.text = [NSString stringWithFormat:@"可用余额: %@ ETH", [_leftAmount convertToSimpleRealCoin]];

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

- (void)setTradeRemind:(NSString *)tradeRemind {
    
    _tradeRemind = tradeRemind;
    
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

- (void)cnyDidChange:(UITextField *)sender {
    
    if ([sender.text isEqualToString:@""]) {
        
        self.cnyTF.text = @"";
        return ;
    }
    
    //ETH价格
    NSDecimalNumber *ethPrice = [NSDecimalNumber decimalNumberWithString:[self.advertise.truePrice convertToRealMoneyWithNum:4]];
    
    NSDecimalNumber *ethNum = [NSDecimalNumber decimalNumberWithString:sender.text];
    
    NSDecimalNumber *cny = [ethNum decimalNumberByMultiplyingBy:ethPrice];
    
    self.cnyTF.text = [[cny stringValue] convertToRealMoneyWithNum:2];
    
    self.tradeAmount = [[cny stringValue] convertToRealMoneyWithNum:3];
    
    self.tradeNum = sender.text;

}

- (void)sell {
    
    if (_tradeBlock) {
        
        _tradeBlock(TradeSellTypeSell);
    }
}

- (void)link {
    
    if (_tradeBlock) {
        
        _tradeBlock(TradeSellTypeLink);
    }
}

- (void)goHomePage {
    
    if (_tradeBlock) {
        
        _tradeBlock(TradeSellTypeHomePage);
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
        
    }
    else {
        
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

@end
