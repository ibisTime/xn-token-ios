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
    
    TradeBuyTypeLink,           //联系对方
    TradeBuyTypeBuy,            //购买
    TradeBuyTypeHomePage,       //个人主页
};

typedef void(^TradeBuyBlock)(TradeBuyType tradeType);

@interface TradeBuyView : UIView

//
@property (nonatomic, strong) UIScrollView *scrollView;
//交易提醒
@property (nonatomic, strong) UIView *tradePromptView;


//暴露出  2  两种金额
@property (nonatomic, strong) TLTextField *cnyTF;
@property (nonatomic, strong) TLTextField *ethTF;



@property (nonatomic, strong) AdvertiseModel *advertise;

@property (nonatomic, copy) TradeBuyBlock tradeBlock;
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
