//
//  PublishBuyView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishDraftModel.h"
#import "TLTextField.h"
#import "TLPickerTextField.h"
#import "TLTextView.h"

typedef void(^PublishBuyBlock)(PublishDraftModel *draft);

@interface PublishBuyView : UIView

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

@property (nonatomic, copy) PublishBuyBlock buyBlock;
//价格
@property (nonatomic, copy) NSString *marketPrice;

@end
