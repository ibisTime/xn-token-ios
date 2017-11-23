//
//  ChatSystemFacePageView.h
//  TIMChat
//
//  Created by AlexiChen on 16/5/9.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatSystemFacePageView;
@protocol ChatSystemFaceInputDelegate <NSObject>

@required
// 按下情情符号
- (void)onInputSystemFace:(ChatSystemFaceItem *)item;
// 按下删除
- (void)onDelete;

@end

// 一排显示7个，显示3排，总共显示20个表情＋dele按钮
@interface ChatSystemFacePageView : UIView
{
@protected
    BOOL    _hasConfiged;
}
@property (nonatomic, weak) id<ChatSystemFaceInputDelegate> inputDelegate;

- (void)configStart:(NSInteger)index;

@end


@interface ChatSystemFaceView : PageScrollView<ChatInputAbleView>
{
@protected
    __weak id<ChatInputAbleViewDelegate> _chatDelegate;
    
@protected
    NSInteger   _contentHeight;
    
}

@property (nonatomic, weak) id<ChatInputAbleViewDelegate> chatDelegate;
@property (nonatomic, weak) id<ChatSystemFaceInputDelegate> inputDelegate;
@property (nonatomic, assign) NSInteger contentHeight;

@end
