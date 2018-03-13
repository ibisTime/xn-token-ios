//
//  TIMElem+ShowDescription.m
//  TIMChat
//
//  Created by AlexiChen on 16/5/9.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TIMElem+ShowDescription.h"

@implementation TIMElem (ShowDescription)
// 显示描述
- (NSString *)showDescriptionOf:(IMAMsg *)msg
{
    return [self description];
}

// 是否是系统表情
- (BOOL)isSystemFace
{
    return NO;
}
@end


@implementation TIMTextElem (ShowDescription)
// 显示描述
- (NSString *)showDescriptionOf:(IMAMsg *)msg
{
    return [self text];
}

@end



@implementation TIMImageElem (ShowDescription)

- (UIImage *)getThumbImageInMsg:(IMAMsg *)msg
{
    NSString *thumpPath = [msg stringForKey:kIMAMSG_Image_ThumbPath];
    if ([PathUtility isExistFile:thumpPath])
    {
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:thumpPath];
        return img;
    }
    
    if (self.imageList.count > 0)
    {
        for (TIMImage *timImage in self.imageList)
        {
            if (timImage.type == TIM_IMAGE_TYPE_THUMB)
            {
                // 解析大小
                NSInteger width = timImage.width;
                NSInteger height = timImage.height;
                
                CGFloat scale = 1;
                scale = MIN(kChatPicThumbMaxHeight/height, kChatPicThumbMaxWidth/width);
                
                
                NSInteger tw = (NSInteger) (width * scale + 1);
                NSInteger th = (NSInteger) (height * scale + 1);
                [msg addInteger:tw forKey:kIMAMSG_Image_ThumbWidth];
                [msg addInteger:th forKey:kIMAMSG_Image_ThumbHeight];
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *nsTmpDir = NSTemporaryDirectory();
                NSString *imageThumbPath = [NSString stringWithFormat:@"%@/image_%@_ThumbImage", nsTmpDir, timImage.uuid];
                BOOL isDirectory = NO;
                
                if ([fileManager fileExistsAtPath:imageThumbPath isDirectory:&isDirectory]  && isDirectory == NO)
                {
                    // 本地存在
                    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageThumbPath];
                    [msg addString:imageThumbPath forKey:kIMAMSG_Image_ThumbPath];
                    return image;
                    
                }
                
                
                break;
            }
        }
    }
    
    return nil;
}

