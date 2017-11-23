//
//  IMAMsg.m
//  TIMAdapter
//
//  Created by AlexiChen on 16/1/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAMsg.h"

#import "CustomElemCmd.h"

@interface IMAMsg ()

@property (nonatomic, strong) NSMutableDictionary *affixParams;
@property (nonatomic, assign) NSInteger  status;

@end

@implementation IMAMsg

- (instancetype)initWith:(TIMMessage *)msg type:(IMAMSGType)type
{
    if (self = [super init])
    {
        _msg = msg;
        _type = type;
        _status = EIMAMsg_Init;
    }
    return self;
}

+ (instancetype)msgWithText:(NSString *)text
{
    TIMTextElem *elem = [[TIMTextElem alloc] init];
    elem.text = text;
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    
    return [[IMAMsg alloc] initWith:msg type:EIMAMSG_Text];
}

+ (instancetype)msgWithImage:(UIImage *)image isOrignal:(BOOL)origal
{
    //    MyMsgPicModel* model = [[MyMsgPicModel alloc] init];
    CGFloat scale = 1;
    scale = MIN(kChatPicThumbMaxHeight/image.size.height, kChatPicThumbMaxWidth/image.size.width);
    
    CGFloat picHeight = image.size.height;
    CGFloat picWidth = image.size.width;
    NSInteger picThumbHeight = (NSInteger) (picHeight * scale + 1);
    NSInteger picThumbWidth = (NSInteger) (picWidth * scale + 1);
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *nsTmpDIr = NSTemporaryDirectory();
    NSString *filePath = [NSString stringWithFormat:@"%@uploadFile%3.f", nsTmpDIr, [NSDate timeIntervalSinceReferenceDate]];
    BOOL isDirectory = NO;
    NSError *err = nil;
    
    // 当前sdk仅支持文件路径上传图片，将图片存在本地
    if ([fileManager fileExistsAtPath:filePath isDirectory:&isDirectory])
    {
        if (![fileManager removeItemAtPath:nsTmpDIr error:&err])
        {
            DebugLog(@"Upload Image Failed: same upload filename: %@", err);
            return nil;
        }
    }
    if (![fileManager createFileAtPath:filePath contents:UIImageJPEGRepresentation(image, 1) attributes:nil])
    {
        DebugLog(@"Upload Image Failed: fail to create uploadfile: %@", err);
        return nil;
    }
    
    NSString *thumbPath = [NSString stringWithFormat:@"%@uploadFile%3.f_ThumbImage", nsTmpDIr, [NSDate timeIntervalSinceReferenceDate]];
    UIImage *thumbImage = [image thumbnailWithSize:CGSizeMake(picThumbWidth, picThumbHeight)];
    if (![fileManager createFileAtPath:thumbPath contents:UIImageJPEGRepresentation(thumbImage, 1) attributes:nil])
    {
        DebugLog(@"Upload Image Failed: fail to create uploadfile: %@", err);
        return nil;
    }
    
    TIMImageElem *elem = [[TIMImageElem alloc] init];
    elem.path = filePath;
    
    if (origal)
    {
        elem.level = TIM_IMAGE_COMPRESS_ORIGIN;
    }
    else
    {
        elem.level = TIM_IMAGE_COMPRESS_HIGH;
    }
    
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    IMAMsg *imamsg = [[IMAMsg alloc] initWith:msg type:EIMAMSG_Image];
    
    [imamsg addInteger:picThumbHeight forKey:kIMAMSG_Image_ThumbHeight];
    [imamsg addInteger:picThumbWidth forKey:kIMAMSG_Image_ThumbWidth];
    [imamsg addString:filePath forKey:kIMAMSG_Image_OrignalPath];
    [imamsg addString:thumbPath forKey:kIMAMSG_Image_ThumbPath];
    
    return imamsg;
}

+ (instancetype)msgWithDate:(NSDate *)timetip
{
    TIMCustomElem *elem = [[TIMCustomElem alloc] init];
    [elem setFollowTime:timetip];
    
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    IMAMsg *imamsg = [[IMAMsg alloc] initWith:msg type:EIMAMSG_TimeTip];
    return imamsg;
}

+ (instancetype)msgWithRevoked:(NSString *)sender
{
    TIMCustomElem *elem = [[TIMCustomElem alloc] init];
    NSDictionary *dataDic = @{@"sender":sender, @"REVOKED":@1};
    NSError *error = nil;
    elem.data = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:&error];

    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    IMAMsg *imamsg = [[IMAMsg alloc] initWith:msg type:EIMAMSG_RevokedTip];
    return imamsg;
}

