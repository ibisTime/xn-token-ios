//
//  TradeSellView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AdvertiseModel.h"
#import "TLTextField.h"

typedef NS_ENUM(NSInteger, TradeSellType) {
    
    TradeSellTypeTrust = 0,      //信任
    TradeSellTypeCancelTrust,    //取消信任
    TradeSellTypeLink,           //联系对方
    TradeSellTypeSell,           //卖出
    TradeSellTypeHomePage,       //个人主页
};

typedef void(^TradeSellBlock)(TradeSellType tradeType);

@interface TradeSellView : UIView

//
@property (nonatomic, strong) UIScrollView *scrollView;
//交易提醒
@property (nonatomic, strong) UIView *tradePromptView;
//CNY
@property (nonatomic, strong) TLTextField *cnyTF;
//ETH
@property (nonatomic, strong) TLTextField *ethTF;

//交易次数、信任次数、好评率和历史交易
@property (nonatomic, strong) NSMutableArray <UILabel *>*lblArr;

@property (nonatomic, strong) AdvertiseModel *advertise;

@property (nonatomic, copy) TradeSellBlock tradeBlock;
//余额
@property (nonatomic, copy) NSString *leftAmount;
//真实行情价格
@property (nonatomic, strong) NSNumber *truePrice;

//是否本人
@property (nonatomic, copy) NSString *userId;
//交易总额
@property (nonatomic, copy) NSString *tradeAmount;
//交易数量
@property (nonatomic, copy) NSString *tradeNum;
//交易提醒
@property (nonatomic, copy) NSString *tradeRemind;
//
@property (nonatomic, strong) UILabel *tradeTextLbl;

@end
