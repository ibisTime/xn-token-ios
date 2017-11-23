//
//  IMAMsg.h
//  TIMAdapter
//
//  Created by AlexiChen on 16/1/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//


typedef NS_ENUM(NSInteger, IMAMSGType) {
    EIMAMSG_Unknown,            // 未知消息类型
    EIMAMSG_Text,               // 文本
    EIMAMSG_Image,              // 图片
    EIMAMSG_File,               // 文件
    EIMAMSG_Sound,              // 语音
    EIMAMSG_Face,               // 表情
    EIMAMSG_Location,           // 定位
    EIMAMSG_Video,              // 视频消息
    EIMAMSG_Custom,             // 自定义
    EIMAMSG_TimeTip,            // 时间提醒标签，不存在于IMSDK缓存的数据库中，业务动态生成
    EIMAMSG_GroupTips,          // 群提醒
    EIMAMSG_GroupSystem,        // 群系统消息
    EIMAMSG_SNSSystem,          // 关系链消息
    EIMAMSG_ProfileSystem,      // 资料变更消息
    EIMAMSG_InputStatus,        // 对方输入状态
    EIMAMSG_SaftyTip,           // 敏感词消息提醒标签，不存在缓存中，退出聊天界面再进入，则不存在了
    
    EIMAMSG_RevokedTip,         // 消息撤回
#if kTestChatAttachment
    EIMAMSG_Multi,              // 富文消息，后期所有聊天消息全部使用富文本显示
#endif
    
};

/**
 *  消息状态
 */
typedef NS_ENUM(NSInteger, IMAMsgStatus)
{
    EIMAMsg_Init = -1,                              // 初始化, 为兼容TIMMessageStatus，从－1开始，创建的消息
    EIMAMsg_WillSending,                            // 即将发送,加入到IMAConversation的_msgList，但未发送，如发送语音，可以用于先在界面上显示，
    EIMAMsg_Sending = TIM_MSG_STATUS_SENDING,       // 消息发送中
    EIMAMsg_SendSucc = TIM_MSG_STATUS_SEND_SUCC,    // 消息发送成功
    EIMAMsg_SendFail = TIM_MSG_STATUS_SEND_FAIL,    // 消息发送失败
//    EIMAMsg_Deleted = TIM_MSG_STATUS_HAS_DELETED,   // 消息被删除 已经废除，以前删除消息是仅仅把状态置为delete，现在是直接删除存储
};

@interface IMAMsg : NSObject
{
@protected
    TIMMessage      *_msg;
    
@protected
    IMAMSGType      _type;
    
    NSInteger       _status;
    
@protected
    // 附加参数，因IMSDK底层有保护机制，从底层获取到的信息，每次都会copy一份
    // 使用此参数来优化界面更新
    NSMutableDictionary *_affixParams;
    
}

@property (nonatomic, readonly) IMAMSGType type;
@property (nonatomic, readonly) TIMMessage *msg;
@property (nonatomic, readonly) NSInteger status;
@property (nonatomic, assign)   BOOL isPicked;

// 客户从UI界面主动调用的消息类簇
+ (instancetype)msgWithText:(NSString *)text;

+ (instancetype)msgWithImage:(UIImage *)image isOrignal:(BOOL)origal;

+ (instancetype)msgWithDate:(NSDate *)timetip;

+ (instancetype)msgWithRevoked:(NSString *)sender;
//
//+ (instancetype)msgWithFile:(NSData *)fileData;
//
+ (instancetype)msgWithFilePath:(NSURL *)filePath;
//
+ (instancetype)msgWithSound:(NSData *)data duration:(NSInteger)dur;
//+ (instancetype)msgWithSoundPath:(NSString *)path duration:(NSInteger)dur;
+ (instancetype)msgWithEmptySound;

+ (instancetype)msgWithCustom:(NSInteger)command;

+ (instancetype)msgWithCustom:(NSInteger)command param:(NSString *)param;
//
//+ (instancetype)msgWithGroupTips:(NSData *)data;
//
//+ (instancetype)msgWithLocation:(CLLocation *)loc;
//
//+ (instancetype)msgWithCustom:(NSData *)customdata;
//
//+ (instancetype)msgWithFace:(NSInteger)faceIndex;
//
//+ (instancetype)msgWithGroupSystem:(NSString *)tip;
//
//+ (instancetype)msgWithSNSSystem:(NSString *)tip;
//
//+ (instancetype)msgWithProfileSystem:(NSString *)tip;
//
+ (instancetype)msgWithVideoPath:(NSString *)videoPath;


// 底层SDK返回后封装的

+ (instancetype)msgWith:(TIMMessage *)msg;

- (NSString *)msgTime;
- (NSString *)messageTip;
- (void)changeTo:(IMAMsgStatus)status needRefresh:(BOOL)need;
- (void)remove;

- (IMAUser *)getSender;

// 是否为我发的消息
- (BOOL)isMineMsg;
- (BOOL)isC2CMsg;
- (BOOL)isGroupMsg;
- (BOOL)isSystemMsg;
- (BOOL)isVailedType;

// 是否包含多个文本
- (BOOL)isMultiMsg;



// 外部不调用，只限于TIMAdapter文件目录下代码调用
// affix param method

- (void)addString:(NSString *)aValue forKey:(id<NSCopying>)aKey;

- (void)addInteger:(NSInteger)aValue forKey:(id<NSCopying>)aKey;

- (void)addCGFloat:(CGFloat)aValue forKey:(id<NSCopying>)aKey;

- (void)addBOOL:(BOOL)aValue forKey:(id<NSCopying>)aKey;

- (NSString *)stringForKey:(id<NSCopying>)key;
- (NSInteger)integerForKey:(id<NSCopying>)key;
- (BOOL)boolForKey:(id<NSCopying>)key;
- (CGFloat)floatForKey:(id<NSCopying>)key;

@end


