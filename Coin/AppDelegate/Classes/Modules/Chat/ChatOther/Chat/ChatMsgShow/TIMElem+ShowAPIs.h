//
//  TIMElem+ShowAPIs.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/8.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <ImSDK/ImSDK.h>

// 界面上TIMElem显示相关的一些常用方法
// 因最初的版本只支持一个Message里面只有一个单个Elem，增加此套逻辑
// 后因增加富文本逻辑，部份消息（除TimeTip，GroupTip外的）均使用TIMElem
// 可通过IMAMsg的isMultiMsg方法，直接返回No，或修改kTestChatAttachment为0，即可看效果

@class IMAMsg;

@interface TIMElem (ShowAPIs)


// IMAMsg中只有一个Elem的时候有效，
- (Class)showCellClassOf:(IMAMsg *)msg;

// 消息在width下显示的size
- (CGSize)sizeInWidth:(CGFloat)width atMsg:(IMAMsg *)packMsg;

@end


@interface TIMTextElem (ShowAPIs)

@end





@interface TIMImageElem (ShowAPIs)

// 只存已发送或接收成功的
- (CGSize)getThumbShowSizeInMsg:(IMAMsg *)msg;

@end

@interface TIMFileElem (ShowAPIs)

@end

@interface TIMSoundElem (ShowAPIs)


@end

@interface TIMFaceElem (ShowAPIs)

@end

@interface TIMLocationElem (ShowAPIs)

@end

@interface TIMGroupTipsElem (ShowAPIs)


@end

@interface TIMUGCElem (ShowAPIs)

@end

@interface TIMCustomElem (ShowAPIs)

@end


@interface TIMGroupSystemElem (ShowAPIs)



@end

@interface TIMSNSSystemElem (ShowAPIs)

@end

@interface TIMProfileSystemElem (ShowAPIs)

@end
