//
//  TextTableViewHeaderFooterView.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/15.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextTableViewHeaderFooterView : UITableViewHeaderFooterView
{
@protected
    InsetLabel      *_tipLabel;
}

@property (nonatomic, readonly) InsetLabel *tipLabel;

@end
