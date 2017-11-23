//
//  GroupMemberInfoCell.h
//  TIMChat
//
//  Created by wilderliao on 16/3/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupMemberInfoCell : UITableViewCell
{
@protected
    UIImageView     *_memberIcon;
    UILabel         *_memberName;
    
@protected
    __weak IMAGroupMember  *_user;
}

- (void)configWith:(IMAGroupMember *)user;

@end
