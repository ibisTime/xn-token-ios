//
//  HomePageHeaderView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/12/7.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AdvertiseModel.h"
#import "UserRelationModel.h"
#import "TLUser.h"

typedef NS_ENUM(NSInteger, HomePageType) {
    
    HomePageTypeBlackList = 0,      //黑名单
    HomePageTypeCancelBlackList,    //取消黑名单
    HomePageTypeTrust,              //信任
    HomePageTypeCancelTrust,        //取消信任
    HomePageTypeBack,               //返回
};

typedef void(^HomePageBlock)(HomePageType type);

@interface HomePageHeaderView : UIView

@property (nonatomic, copy) HomePageBlock pageBlock;
//背景
@property (nonatomic, strong) UIImageView *bgIV;
//信任
@property (nonatomic, strong) UIButton *trustBtn;
//黑名单
@property (nonatomic, strong) UIButton *blackListBtn;
//广告
//@property (nonatomic, strong) AdvertiseModel *advertise;
@property (nonatomic, strong) TLUser *currentUser;

//用户关系
@property (nonatomic, strong) UserRelationModel *relation;
//是否信任它
@property (nonatomic, assign) BOOL isTrust;
//是否添加黑名单
@property (nonatomic, assign) BOOL isBlack;
//是否本人
@property (nonatomic, copy) NSString *userId;
//交易总额
@property (nonatomic, copy) NSString *tradeAmount;

@end
