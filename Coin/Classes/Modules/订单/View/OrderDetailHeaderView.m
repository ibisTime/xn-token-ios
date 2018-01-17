//
//  OrderDetailHeaderView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "OrderDetailHeaderView.h"

#import <Foundation/Foundation.h>

#import "TLUIHeader.h"
#import "AppColorMacro.h"
#import "NSString+Extension.h"
#import "NSNumber+Extension.h"
#import "NSString+Date.h"

#define BTN_HEIGHT 44

@interface OrderDetailHeaderView ()

@property (nonatomic, strong) UIView *topView;
//订单编号
@property (nonatomic, strong) UILabel *orderCodeLbl;
//订单状态
@property (nonatomic, strong) UILabel *statusLbl;
//交易金额
@property (nonatomic, strong) UILabel *amountLbl;
//交易数量
@property (nonatomic, strong) UILabel *numLbl;
//交易价格
@property (nonatomic, strong) UILabel *priceLbl;



//买家
@property (nonatomic, strong) UILabel *buyersLbl;
//卖家
@property (nonatomic, strong) UILabel *sellerLbl;
//留言
@property (nonatomic, strong) UILabel *leaveMsgLbl;


@end

@implementation OrderDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        //
        [self initTopView];
        //
        [self initCenterView];
    }
    return self;
}



#pragma mark - 订单设置
- (void)setOrder:(OrderModel *)order {
    
    _order = order;
    
    NSInteger count = order.code.length;
    
    NSString *code = [order.code substringFromIndex:count - 8];
    
    self.orderCodeLbl.text = [NSString stringWithFormat:@"订单编号: %@", code];
    self.orderCodeLbl.text = [LangSwitcher switchLang:self.orderCodeLbl.text key:nil];
    
    self.statusLbl.text = order.statusStr;

    
    self.amountLbl.text = [NSString stringWithFormat:@"%@ CNY", order.tradeAmount];
    
    NSString *realNum = [order.countString convertToSimpleRealCoin];
    self.numLbl.text = [NSString stringWithFormat:@"%@ ETH", [realNum convertToRealMoneyWithNum:8]];
    self.priceLbl.text = [NSString stringWithFormat:@"%@ CNY", [order.tradePrice convertToRealMoneyWithNum:2]];
    //买家
    self.buyersLbl.text = [NSString stringWithFormat:@"%@: %@",[LangSwitcher switchLang:@"买家" key:nil], order.buyUserInfo.nickname];
    //卖家
    self.sellerLbl.text = [NSString stringWithFormat:@"%@: %@",[LangSwitcher switchLang:@"卖家" key:nil], order.sellUserInfo.nickname];
    //留言
    self.leaveMsgLbl.text = [NSString stringWithFormat:@"%@: %@",[LangSwitcher switchLang:@"广告留言" key:nil], order.leaveMessage];
    
    //确定按钮上面的那就话
    if (
        [order.status isEqualToString:kTradeOrderStatusToPay]
        ) {
        
        //待支付
        [self calculateInvalidTimeWithOrder:order];
        
        self.cancleBtn.hidden = NO;
        CGFloat tempBtnWidth = 120;
        CGFloat tempBtnHeight = BTN_HEIGHT;
        
        if([self.order isMineBuyOrder]) {
            //我是买家可以取消
            
            //标记打款按钮
            [self.tradeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.equalTo(self.centerView.mas_left).offset(SCREEN_WIDTH*0.75);
                make.width.mas_equalTo(tempBtnWidth);
                make.height.equalTo(@(tempBtnHeight));
                make.top.equalTo(self.promptLbl.mas_bottom).offset(15);
                
            }];
            
            //取消交易按钮
            [self.cancleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.equalTo(self.centerView.mas_left).offset(SCREEN_WIDTH*0.25);
                make.top.equalTo(self.tradeBtn.mas_top);
                make.height.equalTo(self.tradeBtn.mas_height);
                make.width.equalTo(self.tradeBtn.mas_width);
                
            }];
            
        } else {
            
            self.cancleBtn.hidden = YES;
            [self reAddTradeBtnLayout];
            
        }
        
    } else {
        
        self.cancleBtn.hidden = YES;
        [self reAddTradeBtnLayout];

        if ([order.status isEqualToString:kTradeOrderStatusPayed]) {
            //已支付
            self.promptLbl.text = @"买家已支付，等待卖家释放";
            
        } else if ([order.status isEqualToString:kTradeOrderStatusReleased] ||
                   [order.status isEqualToString:kTradeOrderStatusComplete]) {
            
            self.promptLbl.text = order.promptStr;
            
        } else {
            
            self.promptLbl.text = order.remark;
            
        }
        
    }
    
  
    
    //按钮
    [self.tradeBtn setTitle:order.btnTitle forState:UIControlStateNormal];
    [self.tradeBtn setBackgroundColor:order.bgColor forState:UIControlStateNormal];
    self.tradeBtn.enabled = order.enable;
    [self layoutIfNeeded];
    [self.centerView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@(self.tradeBtn.yy + 18));
        
    }];
    
}