+ (instancetype)msgWithFilePath:(NSURL *)filePath
{
    if (!filePath)
    {
        return nil;
    }
    
    TIMFileElem *elem = [[TIMFileElem alloc] init];
//    elem.data = [NSData dataWithContentsOfURL:filePath];
    elem.path = [filePath absoluteString];
    elem.fileSize = (int)elem.fileSize;
    elem.filename = [filePath absoluteString];
    
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    
    return [[IMAMsg alloc] initWith:msg type:EIMAMSG_File];
}

+ (instancetype)msgWithSound:(NSData *)data duration:(NSInteger)dur
//+ (instancetype)msgWithSoundPath:(NSString *)path duration:(NSInteger)dur
{
    if (!data)
    {
        return nil;
    }
    //保存到本地
    NSString *cache = [PathUtility getCachePath];
    NSString *loginId = [[TIMManager sharedInstance] getLoginUser];
    
    NSDate *date = [[NSDate alloc] init];
    NSTimeInterval time = [date timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%llu",(unsigned long long)time];
    NSString *soundSaveDir = [NSString stringWithFormat:@"%@/%@/Audio",cache,loginId];
    
    if (![PathUtility isExistFile:soundSaveDir])
    {
        BOOL isCreateDir = [[NSFileManager defaultManager] createDirectoryAtPath:soundSaveDir withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isCreateDir)
        {
            return nil;
        }
    }

    NSString *soundSavePath = [NSString stringWithFormat:@"%@/%@",soundSaveDir,timeStr];
    if (![PathUtility isExistFile:soundSavePath])
    {
        BOOL isCreate = [[NSFileManager defaultManager] createFileAtPath:soundSavePath contents:nil attributes:nil];
        if (!isCreate)
        {
            return nil;
        }
    }
    BOOL isWrite = [data writeToFile:soundSavePath atomically:YES];
    if (!isWrite)
    {
        return nil;
    }
    
    TIMSoundElem *elem = [[TIMSoundElem alloc] init];
    elem.path = soundSavePath;
    elem.second = (int)dur;
    
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    
    return [[IMAMsg alloc] initWith:msg type:EIMAMSG_Sound];
}

+ (instancetype)msgWithEmptySound
{
    TIMSoundElem *elem = [[TIMSoundElem alloc] init];
    
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    
    return [[IMAMsg alloc] initWith:msg type:EIMAMSG_Sound];
}

+ (instancetype)msgWithCustom:(NSInteger)command
{
    return [IMAMsg msgWithCustom:command param:nil];
}

+ (instancetype)msgWithCustom:(NSInteger)command param:(NSString *)param
{
    CustomElemCmd *cmd = [[CustomElemCmd alloc] initWith:command param:param];
    
    TIMCustomElem *elem = [[TIMCustomElem alloc] init];
    elem.data = [cmd packToSendData];
    
    TIMMessage *customMsg = [[TIMMessage alloc] init];
    [customMsg addElem:elem];
    
    return [[IMAMsg alloc] initWith:customMsg type:command];
}

+ (instancetype)msgWith:(TIMMessage *)msg
{
    //    EIMAMSG_Text,               // 文本
    //    EIMAMSG_Image,              // 图片
    //    EIMAMSG_File,               // 文件
    //    EIMAMSG_Sound,              // 语音
    //    EIMAMSG_Face,               // 表情
    //    EIMAMSG_Location,           // 定位
    //    EIMAMSG_Video,              // 视频消息
    //    EIMAMSG_Custom,             // 自定义
    //    EIMAMSG_GroupTips,          // 群提醒
    //    EIMAMSG_GroupSystem,        // 群系统消息
    //    EIMAMSG_SNSSystem,          // 关系链消息
    //    EIMAMSG_ProfileSystem,      // 资料变更消息
    
    
    if (msg.elemCount == 0)
    {
        return nil;
    }
    
    IMAMSGType type = EIMAMSG_Unknown;
#if kTestChatAttachment
    if (msg.elemCount > 1)
    {
        // TODO:后期使用富文本显示
        type = EIMAMSG_Multi;
    }
    else
#endif
    {
        TIMElem *elem = [msg getElem:0];
        Class eleCls = [elem class];
        if (eleCls == [TIMTextElem class])
        {
            type = EIMAMSG_Text;
        }
        else if (eleCls == [TIMImageElem class])
        {
            type = EIMAMSG_Image;
        }
        else if (eleCls == [TIMFileElem class])
        {
            type = EIMAMSG_File;
        }
        else if (eleCls == [TIMFaceElem class])
        {
            type = EIMAMSG_Face;
        }
        else if (eleCls == [TIMLocationElem class])
        {
            type = EIMAMSG_Location;
        }
        else if (eleCls == [TIMSoundElem class])
        {
            type = EIMAMSG_Sound;
        }
        else if (eleCls == [TIMUGCElem class])
        {
            type = EIMAMSG_Video;
        }
        else if (eleCls == [TIMCustomElem class])
        {
            type = EIMAMSG_Custom;
        }
        else if (eleCls == [TIMGroupTipsElem class])
        {
            type = EIMAMSG_GroupTips;
        }
        else if (eleCls == [TIMGroupSystemElem class])
        {
            type = EIMAMSG_GroupSystem;
        }
        else if (eleCls == [TIMProfileSystemElem class])
        {
            type = EIMAMSG_ProfileSystem;
        }
        else if (eleCls == [TIMSNSSystemElem class])
        {
            type = EIMAMSG_SNSSystem;
        }
    }
    
    //    if (type == EIMAMSG_Unknown)
    //    {
    //        DebugLog(@"不支持的消息类型");
    //        return ni;
    //    }
    
    IMAMsg *imamsg = [[IMAMsg alloc] initWith:msg type:type];
    [imamsg changeTo:(NSInteger)msg.status needRefresh:NO];
    return imamsg;
    
}

+ (instancetype)msgWithVideoPath:(NSString *)videoPath;
{
    if (!videoPath)
    {
        return nil;
    }
   
    //视频截图
    AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:urlAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;    // 截图的时候调整到正确的方向
    CMTime time = CMTimeMakeWithSeconds(1.0, 30);   // 1.0为截取视频1.0秒处的图片，30为每秒30帧
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:nil error:nil];
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    UIGraphicsBeginImageContext(CGSizeMake(240, 320));
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0,0, 240, 320)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    NSData *snapshotData = UIImageJPEGRepresentation(scaledImage, 0.75);
    
    //保存截图到临时目录
    NSString *tempDir = NSTemporaryDirectory();
    NSString *snapshotPath = [NSString stringWithFormat:@"%@%3.f", tempDir, [NSDate timeIntervalSinceReferenceDate]];
    
    NSError *err;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    if (![fileMgr createFileAtPath:snapshotPath contents:snapshotData attributes:nil])
    {
        DebugLog(@"Upload Image Failed: fail to create uploadfile: %@", err);
        return nil;
    }
    
    //创建 TIMUGCElem
    TIMUGCVideo* video = [[TIMUGCVideo alloc] init];
    video.type = @"mp4";
    video.duration = (int)urlAsset.duration.value/urlAsset.duration.timescale;

    TIMUGCCover *corver = [[TIMUGCCover alloc] init];
    corver.type = @"jpg";
    corver.width = scaledImage.size.width;
    corver.height = scaledImage.size.height;
    
    TIMUGCElem* elem = [[TIMUGCElem alloc] init];
    elem.video = video;
    elem.videoPath = videoPath;
    elem.coverPath = snapshotPath;
    elem.cover = corver;
    
    TIMMessage* msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    IMAMsg *videoMsg = [[IMAMsg alloc] initWith:msg type:EIMAMSG_Video];
    
    return videoMsg;
}

