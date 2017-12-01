//
//  UserActionButton.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "MenuButton.h"


@interface UserActionItem : MenuItem

@property (nonatomic, strong) UIImage *normalBack;
@property (nonatomic, strong) UIImage *highlightBack;

@end

@interface UserActionButton : MenuButton

- (instancetype)initWithAction:(UserActionItem *)item;

@end
