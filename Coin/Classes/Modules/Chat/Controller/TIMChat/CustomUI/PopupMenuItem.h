//
//  PopupMenuItem.h
//  TIMChat
//
//  Created by AlexiChen on 16/2/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "MenuItem.h"

@interface PopupMenuItem : MenuItem

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) NSTextAlignment alignment;
@property (nonatomic, strong) UIColor  *foreColor;

@end