+ (void)convertToMP4:(AVURLAsset*)avAsset videoPath:(NSString*)videoPath succ:(void (^)())succ fail:(void (^)())fail
{
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality])
    {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
        
        exportSession.outputURL = [NSURL fileURLWithPath:videoPath];
        
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        CMTime start = CMTimeMakeWithSeconds(0, avAsset.duration.timescale);
        
        CMTime duration = avAsset.duration;
        
        CMTimeRange range = CMTimeRangeMake(start, duration);
        
        exportSession.timeRange = range;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status])
            {
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                    fail();
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    fail();
                    break;
                default:
                    succ();
                    break;
            }
        }];
    }
}

- (NSString *)msgTime
{
    NSDate *date = [_msg timestamp];
    
    NSString *time = [date shortTimeTextOfDate];
    return time;
}

- (NSInteger)status
{
    if (_status == EIMAMsg_Init || _status == EIMAMsg_WillSending)
    {
        return _status;
    }
    else
    {
        return [_msg status];
    }
}

- (IMAUser *)getSender
{
    if ([[_msg getConversation] getType] == TIM_C2C)
    {
//        NSString *sender = [_msg sender];
//        IMAUser *user = [[IMAPlatform sharedInstance].contactMgr getUserByUserId:sender];
        IMAUser *user = [[IMAUser alloc] initWith:[_msg sender]];
        return user;
    }
    else if ([[_msg getConversation] getType] == TIM_GROUP)
    {
        IMAGroupMember *member = [[IMAGroupMember alloc] initWithMemberInfo:[_msg getSenderGroupMemberProfile]];
        
        if (member)
        {
            IMAUser *user = [[IMAUser alloc] initWithUserInfo:[_msg getSenderProfile]];
            [member setIcon:user.icon];
            
            if (member.memberInfo.nameCard.length <= 0)
            {
                [member setNickName:[user showTitle]];
            }
        }
        return member;
    }
    return nil;
}

