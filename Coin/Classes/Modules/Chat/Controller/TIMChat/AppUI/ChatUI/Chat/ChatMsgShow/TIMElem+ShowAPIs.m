//
//  TIMElem+ShowAPIs.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/8.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TIMElem+ShowAPIs.h"



@implementation TIMElem (ShowAPIs)

- (Class)showCellClassOf:(IMAMsg *)msg
{
    return [ChatBaseTableViewCell class];
}

- (CGSize)sizeInWidth:(CGFloat)width atMsg:(IMAMsg *)packMsg
{
    return CGSizeMake(width, 32);
}

@end


@implementation TIMTextElem (ShowAPIs)

- (Class)showCellClassOf:(IMAMsg *)msg
{
    return [ChatTextTableViewCell class];
}

- (CGSize)sizeInWidth:(CGFloat)width atMsg:(IMAMsg *)packMsg
{
    CGSize size = [self.text textSizeIn:CGSizeMake(width, HUGE_VAL) font:[packMsg textFont]];
    
    if (size.height < kIMAMsgMinHeigth)
    {
        size.height = kIMAMsgMinHeigth;
    }
    return size;
}

@end



@implementation TIMImageElem (ShowAPIs)

- (CGSize)getThumbShowSizeInMsg:(IMAMsg *)packMsg;
{
    NSInteger tw = [packMsg integerForKey:kIMAMSG_Image_ThumbWidth];
    NSInteger th = [packMsg integerForKey:kIMAMSG_Image_ThumbHeight];
    
    if (tw == 0 || th == 0)
    {
        BOOL succ = NO;
        for (TIMImage *timImage in self.imageList)
        {
            if (timImage.type == TIM_IMAGE_TYPE_THUMB)
            {
                // 解析大小
                CGFloat scale = 1;
                scale = MIN(kChatPicThumbMaxHeight/timImage.height, kChatPicThumbMaxWidth/timImage.width);
                tw = (NSInteger)(timImage.width * scale + 1);
                th =  (NSInteger)(timImage.height * scale + 1);
                
                [packMsg addInteger:tw forKey:kIMAMSG_Image_ThumbWidth];
                [packMsg addInteger:th forKey:kIMAMSG_Image_ThumbHeight];
                succ = YES;
                break;
            }
        }
    }
    
    return CGSizeMake(tw, th);
}


- (Class)showCellClassOf:(IMAMsg *)msg
{
    return [ChatImageTableViewCell class];
}

- (CGSize)sizeInWidth:(CGFloat)width atMsg:(IMAMsg *)packMsg
{
    NSInteger tw = [packMsg integerForKey:kIMAMSG_Image_ThumbWidth];
    NSInteger th = [packMsg integerForKey:kIMAMSG_Image_ThumbHeight];
    
    if (tw ==0 || th ==0)
    {
        BOOL succ = NO;
        for (TIMImage *timImage in self.imageList)
        {
            if (timImage.type == TIM_IMAGE_TYPE_THUMB)
            {
                // 解析大小
                CGFloat scale = 1;
                scale = MIN(kChatPicThumbMaxHeight/timImage.height, kChatPicThumbMaxWidth/timImage.width);
                tw = (NSInteger)(timImage.width * scale + 1);
                th =  (NSInteger)(timImage.height * scale + 1);
                
                [packMsg addInteger:tw forKey:kIMAMSG_Image_ThumbWidth];
                [packMsg addInteger:th forKey:kIMAMSG_Image_ThumbHeight];
                succ = YES;
                break;
            }
        }
        
        if (!succ)
        {
            NSString *filePath = self.path;
            NSInteger thumbWidth = kChatPicThumbMaxWidth;
            NSInteger thumbHeight = kChatPicThumbMaxHeight;
            if (![NSString isEmpty:filePath])
            {
                // NSString *filePath = [NSString stringWithFormat:@"%@uploadFile%3.f_Size_%d_%d", nsTmpDIr, [NSDate timeIntervalSinceReferenceDate], (int)picThumbWidth, (int)picThumbHeight];
                // 检查本地是否存储了
                BOOL exist = [PathUtility isExistFile:filePath];
                if (exist)
                {
                    // 获取原图
                    UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
                    // TODO：是否能过加载的图片再算
                    CGFloat scale = 1;
                    scale = MIN(kChatPicThumbMaxHeight/image.size.height, kChatPicThumbMaxWidth/image.size.width);
                    
                    CGFloat picHeight = image.size.height;
                    CGFloat picWidth = image.size.width;
                    thumbWidth = (NSInteger)(picHeight * scale + 1);
                    thumbHeight = (NSInteger)(picWidth * scale + 1);
                    
                    tw = thumbWidth;
                    th = thumbWidth;
                    
                    [packMsg addInteger:thumbHeight forKey:kIMAMSG_Image_ThumbHeight];
                    [packMsg addInteger:thumbWidth forKey:kIMAMSG_Image_ThumbWidth];
                }
                else
                {
                    DebugLog(@"程序异常退出，导致本地缓存图片不存在");
                }
            }
            else
            {
                DebugLog(@"理论不可达区域");
            }
        }
    }
    
    
    
    if (tw > width)
    {
        th = (NSInteger)(th * width/tw);
        tw = width;
    }
    
    return CGSizeMake(tw, th);
}

