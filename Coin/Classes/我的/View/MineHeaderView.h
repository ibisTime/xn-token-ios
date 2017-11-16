//
//  MineHeaderView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MineHeaderSeletedType) {

    MineHeaderSeletedTypePhoto, //头像
    MineHeaderSeletedTypeBuy,   //购买
    MineHeaderSeletedTypeSell,  //出售
    
};

@protocol MineHeaderSeletedDelegate <NSObject>

- (void)didSelectedWithType:(MineHeaderSeletedType)type;

@end

@interface MineHeaderView : UIView

@property (nonatomic, weak) id<MineHeaderSeletedDelegate> delegate;
//头像
@property (nonatomic, strong) UIButton *photoBtn;
//昵称
@property (nonatomic, strong) UILabel *nameLbl;
//交易、好评跟信任
@property (nonatomic, strong) UILabel *dataLbl;

@end
