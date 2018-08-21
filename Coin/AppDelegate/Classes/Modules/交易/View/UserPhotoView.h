//
//  UserPhotoView.h
//  Coin
//
//  Created by  tianlei on 2017/12/19.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface UserPhotoView : UIView

+ (instancetype)photoView;
//- (instancetype)initWithFrame:(CGRect)frame;
//- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;
@property (nonatomic, strong) UserInfo *userInfo;

@end
