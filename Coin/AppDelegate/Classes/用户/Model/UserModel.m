//
//  UserModel.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/6.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (instancetype)user {
    
    static UserModel *user = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        user = [[UserModel alloc] init];
        
    });
    
    return user;
}

//设置行间距
+(NSMutableAttributedString *)ReturnsTheDistanceBetween:(NSString *)str
{
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为30
    [paragraphStyle  setLineSpacing:8];
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:str];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    return setString;
}


- (void)showPopAnimationWithAnimationStyle:(NSInteger)style showView:(UIView *)showView
{
    ZJAnimationPopStyle popStyle = (style == 8) ? ZJAnimationPopStyleCardDropFromLeft : (ZJAnimationPopStyle)style;
    ZJAnimationDismissStyle dismissStyle = (ZJAnimationDismissStyle)style;
    // 1.初始化
    ZJAnimationPopView *_popView = [[ZJAnimationPopView alloc] initWithCustomView:showView popStyle:popStyle dismissStyle:dismissStyle];
    self.cusPopView = _popView;
    _popView.isClickBGDismiss = ![showView isKindOfClass:[UIView class]];
    //    移除
    _popView.isClickBGDismiss = YES;
    // 2.2 显示时背景的透明度
    _popView.popBGAlpha = 0.5f;
    
    // 2.3 显示时是否监听屏幕旋转
    _popView.isObserverOrientationChange = YES;
    // 2.6 显示完成回调
    _popView.popComplete = ^{
        NSLog(@"显示完成");
    };
    // 2.7 移除完成回调
    _popView.dismissComplete = ^{
        NSLog(@"移除完成");
    };
    // 4.显示弹框
    [_popView pop];
}

@end
