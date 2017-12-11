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

#import "TLTextView.h"
#import "TLUser.h"

#import "PayTypeModel.h"

#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"

@interface TradeBuyView ()<UITextFieldDelegate>

//用户资料
@property (nonatomic, strong) UIView *topView;
//头像
@property (nonatomic, strong) UIButton *photoBtn;
//昵称
@property (nonatomic, strong) UILabel *nameLbl;
//支付方式
@property (nonatomic, strong) UILabel *payTypeLbl;
//限额
@property (nonatomic, strong) UILabel *limitAmountLbl;
//价格
@property (nonatomic, strong) UILabel *priceLbl;

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
@property (nonatomic, strong) UIView *bottomView;



@end

@implementation TradeBuyView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        self.lblArr = [NSMutableArray array];
        
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
    
    self.topView = [[UIView alloc] init];
    
    self.topView.backgroundColor = kWhiteColor;
    
    [self.scrollView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@0);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@125);
        
    }];
    
    //头像
    CGFloat imgWidth = 48;
    
    self.photoBtn = [UIButton buttonWithTitle:@"" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:24 cornerRadius:imgWidth/2.0];
    
    [self.photoBtn addTarget:self action:@selector(homePage) forControlEvents:UIControlEventTouchUpInside];
    
    self.photoBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.topView addSubview:self.photoBtn];
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@(15));
        make.width.height.equalTo(@(imgWidth));
        
    }];
    
    //昵称
    self.nameLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    [self.topView addSubview:self.nameLbl];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@15);
        make.left.equalTo(self.photoBtn.mas_right).offset(10);
        
    }];
    
    //支付方式
    self.payTypeLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor clearColor]
                                         font:Font(11)
                                    textColor:kClearColor];
    self.payTypeLbl.layer.cornerRadius = 3;
    self.payTypeLbl.clipsToBounds = YES;
    
    [self.topView addSubview:self.payTypeLbl];
    [self.payTypeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLbl.mas_top);
        make.width.equalTo(@32);
        make.height.equalTo(@18);
        make.left.equalTo(self.nameLbl.mas_right).offset(6);
        
    }];
    
    //限额
    self.limitAmountLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
    
    [self.topView addSubview:self.limitAmountLbl];
    [self.limitAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.top.equalTo(self.nameLbl.mas_bottom).offset(10);
        
    }];
    
    //价格
    self.priceLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kRiseColor font:15.0];
    
    [self.topView addSubview:self.priceLbl];
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(@(15));
        
    }];
    
//    self.trustBtn = [UIButton buttonWithTitle:@"+ 信任" titleColor:kThemeColor backgroundColor:kClearColor titleFont:13.0 cornerRadius:3];
//    
//    self.trustBtn.layer.borderWidth = 0.5;
//    self.trustBtn.layer.borderColor = kThemeColor.CGColor;
//    
//    [self.trustBtn addTarget:self action:@selector(trust:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.topView addSubview:self.trustBtn];
//    [self.trustBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.right.equalTo(self.priceLbl.mas_right);
//        make.top.equalTo(self.priceLbl.mas_bottom).offset(10);
//        make.width.equalTo(@70);
//        make.height.equalTo(@24);
//        
//    }];
//    
//    self.trustBtn.hidden = YES;
    
    NSArray *textArr = @[@"交易次数", @"信任次数", @"好评率", @"历史交易"];
    
    CGFloat width = kScreenWidth/(textArr.count*1.0);
    
    [textArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:17.0];
        
        textLbl.numberOfLines = 0;
        
        textLbl.textAlignment = NSTextAlignmentCenter;
        
        [self.topView addSubview:textLbl];
        [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(idx*width));
            make.width.equalTo(@(width));
            make.height.equalTo(@50);
            make.bottom.equalTo(@(-0.5));
        }];
        
        [self.lblArr addObject:textLbl];
    }];
    
    //分割线
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kLineColor;
    
    [self.topView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@(-0.5));
        make.height.equalTo(@0.5);
        
    }];
}

