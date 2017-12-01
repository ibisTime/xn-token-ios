//
//  UserProfileHeaderView.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileHeaderView : UIView
{
@protected
    UIImageView *_icon;
    UILabel     *_title;
}

- (instancetype)initWith:(id<IMAUserShowAble>)item;
- (void)configWith:(id<IMAUserShowAble>)item;

@end
