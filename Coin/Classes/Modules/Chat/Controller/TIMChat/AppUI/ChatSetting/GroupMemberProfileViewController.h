//
//  GroupMemberProfileViewController.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TableRefreshViewController.h"

@interface GroupMemberProfileViewController : RichItemTableViewController
{
@protected
    IMAGroupMember *_user;
    IMAGroup *_group;
}
- (instancetype)init:(IMAGroupMember *)groupMember groupInfo:(IMAGroup *)groupInfo;
@end
