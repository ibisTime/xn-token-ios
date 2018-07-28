//
//  TLBaseVC.h
//  WeRide
//
//  Created by  tianlei on 2016/11/25.
//  Copyright © 2016年 trek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoinHeader.h"
#import "TLUser.h"
#import "TLDataBase.h"
#import "TLNavigationController.h"

@interface TLBaseVC : UIViewController

@property (nonatomic,strong) UIView *tl_placeholderView;

@property (nonatomic, strong) NSString *titleStr;


- (void)tl_placeholderOperation;


- (void)removePlaceholderView; //移除
- (void)addPlaceholderView; // 添加
//更新placeholderView
- (void)setPlaceholderViewTitle:(NSString *)title  operationTitle:(NSString *)optitle;

@end
