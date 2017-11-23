//
//  TIMElem+ChatTextAttachment.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/31.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TIMElem+ChatAttachment.h"

@implementation TIMElem (ChatAttachment)

- (NSArray *)singleAttachmentOf:(IMAMsg *)msg
{
    return nil;
}
- (NSArray *)inputAttachmentOf:(IMAMsg *)msg
{
    return nil;
}
- (NSArray *)chatAttachmentOf:(IMAMsg *)msg
{
    return nil;
}

@end


@implementation TIMTextElem (ChatAttachment)

- (NSArray *)singleAttachmentOf:(IMAMsg *)msg
{
    //去掉前面的空格
    NSString *temp = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:temp attributes:@{NSFontAttributeName : [msg tipFont], NSForegroundColorAttributeName : [msg tipTextColor]}];
    return @[str];
}
- (NSArray *)inputAttachmentOf:(IMAMsg *)msg
{
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName : [msg inputTextFont], NSForegroundColorAttributeName : [msg inputTextColor]}];
    return @[str];
}
- (NSArray *)chatAttachmentOf:(IMAMsg *)msg
{
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName : [msg textFont], NSForegroundColorAttributeName : [msg textColor]}];
    return @[str];
}

@end


@implementation TIMImageElem (ChatAttachment)

- (NSArray *)singleAttachmentOf:(IMAMsg *)msg
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"[图片]" attributes:@{NSFontAttributeName : [msg tipFont], NSForegroundColorAttributeName : [msg tipTextColor]}];
    return @[str];
}
- (NSArray *)inputAttachmentOf:(IMAMsg *)msg
{
    // 不能在输入框里面直接添加非表情图片
    return nil;
}
- (NSArray *)chatAttachmentOf:(IMAMsg *)msg
{
    ChatImageAttachment *imageAt = [[ChatImageAttachment alloc] initWith:self];
    
    __weak TIMImageElem *elem = self;
    [self asyncThumbImage:^(NSString *path, UIImage *image, BOOL succ, BOOL isAsync) {
        // TODO，添加占位图
        if (succ)
        {
            imageAt.image = image;
        }
        else
        {
            imageAt.image = [UIImage imageNamed:@"delete_big"];
        }
        
        if (isAsync)
        {
            // 更新msg的显示
            [msg updateElem:elem attachmentChanged:imageAt];
        }
    } inMsg:msg];
    
    NSInteger tw = [msg integerForKey:kIMAMSG_Image_ThumbWidth];
    NSInteger th = [msg integerForKey:kIMAMSG_Image_ThumbHeight];
    imageAt.bounds = CGRectMake(0, 0, tw, th);
    
    NSAttributedString *imagAtt = [NSAttributedString attributedStringWithAttachment:imageAt];
    return @[imagAtt];
}


@end


@implementation TIMFaceElem (ChatAttachment)

- (NSArray *)singleAttachmentOf:(IMAMsg *)msg
{
//    UIFont *tipFont = [msg tipFont];
    NSInteger height = 12;
    
    ChatImageAttachment *image = [[ChatImageAttachment alloc] initWith:self];
    ChatSystemFaceItem *item = [[ChatSystemFaceHelper sharedHelper] emojiItemOf:self.index];
    // TODO：待取到表情表之后再作处理
    image.tag = item.emojiTag;
    image.image = [item inputGif];
    
    image.bounds = CGRectMake(0, 0, height, height);
    NSAttributedString *imagAtt = [NSAttributedString attributedStringWithAttachment:image];
    return @[imagAtt];
}
- (NSArray *)inputAttachmentOf:(IMAMsg *)msg
{
    //    UIFont *inputFont = [msg inputTextFont];
    NSInteger height = 14;
    
    // TODO：待取到表情表之后再作处理
    ChatImageAttachment *image = [[ChatImageAttachment alloc] initWith:self];
    ChatSystemFaceItem *item = [[ChatSystemFaceHelper sharedHelper] emojiItemOf:self.index];
    image.tag = item.emojiTag;
    image.image = [item inputGif];
    
    image.bounds = CGRectMake(0, 0, height, height);
    
    NSAttributedString *imagAtt = [NSAttributedString attributedStringWithAttachment:image];
    return @[imagAtt];
}
- (NSArray *)chatAttachmentOf:(IMAMsg *)msg
{
    
    return [self inputAttachmentOf:msg];
    
//    //    UIFont *textFont = [msg textFont];
//    //    NSInteger height = (NSInteger)([textFont lineHeight] + 1);
//    NSInteger height = 14;
//    
//    ChatImageAttachment *image = [[ChatImageAttachment alloc] initWith:self];
//    ChatSystemFaceItem *item = [[ChatSystemFaceHelper sharedHelper] emojiItemOf:self.index];
//    image.tag = item.emojiTag;
//    image.image = [item inputGif];
//
//    // 因外部要替换，暂不加入
//    // image.image = [UIImage imageNamed:@"0.gif"];[UIImage imageNamed:@"delete_big"];
//    
//    image.bounds = CGRectMake(0, 0, height + 2, height);
//    
//    NSAttributedString *imagAtt = [NSAttributedString attributedStringWithAttachment:image];
//    return @[imagAtt];
}