- (NSString *)messageTip
{
    TIMConversation *conv = [_msg getConversation];
    TIMConversationType type = [conv getType];
    TIMElem *elem = (TIMElem *)[_msg getElem:0];
    if (elem)
    {
        if (type == TIM_C2C)
        {
            return [elem showDescriptionOf:self];
        }
        else if (type == TIM_GROUP)
        {
            if ([_msg isSelf])
            {
                return [elem showDescriptionOf:self];
            }
            else
            {
                if (self.type == EIMAMSG_GroupTips)
                {
                    return [elem showDescriptionOf:self];
                }
                else
                {
                    TIMGroupMemberInfo *profile = [_msg getSenderGroupMemberProfile];
                    if (profile)
                    {
                        return [NSString stringWithFormat:@"%@:%@", [profile showTitle], [elem showDescriptionOf:self]];
                        
                    }
                    else
                    {
                        IMAUser *sender = [self getSender];
                        if (sender)
                        {
                            return [NSString stringWithFormat:@"%@:%@", [sender showTitle], [elem showDescriptionOf:self]];
                        }
                        else
                        {
                            return [NSString stringWithFormat:@"%@:%@", [_msg sender], [elem showDescriptionOf:self]];
                        }
                        
                    }
                }
                
            }
            
        }
        else if (type == TIM_SYSTEM)
        {
            return [NSString stringWithFormat:@"%@:%@", @"系统消息", [elem showDescriptionOf:self]];
        }
    }
    
    return nil;
}

- (void)remove
{
    if (self.type == EIMAMSG_TimeTip || self.type == EIMAMSG_SaftyTip)
    {
        // 属于自定义的类型，不在IMSDK数据库里面，不能调remove接口
        return;
    }
    
    BOOL succ = [_msg remove];
    DebugLog(@"删除成功：%d", succ);
}

- (void)changeTo:(IMAMsgStatus)status needRefresh:(BOOL)need
{
    if (_status != status)
    {
        if (need)
        {
            self.status = status;
        }
        else
        {
            _status = status;
        }
    }
}

- (BOOL)isMineMsg
{
    return [_msg isSelf];
}

- (BOOL)isC2CMsg
{
    return [[self.msg getConversation] getType] == TIM_C2C;
}
- (BOOL)isGroupMsg
{
    return [[self.msg getConversation] getType] == TIM_GROUP;
}

- (BOOL)isSystemMsg
{
    return self.type == TIM_SYSTEM;
}

- (BOOL)isVailedType
{
    return self.type != EIMAMSG_TimeTip && self.type != EIMAMSG_SaftyTip;
}

- (BOOL)isMultiMsg
{
    return _type == EIMAMSG_Face || _msg.elemCount > 1;
}

- (NSMutableDictionary *)affixParams
{
    if (!_affixParams)
    {
        _affixParams = [NSMutableDictionary dictionary];
    }
    return _affixParams;
}


- (void)addString:(NSString *)aValue forKey:(id<NSCopying>)aKey
{
    [self.affixParams addString:aValue forKey:aKey];
}

- (void)addInteger:(NSInteger)aValue forKey:(id<NSCopying>)aKey
{
    [self.affixParams addInteger:aValue forKey:aKey];
}

- (void)addCGFloat:(CGFloat)aValue forKey:(id<NSCopying>)aKey
{
    [self.affixParams addCGFloat:aValue forKey:aKey];
}

- (void)addBOOL:(BOOL)aValue forKey:(id<NSCopying>)aKey
{
    [self.affixParams addBOOL:aValue forKey:aKey];
}

- (NSString *)stringForKey:(id<NSCopying>)key
{
    return [self.affixParams stringForKey:key];
}
- (NSInteger)integerForKey:(id<NSCopying>)key
{
    return [self.affixParams integerForKey:key];
}
- (BOOL)boolForKey:(id<NSCopying>)key
{
    return [self.affixParams boolForKey:key];
}
- (CGFloat)floatForKey:(id<NSCopying>)key
{
    return [self.affixParams floatForKey:key];
}

- (BOOL)isEqual:(id)object
{
    BOOL isEqual = [super isEqual:object];
    if (!isEqual)
    {
        if ([object isKindOfClass:[IMAMsg class]])
        {
            IMAMsg *msg = (IMAMsg *)object;
            isEqual = self.msg.msgId == msg.msg.msgId;
        }
    }
    return isEqual;
}

@end
