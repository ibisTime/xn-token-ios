//
//  ChatTextView.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/31.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

// 作图文混排
// 目前只支持的系统表情图片，以及TIMImageElem的图片

@interface ChatTextView : UITextView
{
@private
    __weak IMAMsg *_msgRef;
}

- (void)clearAll;
- (void)showMessage:(IMAMsg *)msg;


// for overwrite
- (void)onTapImage:(UITapGestureRecognizer *)tap;

@end
