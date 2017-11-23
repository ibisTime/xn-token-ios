//
//  GroupSystemMsgViewController.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/1.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TableRefreshViewController.h"


@interface GroupSystemMsgTableViewCell: FriendNotifyTableViewCell
{
    @protected
    __weak TIMGroupPendencyItem *_item;
    
    UILabel *_applyInfo;
}

- (void)configWith:(TIMGroupPendencyItem *)item;
@end

@interface GroupSystemMsgViewController : TableRefreshViewController

@end


