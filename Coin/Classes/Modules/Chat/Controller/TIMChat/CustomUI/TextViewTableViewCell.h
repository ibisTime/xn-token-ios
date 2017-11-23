//
//  TextViewTableViewCell.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/2.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewTableViewCell : UITableViewCell<UITextViewDelegate>
{
@protected
    UIPlaceHolderTextView *_edit;
}

@property (nonatomic, readonly) UIPlaceHolderTextView *edit;

@property (nonatomic, assign) UIEdgeInsets marginInset;

@end
