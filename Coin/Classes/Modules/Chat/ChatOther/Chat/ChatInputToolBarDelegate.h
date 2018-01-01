//
//  ChatInputToolBarDelegate.h
//  Coin
//
//  Created by  tianlei on 2018/1/01.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChatInputToolBar;
@protocol ChatInputToolBarDelegate <NSObject>

- (void)onToolBarClickEmoj:(ChatInputToolBar *)bar show:(BOOL)isShow;
- (void)onToolBarClickMore:(ChatInputToolBar *)bar show:(BOOL)isShow;

@end

@interface ChatInputToolBarDelegate : NSObject

@end
