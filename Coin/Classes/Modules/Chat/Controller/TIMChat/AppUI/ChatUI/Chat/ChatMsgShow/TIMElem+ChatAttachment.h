//
//  TIMElem+ChatTextAttachment.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/31.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <ImSDK/ImSDK.h>

// TIMElem可以转换成多个ChatTextAttachment，返回到界面并显示

@interface TIMElem (ChatAttachment)

// 返回多个NSMutableAttributedString

// 对应会话界面，最后一条消息
- (NSArray *)singleAttachmentOf:(IMAMsg *)msg;

// 对应聊天界面，输入框
- (NSArray *)inputAttachmentOf:(IMAMsg *)msg;

// 对应聊天界面的聊天内容
- (NSArray *)chatAttachmentOf:(IMAMsg *)msg;

@end

// 目前Demo只处理了以下这几种类型，用户可根据自身需要，补全所有类型elem的ChatAttachment类别

@interface TIMTextElem (ChatAttachment)

@end

@interface TIMImageElem (ChatAttachment)

@end

@interface TIMFaceElem (ChatAttachment)

@end

@interface TIMFileElem (ChatAttachment)

@end

@interface TIMSoundElem (ChatAttachment)

@end

@interface TIMLocationElem (ChatAttachment)

@end

@interface TIMUGCElem (ChatAttachment)

@end

@interface TIMGroupTipsElem (ChatAttachment)
@end

@interface TIMCustomElem (ChatAttachment)
@end


@interface TIMGroupSystemElem (ChatAttachment)

@end

@interface TIMSNSSystemElem (ChatAttachment)

@end

@interface TIMProfileSystemElem (ChatAttachment)

@end

