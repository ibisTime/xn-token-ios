//
//  UserProfileFooterPanel.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UserProfileFooterPanel : UIView

@property (nonatomic, assign) NSInteger horMarin;
   


- (instancetype)initWith:(NSArray *)actionItems;

- (void)replaceWith:(NSArray *)actionItems;

@end
