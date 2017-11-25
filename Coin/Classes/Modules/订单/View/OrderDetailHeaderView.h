//
//  OrderDetailHeaderView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderModel.h"

typedef NS_ENUM(NSInteger, OrderEventsType) {
    
    OrderEventsTypeWillPay = 0,     //待支付
    OrderEventsTypeWillRelease,     //待释放
    OrderEventsTypeWillComment,     //待评价
    OrderEventsTypeDidComplete,     //已完成
    OrderEventsTypeDidCancel,       //已取消
    OrderEventsTypeArbitration,     //仲裁中
};

typedef void(^OrderEventsBlock)(OrderEventsType orderType);
@interface OrderDetailHeaderView : UIView

@property (nonatomic, strong) OrderModel *order;
//center
@property (nonatomic, strong) UIView *centerView;
//按钮
@property (nonatomic, strong) UIButton *tradeBtn;
//提示
@property (nonatomic, strong) UILabel *promptLbl;

@property (nonatomic, copy) OrderEventsBlock orderBlock;

- (void)calculateInvalidTimeWithOrder:(OrderModel *)order;

@end
