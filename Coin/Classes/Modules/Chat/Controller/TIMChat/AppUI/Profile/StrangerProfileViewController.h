//
//  StrangerProfileViewController.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/4.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "UserProfileViewController.h"

@interface StrangerProfileViewController : UserProfileViewController
{
@protected
    IMASubGroup    *_selectedSubGroup;
}

@property (nonatomic, strong) IMASubGroup *selectedSubGroup;
@end
