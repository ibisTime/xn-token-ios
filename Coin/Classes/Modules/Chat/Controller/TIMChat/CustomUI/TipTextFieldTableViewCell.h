//
//  TipTextFieldTableViewCell.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/2.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TextFieldTableViewCell.h"

@interface TipTextFieldTableViewCell : TextFieldTableViewCell
{
@protected
    UILabel         *_tip;
}

@property (nonatomic, assign)   NSInteger   horMargin;
@property (nonatomic, assign)   NSInteger   tipWidth;
@property (nonatomic, readonly) UILabel     *tip;



@end
