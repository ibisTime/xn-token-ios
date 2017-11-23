//
//  FriendNotifyTableViewCell.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/23.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendNotifyTableViewCell : UITableViewCell
{
@protected
    UIImageView         *_icon;
    UILabel             *_title;
    UILabel             *_detail;
    UIButton            *_action;
}

- (void)onClickAction:(UIButton *)btn;

@end
