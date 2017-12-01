//
//  UserProfileViewController.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "RichItemTableViewController.h"

@interface UserProfileViewController : RichItemTableViewController
{
@protected
    UIView  *_tableHeader;
    UIView  *_tableFooter;
    
@protected
    IMAUser *_user;
}

- (instancetype)initWith:(IMAUser *)user;



@end
