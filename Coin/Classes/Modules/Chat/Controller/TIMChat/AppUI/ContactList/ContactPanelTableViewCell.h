//
//  ContactPanelTableViewCell.h
//  TIMChat
//
//  Created by AlexiChen on 16/2/18.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactPanelTableViewCell : UITableViewCell
{
@protected
    ImageTitleButton    *_newFriendBtn;
    ImageTitleButton    *_publicGroupBtn;
    ImageTitleButton    *_chatGroupBtn;
    ImageTitleButton    *_chatRoomBtn;
}

@end
