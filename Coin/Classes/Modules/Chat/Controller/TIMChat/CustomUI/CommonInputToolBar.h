//
//  CommonInputToolBar.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/2.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonInputToolBar : UIToolbar
{
@protected
    MenuButton    *_complete;
}

- (instancetype)initWith:(MenuAction)action;

@end
