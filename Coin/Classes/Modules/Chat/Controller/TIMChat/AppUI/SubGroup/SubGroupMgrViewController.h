//
//  SubGroupMgrViewController.h
//  TIMChat
//
//  Created by AlexiChen on 16/2/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

//#import "BaseViewController.h"

@interface SubGroupMgrViewController : TableRefreshViewController<UIAlertViewDelegate>
{
    __weak CLSafeMutableArray *_subGroups;
}

@end
