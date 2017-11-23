//
//  GroupTableViewCell.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupTableViewCell : UITableViewCell
{
@protected
    UIImageView *_icon;
    UILabel     *_title;
    UILabel     *_memberCount;
    
@protected
    __weak id<IMAGroupShowAble>  _group;
}

- (void)configWith:(id<IMAGroupShowAble>)g;




@end