- (void)asyncThumbImage:(AsyncGetThumbImageBlock)block inMsg:(IMAMsg *)msg
{
    if (!block)
    {
        return;
    }
    
    // 本地存在
    NSString *thumpPath = [msg stringForKey:kIMAMSG_Image_ThumbPath];
    if ([PathUtility isExistFile:thumpPath])
    {
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:thumpPath];
        block(thumpPath, img, YES, NO);
        return;
    }
    
    if (self.imageList.count > 0)
    {
        for (TIMImage *timImage in self.imageList)
        {
            if (timImage.type == TIM_IMAGE_TYPE_THUMB)
            {
                // 解析大小
                NSInteger width = timImage.width;
                NSInteger height = timImage.height;
                NSString *url = timImage.url;
                
                CGFloat scale = 1;
                scale = MIN(kChatPicThumbMaxHeight/height, kChatPicThumbMaxWidth/width);
                
                
                NSInteger tw = (NSInteger) (width * scale + 1);
                NSInteger th = (NSInteger) (height * scale + 1);
                [msg addInteger:tw forKey:kIMAMSG_Image_ThumbWidth];
                [msg addInteger:th forKey:kIMAMSG_Image_ThumbHeight];
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *nsTmpDir = NSTemporaryDirectory();
                NSString *imageThumbPath = [NSString stringWithFormat:@"%@/image_%@_ThumbImage", nsTmpDir, timImage.uuid];
                BOOL isDirectory = NO;
                
                if ([fileManager fileExistsAtPath:imageThumbPath isDirectory:&isDirectory]  && isDirectory == NO)
                {
                    // 本地存在
                    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageThumbPath];
                    [msg addString:imageThumbPath forKey:kIMAMSG_Image_ThumbPath];
                    
                    block(url, image, YES, NO);
                }
                else
                {
                    // 本地不存在，下载原图
                    [timImage getImage:imageThumbPath succ:^{
                        UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageThumbPath];
                        block(url, image, YES, YES);
                    } fail:^(int code, NSString *err) {
                        block(url, nil, NO, YES);
                    }];
                }
                
                break;
            }
        }
    }
    
    
    NSString *filePath = self.path;
    if (![NSString isEmpty:filePath])
    {
        // NSString *filePath = [NSString stringWithFormat:@"%@uploadFile%3.f_Size_%d_%d", nsTmpDIr, [NSDate timeIntervalSinceReferenceDate], (int)picThumbWidth, (int)picThumbHeight];
        // 检查本地是否存储了
        BOOL exist = [PathUtility isExistFile:filePath];
        if (exist)
        {
            // 原图地址
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
            
            CGFloat scale = 1;
            scale = MIN(kChatPicThumbMaxHeight/image.size.height, kChatPicThumbMaxWidth/image.size.width);
            
            CGFloat picHeight = image.size.height;
            CGFloat picWidth = image.size.width;
            NSInteger width = (NSInteger) (picWidth * scale + 1);
            NSInteger height = (NSInteger) (picHeight * scale + 1);
            
            image = [image thumbnailWithSize:CGSizeMake(width, height)];
            block(filePath, image, YES, NO);
            
            [msg addInteger:width forKey:kIMAMSG_Image_ThumbWidth];
            [msg addInteger:height forKey:kIMAMSG_Image_ThumbHeight];
            
            NSString *nsTmpDIr = NSTemporaryDirectory();
            NSString *imageThumbPath = [NSString stringWithFormat:@"%@uploadFile%3.f", nsTmpDIr, [NSDate timeIntervalSinceReferenceDate]];
            
            [[NSFileManager defaultManager] createFileAtPath:imageThumbPath contents:UIImageJPEGRepresentation(image, 1) attributes:nil];
        }
    }
    else
    {
        DebugLog(@"逻辑不可达");
        
    }
}


// 显示描述
- (NSString *)showDescriptionOf:(IMAMsg *)msg
{
    return @"[图片]";
}



@end

@implementation TIMFileElem (ShowDescription)
// 显示描述
- (NSString *)showDescriptionOf:(IMAMsg *)msg
{
    return @"[文件]";
}


@end

@implementation TIMSoundElem (ShowDescription)


// 显示描述
- (NSString *)showDescriptionOf:(IMAMsg *)msg
{
    return @"[语音]";
}
@end

@implementation TIMFaceElem (ShowDescription)


// 是否是系统表情(QQ自带的表情)
- (BOOL)isSystemFace
{
    // 目前没有做自定义表情，所以全问都是系统表情
    // 用户可根据自身业务逻辑修改此处
    return YES;
}

// 显示描述
- (NSString *)showDescriptionOf:(IMAMsg *)msg
{
    // 后面转成对应的描述信息
    return @"[表情]";
}
@end

@implementation TIMLocationElem (ShowDescription)
// 显示描述
- (NSString *)showDescriptionOf:(IMAMsg *)msg
{
    // 后面转成对应的描述信息
    return @"[位置]";
}
@end

@implementation TIMGroupTipsElem (ShowDescription)

static NSString *const kGroupTipKey = @"kGroupTipKey";
static NSString *const kGroupTypeKey = @"kGroupTypeKey";


- (void)setGroupTip:(NSString *)groupTip
{
    objc_setAssociatedObject(self, (__bridge const void *)kGroupTipKey, groupTip, OBJC_ASSOCIATION_COPY);
}

- (NSString *)groupTip
{
    return objc_getAssociatedObject(self, (__bridge const void *)kGroupTipKey);
}

