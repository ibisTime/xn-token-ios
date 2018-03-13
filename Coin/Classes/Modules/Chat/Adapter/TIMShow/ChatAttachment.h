//
//  ChatAttachment.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/31.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

// 将TIMElem转换成对应的富文本进行显示

typedef void (^ChatGetImageBlock)(UIImage *image);
@interface ChatImageAttachment : NSTextAttachment
{
@protected
    NSString     *_tag;                                             // 要显示的文本内容
    TIMElem      *_elemRef;                                         // 要显示的Element
 }
@property (nonatomic, strong) TIMElem           *elemRef;
@property (nonatomic, strong) NSString          *tag;               // 用于替换显示的tag

- (instancetype)initWith:(TIMElem *)elem;

@end