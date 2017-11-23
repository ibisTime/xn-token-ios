//
//  ChatTextView.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/31.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ChatTextView.h"

@implementation ChatTextView

- (instancetype)init
{
    if (self = [super init])
    {
        // 只用于显示
        self.editable = NO;
        self.scrollEnabled = NO;
        self.selectable = NO;
        self.contentInset = UIEdgeInsetsZero;
        self.textContainerInset = UIEdgeInsetsZero;
        self.scrollIndicatorInsets = UIEdgeInsetsZero;
        self.textContainer.lineFragmentPadding = 0;
    }
    return self;
}

- (void)clearAll
{
    self.text = nil;
    self.attributedText = nil;
    
    // 添空内部的图片
    for (UIView* subView in self.subviews)
    {
        if ([subView isKindOfClass:[UIImageView class]])
        {
            [subView removeFromSuperview];
        }
    }
}

- (BOOL)enableLongPressed
{
    return NO;
}

- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    //Prevent zooming but not panning
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
    {
        gestureRecognizer.enabled = [self enableLongPressed];
    }
    [super addGestureRecognizer:gestureRecognizer];
}

- (void)showMessage:(IMAMsg *)msg
{
    [self clearAll];
    [self.textStorage insertAttributedString:msg.showChatAttributedText atIndex:self.selectedRange.location];
    _msgRef = msg;
//    __weak ChatTextView *ws = self;
//    [self.textStorage enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSTextAttachment *attrs, NSRange range, BOOL * _Nonnull stop) {
//        ChatImageAttachment *imgatt = (ChatImageAttachment *)attrs;
//        if (imgatt)
//        {
//            
//            //            ws.selectedRange = range;
//            TIMElem *elem = imgatt.elemRef;
//            
//            if ([elem isSystemFace])
//            {
////                // 支持GiF表情
////                TIMFaceElem *face = (TIMFaceElem *)elem;
////                ChatSystemFaceItem *item = [[ChatSystemFaceHelper sharedHelper] emojiItemOf:face.index];
////                UIImageView *imageView = [[UIImageView alloc] init];
////                [ws addSubview:imageView];
////                imageView.image = [UIImage sd_animatedGIFNamed:[item gifName]];
////
////                UITextPosition *beginning = ws.beginningOfDocument;
////                UITextPosition *start = [ws positionFromPosition:beginning offset:range.location];
////                CGRect rect =  [ws caretRectForPosition:start];
////
////                imageView.frame = CGRectMake(rect.origin.x, rect.origin.y, imgatt.bounds.size.width, imgatt.bounds.size.height);
//            }
//            else
//            {
//                // 普通图片
//                UIImageView *imageView = [[UIImageView alloc] init];
//                [ws addSubview:imageView];
//                imageView.image = imgatt.image;
//                imageView.backgroundColor = kRedColor;
//                
//                UITextPosition *beginning = ws.beginningOfDocument;
//                UITextPosition *start = [ws positionFromPosition:beginning offset:range.location];
//                CGRect rect =  [ws caretRectForPosition:start];
//                
//                imageView.frame = CGRectMake(rect.origin.x, rect.origin.y, imgatt.bounds.size.width, imgatt.bounds.size.height);
//                
//                imageView.userInteractionEnabled = YES;
//                
//                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImage:)];
//                tap.numberOfTapsRequired = 1;
//                tap.numberOfTouchesRequired = 1;
//                [imageView addGestureRecognizer:tap];
//            }
//        }
//        
//        
//    }];
    
    self.selectedRange = NSMakeRange(self.selectedRange.location + 1, self.selectedRange.length);
    
}

- (void)onTapImage:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        
        UIImageView *imageView = (UIImageView *)tap.view;
        UIView *keyWindow = [UIApplication sharedApplication].keyWindow;
        CGRect rect = [imageView relativePositionTo:keyWindow];
        ChatImageBrowserView *view = [[ChatImageBrowserView alloc] initWithPicModel:_msgRef thumbnail:imageView.image fromRect:rect];
        [keyWindow addSubview:view];
        
    }
}

// 作用是屏蔽UITextView长按，双击等显示菜单问题
- (BOOL)shouldPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return [self shouldPerformAction:action withSender:sender];
}

- (BOOL)canBecomeFirstResponder
{
    return [self shouldPerformAction:nil withSender:nil];
}
//
//- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
//{
//    DebugLog(@"%@", URL);
////    // 跳到对应人的空间
////    UserInfo *host = [[UserInfo alloc] init];
////    host.avatar = _item.replyForUserAvatar;
////    host.username = _item.replyForUserName;
////    host.uid =  _item.replyForUserId;
////
////    HostHomeViewController *vc = [[HostHomeViewController alloc] initWith:host];
////    [[AppDelegate sharedAppDelegate] pushViewController:vc];
//    
//    return NO;
//}




@end
