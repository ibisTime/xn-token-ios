//
//  PublishSellView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PublishDraftModel.h"
#import "KeyValueModel.h"
#import "AdvertiseModel.h"

#import "TLTextField.h"
#import "TLPickerTextField.h"
#import "TLTextView.h"

typedef void(^PublishSellBlock)(PublishDraftModel *draft);

@interface PublishSellView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
//价格
@property (nonatomic, strong) TLTextField *priceTF;
//高级设置
@property (nonatomic, strong) UIView *highSettingView;
//付款期限
@property (nonatomic, strong) NSArray *timeArr;
//
@property (nonatomic, strong) TLTextView *leaveMsgTV;
//底部按钮
@property (nonatomic, strong) UIView *bottomView;
//溢价
@property (nonatomic, strong) TLTextField *premiumRateTF;
//最低价
@property (nonatomic, strong) TLTextField *lowNumTF;
//最小量
@property (nonatomic, strong) TLTextField *minNumTF;
//最大量
@property (nonatomic, strong) TLTextField *maxNumTF;
//购买总量
@property (nonatomic, strong) TLTextField *buyTotalTF;
//付款方式
@property (nonatomic, strong) TLPickerTextField *payTypePicker;
//付款期限
@property (nonatomic, strong) TLPickerTextField *payLimitPicker;
//付款方式选择
@property (nonatomic, assign) NSInteger payTypeIndex;

@property (nonatomic, copy) PublishSellBlock sellBlock;
//价格
@property (nonatomic, copy) NSString *marketPrice;
//提示
@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*values;

//广告
@property (nonatomic, strong) AdvertiseModel *advertise;

@end
