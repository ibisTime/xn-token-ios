//
//  TIMElemCellAble.h
//  TIMChat
//
//  Created by AlexiChen on 16/5/9.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TIMElemCellStype){
    TIMElemCell_C2C,
    TIMElemCell_Group,
};


@class IMAMsg;
@protocol TIMElemAbleCell <NSObject>

@required
// 构选方法
- (instancetype)initWithC2CReuseIdentifier:(NSString *)reuseIdentifier;
- (instancetype)initWithGroupReuseIdentifier:(NSString *)reuseIdentifier;

// 配置以及显示IMAMsg
@property (nonatomic, weak) IMAMsg *msg;
- (void)configWith:(IMAMsg *)msg;

// 显示Menu
- (BOOL)canShowMenu;
- (BOOL)canShowMenuOnTouchOf:(UIGestureRecognizer *)ges;
- (void)showMenu;
- (NSArray *)showMenuItems;
@end


@protocol TIMElemPickedAbleView <NSObject>

@property (nonatomic, assign) BOOL selected;

@end

@protocol TIMElemSendingAbleView <NSObject>

- (void)setMsgStatus:(NSInteger)status;

@end