@end

@implementation TIMFileElem (ChatAttachment)

- (NSArray *)singleAttachmentOf:(IMAMsg *)msg
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"[文件]" attributes:@{NSFontAttributeName : [msg tipFont], NSForegroundColorAttributeName : [msg tipTextColor]}];
    return @[str];
}

@end

@implementation TIMSoundElem (ChatAttachment)

- (NSArray *)singleAttachmentOf:(IMAMsg *)msg
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"[语音]" attributes:@{NSFontAttributeName : [msg tipFont], NSForegroundColorAttributeName : [msg tipTextColor]}];
    return @[str];
}

@end

@implementation TIMLocationElem (ChatAttachment)

- (NSArray *)singleAttachmentOf:(IMAMsg *)msg
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"[位置]" attributes:@{NSFontAttributeName : [msg tipFont], NSForegroundColorAttributeName : [msg tipTextColor]}];
    return @[str];
}

@end

@implementation TIMUGCElem (ChatAttachment)

- (NSArray *)singleAttachmentOf:(IMAMsg *)msg
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"[视频]" attributes:@{NSFontAttributeName : [msg tipFont], NSForegroundColorAttributeName : [msg tipTextColor]}];
    return @[str];
}
@end

@implementation TIMGroupTipsElem (ChatAttachment)

- (NSArray *)singleAttachmentOf:(IMAMsg *)msg
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[self tipText] attributes:@{NSFontAttributeName : [msg tipFont], NSForegroundColorAttributeName : [msg tipTextColor]}];
    return @[str];
}

@end


@implementation TIMCustomElem (ChatAttachment)

- (NSArray *)singleAttachmentOf:(IMAMsg *)msg
{
    TIMCustomElem *elem = (TIMCustomElem *)[msg.msg getElem:0];
    NSDictionary *info = [NSJSONSerialization JSONObjectWithData:elem.data options:NSJSONReadingMutableLeaves error:nil];
    BOOL isRevoked = [[info objectForKey:@"REVOKED"] boolValue];
    if (isRevoked) {
        TIMCustomElem *elem = (TIMCustomElem *)[msg.msg getElem:0];
        NSDictionary *info = [NSJSONSerialization JSONObjectWithData:elem.data options:NSJSONReadingMutableLeaves error:nil];
        NSString *msgSender = [info objectForKey:@"sender"];
        NSString *text = [NSString stringWithFormat:@"\"%@\"撤回了一条消息",msgSender];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [msg tipFont], NSForegroundColorAttributeName : [msg tipTextColor]}];
        return @[str];
    }
    else
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"未知消息" attributes:@{NSFontAttributeName : [msg tipFont], NSForegroundColorAttributeName : [msg tipTextColor]}];
        return @[str];
    }
}

@end

@implementation TIMGroupSystemElem (ChatAttachment)


- (NSArray *)singleAttachmentOf:(IMAMsg *)msg
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[self showDescriptionOf:msg] attributes:@{NSFontAttributeName : [msg tipFont], NSForegroundColorAttributeName : [msg tipTextColor]}];
    return @[str];
}
@end

@implementation TIMSNSSystemElem (ChatAttachment)
- (NSArray *)singleAttachmentOf:(IMAMsg *)msg
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[self showDescriptionOf:msg] attributes:@{NSFontAttributeName : [msg tipFont], NSForegroundColorAttributeName : [msg tipTextColor]}];
    return @[str];
}
@end

@implementation TIMProfileSystemElem (ChatAttachment)

- (NSArray *)singleAttachmentOf:(IMAMsg *)msg
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"资料变更消息" attributes:@{NSFontAttributeName : [msg tipFont], NSForegroundColorAttributeName : [msg tipTextColor]}];
    return @[str];
}
@end





