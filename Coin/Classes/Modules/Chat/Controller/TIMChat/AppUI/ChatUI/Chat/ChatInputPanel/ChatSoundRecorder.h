//
//  ChatSoundRecorder.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/17.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ChatSoundPlayCompletion)();


typedef void(^ChatSoundStartRecordCompletion)(IMAMsg *willSendSoundMsg);
typedef void(^ChatSoundCancelRecordCompletion)(IMAMsg *willSendSoundMsg);
typedef void(^ChatSoundStopRecordCompletion)(IMAMsg *willSendSoundMsg);


@interface ChatRecoredView : UIImageView
{
@protected
    UIImageView *_imageTip;
    UILabel     *_countdownTip;
    UILabel     *_tip;
}

- (void)prepareForUse;

@end

typedef NS_ENUM(NSInteger, ChatRecorderState)
{
    EChatRecorder_Stoped,
    EChatRecorder_Recoring,
    EChatRecorder_RelaseCancel,
    EChatRecorder_Countdown,
    EChatRecorder_MaxRecord,
    EChatRecorder_TooShort,
};

@interface ChatSoundRecorder : NSObject
{
@protected
    // 录音相关
    ChatRecorderState           _recordState;
    CGFloat                     _recordPeak;
    NSInteger                   _recordDuration;
    IMAMsg                      *_recordingMsg;
    ChatRecoredView             *_recordTipView;
    
    // 用于音频退出直播时还原现场
    NSString                        *_audioSesstionCategory;    // 进入房间时的音频类别
    NSString                        *_audioSesstionMode;        // 进入房间时的音频模式
    AVAudioSessionCategoryOptions   _audioSesstionCategoryOptions;       // 进入房间时的音频类别选项
    
@protected
    __weak id<ChatInputAbleViewDelegate> _recorderDelegate;
}

@property (nonatomic, assign) CGFloat           recordPeak;
@property (nonatomic, assign) NSInteger         recordDuration;
@property (nonatomic, assign) ChatRecorderState recordState;
@property (nonatomic, weak) id<ChatInputAbleViewDelegate> recorderDelegate;

+ (void)configWith:(IMAConversation *)conv;

+ (instancetype)sharedInstance;

+ (void)destory;

- (void)startRecord;
- (void)willCancelRecord;
- (void)continueRecord;
- (void)stopRecord;



@end


@interface ChatSoundPlayer : NSObject

+ (instancetype)sharedInstance;
+ (void)destory;

- (void)playWith:(NSData *)data finish:(CommonVoidBlock)completion;
- (void)playWithUrl:(NSURL *)url finish:(CommonVoidBlock)completion;
- (void)stopPlay;

@end
