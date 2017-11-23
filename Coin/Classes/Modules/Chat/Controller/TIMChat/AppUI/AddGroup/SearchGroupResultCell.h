//
//  SearchGroupResultCell.h
//  TIMChat
//
//  Created by wilderliao on 16/3/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchGroupResultCell : UITableViewCell
{
@protected
    UIImageView     *_groupIcon;
    UILabel         *_groupName;
    UILabel         *_groupId;
}

- (void)configInfo:(id<IMAGroupShowAble>)groupShowAble;
@end
