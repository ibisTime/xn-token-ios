//
//  ChatInputBaseView.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/17.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatInputBaseView : UIView<ChatInputAbleView>
{    
@protected
    __weak id<ChatInputAbleViewDelegate> _chatDelegate;
    
@protected
    NSInteger   _contentHeight;
    
}

@property (nonatomic, weak) id<ChatInputAbleViewDelegate> chatDelegate;
@property (nonatomic, assign) NSInteger contentHeight;

@end