//计算时间
- (void)calculateInvalidTimeWithOrder:(OrderModel *)order {
    
//    NSDate *invalidDate = [NSString dateFromString:order.invalidDatetime formatter:@"MMM dd, yyyy hh:mm:ss aa"];
    
//    NSDate *createDate = [NSString dateFromString:order.createDatetime formatter:@"MMM dd, yyyy hh:mm:ss aa"];
    
    //失效时间
    NSString *inviteDateStr = [order.invalidDatetime convertDateWithFormat:@"HH:mm:ss"];
    //转换时间格式
    //对比两个时间
    
//    NSTimeInterval seconds = [invalidDate timeIntervalSinceDate:createDate];
//    NSTimeInterval seconds = [invalidDate timeIntervalSinceDate:localDate];
//    NSInteger minute = seconds/60;
    
    self.promptLbl.text = [NSString stringWithFormat:@"货币将在托管中保持至%@, 逾期未支付交易将自动取消", inviteDateStr];
    self.promptLbl.text = [LangSwitcher switchLang:self.promptLbl.text key:nil];
}

#pragma mark - Events
- (void)orderStatusDidChange:(UIButton *)sender {
    
    
    // 此处真是SB,有坑请注意
    // 
    NSInteger status = [self.order.status integerValue];
    
    if (self.orderBlock) {
        
        self.orderBlock(status);
    }
    
}

#pragma mark - 买家取消
- (void)buyCancel {
    
    if (self.orderBlock) {
        
        self.orderBlock(OrderEventsTypeBuyerCancel);
    }
    
}



- (void)reAddTradeBtnLayout {
    
    [self.tradeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.centerView.mas_centerX);
        make.width.equalTo(@150);
        make.height.equalTo(@(BTN_HEIGHT));
        make.top.equalTo(self.promptLbl.mas_bottom).offset(15);
        
    }];
    
}