- (void)setGroupType:(NSString *)groupType
{
    objc_setAssociatedObject(self, (__bridge const void *)kGroupTypeKey, groupType, OBJC_ASSOCIATION_COPY);
}

- (NSString *)groupType
{
    return objc_getAssociatedObject(self, (__bridge const void *)kGroupTypeKey);
}


- (NSString *)tipText
{
    if ([NSString isEmpty:self.groupType])
    {
        IMAGroup *group = (IMAGroup *)[[IMAPlatform sharedInstance].contactMgr getUserByGroupId:self.group];
        if ([group isPublicGroup])
        {
            self.groupType = @"群";
        }
        else if ([group isChatGroup])
        {
            self.groupType = @"讨论组";
        }
        else if ([group isChatRoom])
        {
            self.groupType = @"聊天室";
        }
    }
    
    
    if (![NSString isEmpty:self.groupTip])
    {
        return self.groupTip;
    }
    
    NSString *opStr = nil;
    NSString *endStr = nil;
    switch (self.type)
    {
        case TIM_GROUP_TIPS_TYPE_QUIT_GRP:
        {
            self.groupTip = [NSString stringWithFormat:@"%@退出了%@", self.opUser, self.groupType];
            return self.groupTip;
        }
            break;
        case TIM_GROUP_TIPS_TYPE_MEMBER_INFO_CHANGE:
        {
            NSMutableString *tip = [NSMutableString string];
            NSArray *array = [self memberChangeList];
            
            for (TIMGroupTipsElemMemberInfo *info in array)
            {
                if (![NSString isEmpty:tip])
                {
                    [tip appendString:@"\n"];
                }
                NSLog(@"info.shutupTime = %d",info.shutupTime);
                
                if (info.shutupTime==0)
                {
                    [tip appendString:[NSString stringWithFormat:@"%@的禁言限制已取消", info.identifier]];
                }
                else
                {
                    [tip appendString:[NSString stringWithFormat:@"%@被禁言%d秒", info.identifier, info.shutupTime]];
                }
            }
            
            self.groupTip = tip;
            return self.groupTip;
        }
            break;
        case TIM_GROUP_TIPS_TYPE_INFO_CHANGE:
        {
            NSMutableString *tip = [NSMutableString string];
            NSArray *array = [self groupChangeList];
            
            for (TIMGroupTipsElemGroupInfo *info in array)
            {
                if (![NSString isEmpty:tip])
                {
                    [tip appendString:@"\n"];
                }
                
                switch (info.type)
                {
                    case TIM_GROUP_INFO_CHANGE_GROUP_NAME:
                    {
                        [tip appendString:[NSString stringWithFormat:@"%@修改%@名称为%@", self.opUser, self.groupType, info.value]];
                    }
                        break;
                    case TIM_GROUP_INFO_CHANGE_GROUP_INTRODUCTION:
                    {
                        [tip appendString:[NSString stringWithFormat:@"%@修改了%@介绍", self.opUser, self.groupType]];
                    }
                        break;
                    case TIM_GROUP_INFO_CHANGE_GROUP_NOTIFICATION:
                    {
                        [tip appendString:[NSString stringWithFormat:@"%@修改了%@公告", self.opUser, self.groupType]];
                    }
                        break;
                    case TIM_GROUP_INFO_CHANGE_GROUP_FACE:
                    {
                        [tip appendString:[NSString stringWithFormat:@"%@修改%@头像", self.opUser, self.groupType]];
                    }
                        break;
                    case TIM_GROUP_INFO_CHANGE_GROUP_OWNER:
                    {
                        // TODO：暂不支持该接口
                        [tip appendString:[NSString stringWithFormat:@"%@已转让%@", self.opUser, self.groupType]];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            
            self.groupTip = tip;
            return self.groupTip;
        }
            break;
        case TIM_GROUP_TIPS_TYPE_INVITE:
        {
            opStr = @"邀请";
            endStr = [NSString stringWithFormat:@"进%@", self.groupType];
        }
            break;
            
        case TIM_GROUP_TIPS_TYPE_KICKED:
        {
            opStr = @"踢";
            endStr = [NSString stringWithFormat:@"出%@", self.groupType];
        }
            break;
        case TIM_GROUP_TIPS_TYPE_SET_ADMIN:
        {
            opStr = @"设置";
            endStr = @"为管理员";
        }
            break;
        case TIM_GROUP_TIPS_TYPE_CANCEL_ADMIN:
        {
            opStr = @"取消";
            endStr = @"管理员身份";
        }
            break;
            
        default:
            break;
    }
    NSMutableString *userListString = [NSMutableString string];
    for (NSString *uid in self.userList)
    {
        [userListString appendString:uid];
        [userListString appendString:@"，"];
    }
    if (userListString.length > 1)
    {
        [userListString deleteCharactersInRange:NSMakeRange(userListString.length - 1, 1)];
    }
    self.groupTip = [NSString stringWithFormat:@"%@%@%@%@", self.opUser, opStr, userListString, endStr];
    return self.groupTip;
}

// 显示描述
- (NSString *)showDescriptionOf:(IMAMsg *)msg
{
    // 后面转成对应的描述信息
    return @"[群提醒]";
}
@end

@implementation TIMUGCElem (ShowDescription)
// 显示描述
- (NSString *)showDescriptionOf:(IMAMsg *)msg
{
    // 后面转成对应的描述信息
    return @"[视频]";
}
@end


@implementation TIMCustomElem (ShowDescription)

- (void)setFollowTime:(NSDate *)date
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:date];
    self.data = data;
}

- (NSDate *)getFollowTime
{
    NSDate *date = [NSKeyedUnarchiver unarchiveObjectWithData:self.data];
    return date;
}

// 显示描述
- (NSString *)showDescriptionOf:(IMAMsg *)msg
{
    // 后面转成对应的描述信息
    return @"[自定义消息]";
}

- (NSString *)timeTip
{
    NSDate *date = [self getFollowTime];
    return [date timeTextOfDate];
}

- (NSString *)revokedTip
{
    return @"撤回了一条消息";
}
@end


@implementation TIMGroupSystemElem (ShowDescription)
// 显示描述
- (NSString *)showDescriptionOf:(IMAMsg *)msg
{
    // 后面转成对应的描述信息
    NSMutableString *retStr = [NSMutableString string];
    switch (self.type)
    {
            /**
             *  申请加群请求（只有管理员会收到）
             */
        case TIM_GROUP_SYSTEM_ADD_GROUP_REQUEST_TYPE://              = 0x01,
        {
            [retStr appendFormat:@"%@申请加入群%@请求", self.user, self.group];
        }
            break;
            /**
             *  申请加群被同意（只有申请人能够收到）
             */
            
        case TIM_GROUP_SYSTEM_ADD_GROUP_ACCEPT_TYPE://                           = 0x02,
        {
            [retStr appendFormat:@"%@同意你加入群%@请求", self.user, self.group];
        }
            break;
            
            /**
             *  申请加群被拒绝（只有申请人能够收到）
             */
        case TIM_GROUP_SYSTEM_ADD_GROUP_REFUSE_TYPE://               = 0x03,
        {
            [retStr appendFormat:@"%@拒绝你加入群%@请求", self.user, self.group];
            if (self.msg.length)
            {
                [retStr appendFormat:@" 理由:%@", self.msg];
            }
        }
            break;
            
            /**
             *  被管理员踢出群（只有被踢的人能够收到）
             */
        case TIM_GROUP_SYSTEM_KICK_OFF_FROM_GROUP_TYPE://            = 0x04,
        {
            [retStr appendFormat:@"您被%@踢出群%@", self.user, self.group];
        }
            break;
            /**
             *  群被解散（全员能够收到）
             */
        case TIM_GROUP_SYSTEM_DELETE_GROUP_TYPE://                   = 0x05,
        {
            [retStr appendFormat:@"%@解散群%@", self.user, self.group];
        }
            break;
            /**
             *  创建群消息（创建者能够收到）
             */
        case TIM_GROUP_SYSTEM_CREATE_GROUP_TYPE://                   = 0x06,
        {
            [retStr appendFormat:@"%@创建群%@成功", self.user, self.group];
        }
            break;
            /**
             *  邀请入群通知(被邀请者能够收到)
             */
        case TIM_GROUP_SYSTEM_INVITED_TO_GROUP_TYPE://               = 0x07,
        {
            [retStr appendFormat:@"%@邀请你加入群%@", self.user, self.group];
        }
            break;
            
            /**
             *  主动退群（主动退群者能够收到）
             */
        case TIM_GROUP_SYSTEM_QUIT_GROUP_TYPE://                     = 0x08
        {
            [retStr appendFormat:@"%@退群%@成功", self.user, self.group];
        }
            break;
            /**
             *  设置管理员(被设置者接收)
             */
        case TIM_GROUP_SYSTEM_GRANT_ADMIN_TYPE://                    = 0x09,
        {
            [retStr appendFormat:@"%@设置你为群%@管理员", self.user, self.group];
        }
            break;
            
            /**
             *  取消管理员(被取消者接收)
             */
        case TIM_GROUP_SYSTEM_CANCEL_ADMIN_TYPE://                   = 0x0a,
        {
            [retStr appendFormat:@"%@取消你群%@管理员资格", self.user, self.group];
        }
            break;
            /**
             *  群已被回收(全员接收)
             */
        case TIM_GROUP_SYSTEM_REVOKE_GROUP_TYPE://                           = 0x0b,
        {
            [retStr appendFormat:@"群%@已被回收",  self.group];
        }
            break;
            /**
             *  邀请入群请求(被邀请者接收)
             */
        case TIM_GROUP_SYSTEM_INVITE_TO_GROUP_REQUEST_TYPE://                           = 0x0c,
        {
            [retStr appendFormat:@"%@邀请你加入群%@", self.user, self.group];
        }
            break;
            /**
             *  邀请加群被同意(只有发出邀请者会接收到)
             */
        case TIM_GROUP_SYSTEM_INVITE_TO_GROUP_ACCEPT_TYPE://                     = 0x0d,
        {
            [retStr appendFormat:@"%@同意你发出的加入群%@的邀请", self.user, self.group];
        }
            break;
            /**
             *  邀请加群被拒绝(只有发出邀请者会接收到)
             */
        case TIM_GROUP_SYSTEM_INVITE_TO_GROUP_REFUSE_TYPE://         = 0x0e,
        {
            [retStr appendFormat:@"%@拒绝你发出的加入群%@的邀请", self.user, self.group];
        }
            break;
            
            
        default:
            break;
    }
    
    return retStr;
    
}


@end


@implementation TIMSNSSystemElem (ShowDescription)

// 显示描述
- (NSString *)showDescriptionOf:(IMAMsg *)msg
{
    NSMutableString *retStr = [NSMutableString string];
    switch (self.type)
    {
            /**
             *  增加好友消息
             */
        case TIM_SNS_SYSTEM_ADD_FRIEND://                           = 0x01,
        {
            for (TIMSNSChangeInfo *info in self.users)
            {
                [retStr appendFormat:@"%@添加你为好友\n", info.nickname.length > 0 ? info.nickname : info.identifier];
            }
        }
            break;
            /**
             *  删除好友消息
             */
        case TIM_SNS_SYSTEM_DEL_FRIEND://                           = 0x02,
        {
            for (TIMSNSChangeInfo *info in self.users)
            {
                [retStr appendFormat:@"%@与你解除好友关系\n", info.nickname.length > 0 ? info.nickname : info.identifier];
            }
        }
            break;
            /**
             *  增加好友申请
             */
        case TIM_SNS_SYSTEM_ADD_FRIEND_REQ: //                      = 0x03,
        {
            for (TIMSNSChangeInfo *info in self.users)
            {
                [retStr appendFormat:@"%@请求加为好友\n", info.nickname.length > 0 ? info.nickname : info.identifier];
            }
        }
            break;
            /**
             *  删除未决申请
             */
        case TIM_SNS_SYSTEM_DEL_FRIEND_REQ://                       = 0x04,
        {
            for (TIMSNSChangeInfo *info in self.users)
            {
                [retStr appendFormat:@"%@删除你的好友请求\n", info.nickname.length > 0 ? info.nickname : info.identifier];
            }
        }
            break;
            /**
             *  黑名单添加
             */
        case TIM_SNS_SYSTEM_ADD_BLACKLIST://                        = 0x05,
        {
            for (TIMSNSChangeInfo *info in self.users)
            {
                [retStr appendFormat:@"%@将你添加到黑名单\n", info.nickname.length > 0 ? info.nickname : info.identifier];
            }
        }
            break;
            /**
             *  黑名单删除
             */
        case TIM_SNS_SYSTEM_DEL_BLACKLIST://                        = 0x06,
        {
            for (TIMSNSChangeInfo *info in self.users)
            {
                [retStr appendFormat:@"%@将你移出黑名单\n", info.nickname.length > 0 ? info.nickname : info.identifier];
            }
        }
            break;
            /**
             *  未决已读上报
             */
        case TIM_SNS_SYSTEM_PENDENCY_REPORT://                      = 0x07,
        {
            [retStr appendString:@"未决已读上报"];
            //            for (TIMSNSChangeInfo *info in self.users)
            //            {
            //                [retStr appendFormat:@"%@将你移出黑名单\n", info.nickname.length > 0 ? info.nickname : info.identifier];
            //            }
        }
            break;
            
            /**
             *  关系链资料变更
             */
        case TIM_SNS_SYSTEM_SNS_PROFILE_CHANGE://                   = 0x08,
        {
            for (TIMSNSChangeInfo *info in self.users)
            {
                [retStr appendFormat:@"%@修改了资料\n", info.nickname.length > 0 ? info.nickname : info.identifier];
            }
        }
            break;
            /**
             *  推荐数据增加
             */
        case TIM_SNS_SYSTEM_ADD_RECOMMEND://                        = 0x09,
        {
            [retStr appendString:@"推荐数据增加"];
        }
            break;
            /**
             *  推荐数据删除
             */
        case  TIM_SNS_SYSTEM_DEL_RECOMMEND://                        = 0x0a,
        {
            [retStr appendString:@"推荐数据删除"];
        }
            break;
            /**
             *  已决增加
             */
        case TIM_SNS_SYSTEM_ADD_DECIDE://                           = 0x0b,
        {
            [retStr appendString:@"已决增加"];
        }
            break;
            /**
             *  已决删除
             */
        case TIM_SNS_SYSTEM_DEL_DECIDE://                           = 0x0c,
        {
            [retStr appendString:@"已决删除"];
        }
            break;
            /**
             *  推荐已读上报
             */
        case TIM_SNS_SYSTEM_RECOMMEND_REPORT://                     = 0x0d,
        {
            [retStr appendString:@"推荐已读上报"];
        }
            break;
            /**
             *  已决已读上报
             */
        case TIM_SNS_SYSTEM_DECIDE_REPORT://                        = 0x0e,
        {
            [retStr appendString:@"已决已读上报"];
        }
            break;
            
            
        default:
            break;
    }
    
    return retStr;
}
@end

@implementation TIMProfileSystemElem (ShowDescription)

// 显示描述
- (NSString *)showDescriptionOf:(IMAMsg *)msg
{
    // 后面转成对应的描述信息
    return @"[资料变更消息]";
}
@end

