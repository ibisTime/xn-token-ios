//
//  OrderDetailHeaderView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderModel.h"
#import "ChatHeadRefreshView.h"


// 
typedef NS_ENUM(NSInteger, OrderEventsType) {
    
    
    OrderEventsTypeWillPay = 0,     //待支付
    OrderEventsTypeWillRelease = 1,     //待释放
    OrderEventsTypeWillComment = 2,     //待评价
    OrderEventsTypeDidComplete = 3,     //已完成
    OrderEventsTypeDidCancel = 4,       //已取消
    OrderEventsTypeArbitration = 5,     //仲裁中
    // 上面这些枚举的值要和 订单的状态对应起来，不要乱改，不然会死的很惨
    
    OrderEventsTypeBuyerCancel = 100 //买家取消
    
};

typedef void(^OrderEventsBlock)(OrderEventsType orderType);
@interface OrderDetailHeaderView : ChatHeadRefreshView

@property (nonatomic, strong) OrderModel *order;

//center
@property (nonatomic, strong) UIView *centerView;

//按钮
@property (nonatomic, strong) UIButton *tradeBtn;
//
@property (nonatomic, strong) UIButton *cancleBtn;
//提示
@property (nonatomic, strong) UILabel *promptLbl;

@property (nonatomic, copy) OrderEventsBlock orderBlock;

- (void)calculateInvalidTimeWithOrder:(OrderModel *)order;

@end
