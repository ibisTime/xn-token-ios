//
//  TradeBuyView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AdvertiseModel.h"
#import "TLTextField.h"

typedef NS_ENUM(NSInteger, TradeBuyType) {
    
    TradeBuyTypeTrust = 0,      //信任
    TradeBuyTypeCancelTrust,    //取消信任
    TradeBuyTypeLink,           //联系对方
    TradeBuyTypeBuy,            //购买
};

typedef void(^TradeBuyBlock)(TradeBuyType tradeType);

@interface TradeBuyView : UIView

//
@property (nonatomic, strong) UIScrollView *scrollView;
//交易提醒
@property (nonatomic, strong) UIView *tradePromptView;
//CNY
@property (nonatomic, strong) TLTextField *cnyTF;
//ETH
@property (nonatomic, strong) TLTextField *ethTF;
//信任
@property (nonatomic, strong) UIButton *trustBtn;
//交易次数、信任次数、好评率和历史交易
@property (nonatomic, strong) NSMutableArray <UILabel *>*lblArr;

@property (nonatomic, strong) AdvertiseModel *advertise;

@property (nonatomic, copy) TradeBuyBlock tradeBlock;
//余额
@property (nonatomic, copy) NSString *leftAmount;
//交易总额
@property (nonatomic, copy) NSString *tradeAmount;
//真实行情价格
@property (nonatomic, strong) NSNumber *truePrice;
//是否信任它
@property (nonatomic, assign) BOOL isTrust;
//是否本人
@property (nonatomic, copy) NSString *userId;

@end