#pragma mark - Init
- (void)initTopView {
    
    self.topView = [[UIView alloc] init];
    
    self.topView.backgroundColor = kWhiteColor;
    
    [self addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@0);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@155);
        
    }];
    
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"订单编号")];
    
    iconIV.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.topView addSubview:iconIV];
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@0);
        make.height.equalTo(@50);
        make.left.equalTo(@15);
        
    }];
    
    //订单编号
    self.orderCodeLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    [self.topView addSubview:self.orderCodeLbl];
    
    [self.orderCodeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconIV.mas_right).offset(5);
        make.top.equalTo(@0);
        make.height.equalTo(@50);
        
    }];
    
    //订单状态
    self.statusLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kThemeColor font:16.0];
    [self.topView addSubview:self.statusLbl];
    [self.statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.top.equalTo(@(0));
        make.height.equalTo(@50);
        
    }];
    
    //分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kLineColor;
    [self.topView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.top.equalTo(self.orderCodeLbl.mas_bottom).offset(0);
        make.height.equalTo(@0.5);
        
    }];
    
    NSArray *textArr = @[
                         [LangSwitcher switchLang:@"交易金额" key:nil],
                         [LangSwitcher switchLang:@"交易数量" key:nil],
                         [LangSwitcher switchLang:@"交易价格" key:nil]

                         ];
    
    __block UILabel *lastLbl = self.orderCodeLbl;
    [textArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
        
        textLbl.text = textArr[idx];
        [self.topView addSubview:textLbl];
        [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@15);
            make.top.equalTo(lastLbl.mas_bottom).offset(15);
            
        }];
        lastLbl = textLbl;
    }];
    
    //交易金额
    self.amountLbl = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:kTextColor
                                                  font:15.0];
    
    self.amountLbl.textAlignment = NSTextAlignmentRight;
    [self.topView addSubview:self.amountLbl];
    [self.amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.top.equalTo(self.orderCodeLbl.mas_bottom).offset(15);

    }];
    
    //交易数量
    self.numLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    self.numLbl.textAlignment = NSTextAlignmentRight;
    
    [self.topView addSubview:self.numLbl];
    [self.numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.top.equalTo(self.amountLbl.mas_bottom).offset(15);
        
    }];
    
    //交易价格
    self.priceLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    self.priceLbl.textAlignment = NSTextAlignmentRight;
    [self.topView addSubview:self.priceLbl];
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.top.equalTo(self.numLbl.mas_bottom).offset(15);
        
    }];
    

    

    
}

- (void)initCenterView {
    
    self.centerView = [[UIView alloc] init];
    
    self.centerView.backgroundColor = kWhiteColor;
    
    [self addSubview:self.centerView];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.top.equalTo(self.topView.mas_bottom).offset(10);
        make.width.equalTo(@(kScreenWidth));
        //        make.height.equalTo(@155);
        
    }];
    
    //买家
    self.buyersLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    [self.centerView addSubview:self.buyersLbl];
    [self.buyersLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@15);
        
    }];
    
    //卖家
    self.sellerLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    self.sellerLbl.textAlignment = NSTextAlignmentRight;
    
    [self.centerView addSubview:self.sellerLbl];
    [self.sellerLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@15);
        make.right.equalTo(@(-15));
        
    }];
    
    //留言
    self.leaveMsgLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14.0];
    self.leaveMsgLbl.numberOfLines = 0;
    [self.centerView addSubview:self.leaveMsgLbl];
    [self.leaveMsgLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(self.buyersLbl.mas_bottom).offset(10);
        make.right.equalTo(@(-15));
        
    }];
    
    //分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kLineColor;
    [self.centerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.top.equalTo(self.leaveMsgLbl.mas_bottom).offset(13);
        make.height.equalTo(@0.5);
        
    }];
    
    //提示
    self.promptLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
    self.promptLbl.textAlignment = NSTextAlignmentCenter;
    [self.centerView addSubview:self.promptLbl];
    [self.promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(line.mas_bottom).offset(8);
        make.centerX.equalTo(@0);
        
    }];
    
    CGFloat btnH = BTN_HEIGHT;
    
    //按钮
    self.tradeBtn = [UIButton buttonWithTitle:@""
                                   titleColor:kWhiteColor
                              backgroundColor:kClearColor
                                    titleFont:16.0
                                 cornerRadius:btnH/2.0];
    [self.centerView addSubview:self.tradeBtn];
    [self.tradeBtn addTarget:self action:@selector(orderStatusDidChange:) forControlEvents:UIControlEventTouchUpInside];
    [self reAddTradeBtnLayout];
  
    
    //取消按钮
    self.cancleBtn = [UIButton buttonWithTitle:@"取消交易"
                                    titleColor:kWhiteColor
                               backgroundColor:[UIColor themeColor]
                                     titleFont:16.0
                                  cornerRadius:btnH/2.0];
    [self.centerView addSubview:self.cancleBtn];
    [self.cancleBtn addTarget:self action:@selector(buyCancel) forControlEvents:UIControlEventTouchUpInside];
 
    
}

@end
