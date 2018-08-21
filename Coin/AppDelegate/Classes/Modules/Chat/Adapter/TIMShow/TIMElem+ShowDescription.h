//
//  TIMElem+ShowDescription.h
//  TIMChat
//
//  Created by AlexiChen on 16/5/9.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <ImSDK/ImSDK.h>

// 界面上TIMElem显示相关的一些常用方法
// 因最初的版本只支持一个Message里面只有一个单个Elem，增加此套逻辑
// 后因增加富文本逻辑，部份消息（除TimeTip，GroupTip外的）均使用TIMElem
// 可通过IMAMsg的isMultiMsg方法，直接返回No，或修改kTestChatAttachment为0，即可看效果

@class IMAMsg;

@interface TIMElem (ShowDescription)

// 显示描述
- (NSString *)showDescriptionOf:(IMAMsg *)msg;

// 是否是系统表情
- (BOOL)isSystemFace;
@end


@interface TIMTextElem (ShowDescription)

@end


typedef void (^AsyncGetThumbImageBlock)(NSString *path, UIImage *image, BOOL succ, BOOL isAsync);


@interface TIMImageElem (ShowDescription)

- (void)asyncThumbImage:(AsyncGetThumbImageBlock)block inMsg:(IMAMsg *)msg;

// 获取消息的缓存图片
- (UIImage *)getThumbImageInMsg:(IMAMsg *)msg;

@end

@interface TIMFileElem (ShowDescription)

@end

@interface TIMSoundElem (ShowDescription)


@end

@interface TIMFaceElem (ShowDescription)

// 是否是系统表情
- (BOOL)isSystemFace;

@end

@interface TIMLocationElem (ShowDescription)

@end

@interface TIMGroupTipsElem (ShowDescription)

@property (nonatomic, strong) NSString *groupType;
// 群提醒消息
@property (nonatomic, strong) NSString *groupTip;

// 提示的文本
- (NSString *)tipText;

@end

@interface TIMUGCElem (ShowDescription)

@end

@interface TIMCustomElem (ShowDescription)

// 目前聊天界面用的时间戮是用TIMCustomElem
// 将要显示的时间转成Data
- (void)setFollowTime:(NSDate *)date;

// 显示的时间戮
- (NSString *)timeTip;

- (NSString *)revokedTip;

@end


@interface TIMGroupSystemElem (ShowDescription)



@end

@interface TIMSNSSystemElem (ShowDescription)

@end

@interface TIMProfileSystemElem (ShowDescription)

@end

