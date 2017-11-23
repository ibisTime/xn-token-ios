//
//  SwipeDeleteTableView.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/4.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SwipeDeleteAction)(NSIndexPath *index);

@interface SwipeDeleteTableView : UITableView <UIGestureRecognizerDelegate>

@end
