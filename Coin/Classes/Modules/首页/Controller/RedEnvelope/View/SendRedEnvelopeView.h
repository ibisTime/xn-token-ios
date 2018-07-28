//
//  SendRedEnvelopeView.h
//  Coin
//
//  Created by QinBao Zheng on 2018/7/2.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyModel.h"
#import "CustomActionSheet.h"
#import "RechargeCoinVC.h"
@protocol SendRedEnvelopeDelegate <NSObject>

-(void)SendRedEnvelopeButton:(NSInteger)tag currency:(NSString *)currency type:(NSString *)type count:(NSString *)count sendNum:(NSString *)sendNum greeting:(NSString *)greeting;



@end

@interface SendRedEnvelopeView : UIView<UITextFieldDelegate,CustomActionSheetDelagate>


@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*platforms;

@property (nonatomic, assign) id <SendRedEnvelopeDelegate> delegate;

@property (nonatomic , strong)UIImageView *HeadPortraitImage;

@property (nonatomic , strong)UIImageView *headImage;

@property (nonatomic , strong)UILabel *totalNumberLabel;

@property (nonatomic , strong)UILabel *total;

@property (nonatomic , strong) UIView * view1;
@property (nonatomic , strong) RechargeCoinVC *coinVC;

@property (nonatomic , copy)void (^transFormBlock)(CurrencyModel *model);

@property (nonatomic , copy)void (^redPackBlock)();

@end