@end

@implementation TIMFileElem (ShowAPIs)


- (Class)showCellClassOf:(IMAMsg *)msg
{
    return [ChatFileTableViewCell class];
}

- (CGSize)sizeInWidth:(CGFloat)width atMsg:(IMAMsg *)packMsg
{
    return CGSizeMake(width, 70);
}
@end

@implementation TIMSoundElem (ShowAPIs)

- (Class)showCellClassOf:(IMAMsg *)msg
{
    return [ChatSoundTableViewCell class];
}

- (CGSize)sizeInWidth:(CGFloat)width atMsg:(IMAMsg *)packMsg
{
    NSInteger minWidth = 70;
    
    NSInteger uni = (width - minWidth)/60;
    
    NSInteger w = minWidth + self.second * uni;
    if (w > width)
    {
        w = width;
    }
    return CGSizeMake(w, kIMAMsgMinHeigth);
}

@end

@implementation TIMFaceElem (ShowAPIs)


// 是否是系统表情(QQ自带的表情)
- (BOOL)isSystemFace
{
    // 目前没有做自定义表情，所以全问都是系统表情
    // 用户可根据自身业务逻辑修改此处
    return YES;
}

@end

@implementation TIMLocationElem (ShowAPIs)

@end

@implementation TIMGroupTipsElem (ShowAPIs)



- (Class)showCellClassOf:(IMAMsg *)msg
{
    return [ChatGroupTipTableViewCell class];
}

- (CGSize)sizeInWidth:(CGFloat)width atMsg:(IMAMsg *)packMsg
{
    CGSize size = [[self tipText] textSizeIn:CGSizeMake(width, HUGE_VALF) font:[packMsg tipFont] breakMode:NSLineBreakByWordWrapping align:NSTextAlignmentCenter];
    return size;
}

@end

@implementation TIMUGCElem (ShowAPIs)

- (Class)showCellClassOf:(IMAMsg *)msg
{
    return [ChatVideoTableViewCell class];
}

- (CGSize)sizeInWidth:(CGFloat)width atMsg:(IMAMsg *)packMsg
{
    return CGSizeMake(150, 100);
}

@end


@implementation TIMCustomElem (ShowAPIs)


- (Class)showCellClassOf:(IMAMsg *)msg
{
    if (msg.type == EIMAMSG_TimeTip)
    {
        return [ChatTimeTipTableViewCell class];
    }
    else if (msg.type == EIMAMSG_SaftyTip)
    {
        return [ChatSaftyTipTableViewCell class];
    }
    else if (msg.type == EIMAMSG_RevokedTip)
    {
        return [RevokedTipTableViewCell class];
    }
    else
    {
        return [super showCellClassOf:msg];
    }
}


@end


@implementation TIMGroupSystemElem (ShowAPIs)

- (Class)showCellClassOf:(IMAMsg *)msg
{
    return [ChatBaseTableViewCell class];
}

- (CGSize)sizeInWidth:(CGFloat)width atMsg:(IMAMsg *)packMsg
{
    return CGSizeMake(width, 32);
}

@end


@implementation TIMSNSSystemElem (ShowAPIs)


@end

@implementation TIMProfileSystemElem (ShowAPIs)

// 显示描述
- (NSString *)showDescriptionOf:(IMAMsg *)msg
{
    // 后面转成对应的描述信息
    return @"[资料变更消息]";
}
@end