- (void)initLeaveMsg {
    
    UIView *leaveMsgView = [[UIView alloc] init];
    
    leaveMsgView.backgroundColor = kWhiteColor;
    
    [self.scrollView addSubview:leaveMsgView];
    [leaveMsgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.width.equalTo(@(kScreenWidth));
        make.top.equalTo(self.topView.mas_bottom);
        make.height.equalTo(@150);
    }];
    
    self.leaveMsgView = leaveMsgView;
    
    TLTextView *textView = [[TLTextView alloc] initWithFrame:leaveMsgView.bounds];
    
    textView.font = Font(14.0);
    
    textView.placholder = [LangSwitcher switchLang:@"请写下您的广告留言吧" key:nil];
    
    textView.editable = NO;
    
    [leaveMsgView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@10);
        make.right.equalTo(@(-15));
        make.bottom.equalTo(@(-15));
        
    }];
    
    self.leaveMsgTV = textView;
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
    
    [self.cnyTF addTarget:self action:@selector(ethDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.buyView addSubview:self.cnyTF];
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
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kSuperViewHeight - 50 - kBottomInsetHeight, kScreenWidth, 50 + kBottomInsetHeight)];
    
    self.bottomView.backgroundColor = kWhiteColor;
    
    [self addSubview:self.bottomView];
   
    //联系对方
    UIButton *linkBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"联系对方" key:nil]
                                       titleColor:kTextColor
                                  backgroundColor:kWhiteColor
                                        titleFont:16.0];
    
    [linkBtn addTarget:self action:@selector(link) forControlEvents:UIControlEventTouchUpInside];
    
    [linkBtn setImage:kImage(@"聊天") forState:UIControlStateNormal];
    
    [self.bottomView addSubview:linkBtn];
    [linkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@0);
        make.width.equalTo(@(kScreenWidth/2.0));
        make.height.equalTo(@50);
        
    }];
    
    [linkBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    
    //购买按钮
    UIButton *buyBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"购买" key:nil] 
                                      titleColor:kWhiteColor
                                 backgroundColor:kThemeColor
                                       titleFont:16.0];
    
    [buyBtn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.top.equalTo(@0);
        make.width.equalTo(@(kScreenWidth/2.0));
        make.height.equalTo(@50);
        
    }];
    
    //分割线
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kLineColor;
    
    [self.bottomView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.bottom.equalTo(linkBtn.mas_bottom).offset(0);
        make.height.equalTo(@0.5);
        
    }];
    
}

#pragma mark - Setting

- (void)setAdvertise:(AdvertiseModel *)advertise {
    
    _advertise = advertise;
    
    TradeUserInfo *userInfo = advertise.user;
    
    UserStatistics *userStatist = advertise.userStatistics;
    
    //头像
    if (userInfo.photo) {
        
        [self.photoBtn setTitle:@"" forState:UIControlStateNormal];
        
        [self.photoBtn sd_setImageWithURL:[NSURL URLWithString:[userInfo.photo convertImageUrl]] forState:UIControlStateNormal];
        
    } else {
        
        NSString *nickName = userInfo.nickname;
        
        NSString *title = [nickName substringToIndex:1];
        
        [self.photoBtn setTitle:title forState:UIControlStateNormal];
        
    }
    
    self.nameLbl.text = userInfo.nickname;
    
    //支付方式
    PayTypeModel *payModel = [PayTypeModel new];
    
    payModel.payType = advertise.payType;
    
    self.payTypeLbl.text = payModel.text;
    
    CGFloat payW = self.payTypeLbl.text.length*11 + 10;
    
    [self.payTypeLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(payW));
    }];
    
    self.payTypeLbl.textColor = payModel.color;
    
    self.payTypeLbl.layer.borderColor = payModel.color.CGColor;
    self.payTypeLbl.layer.borderWidth = 0.5;
    
    //限额
    self.limitAmountLbl.text = [NSString stringWithFormat:@"限额: %@-%@ ",[advertise.minTrade convertToSimpleRealMoney], [advertise.maxTrade convertToSimpleRealMoney]];
    
    self.cnyTF.placeholder = [NSString stringWithFormat:@"%@-%@ ",[advertise.minTrade convertToSimpleRealMoney], [advertise.maxTrade convertToSimpleRealMoney]];

    //价格
    self.priceLbl.text = [NSString stringWithFormat:@"%@ %@", [advertise.truePrice convertToSimpleRealMoney],self.advertise.tradeCurrency];
    
    NSArray *textArr = @[@"交易次数", @"信任次数", @"好评率"];
    
    NSArray *numArr = @[[NSString stringWithFormat:@"%ld", userStatist.jiaoYiCount], [NSString stringWithFormat:@"%ld", userStatist.beiXinRenCount], userStatist.goodCommentRate];
    
    [self.lblArr enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 3) {
            
            return ;
        }
        
        [obj labelWithString:[NSString stringWithFormat:@"%@\n%@", numArr[idx], textArr[idx]] title:textArr[idx] font:Font(12.0) color:kTextColor2];
        
    }];
    
    //留言
    self.leaveMsgTV.text = advertise.leaveMessage;
    // - - //
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

//- (void)trust:(UIButton *)sender {
//
////    TradeBuyType type = self.isTrust == NO ? TradeBuyTypeTrust: TradeBuyTypeCancelTrust;
//
//    if (_tradeBlock) {
//
//        _tradeBlock(type);
//    }
//}

- (void)homePage {
    
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
