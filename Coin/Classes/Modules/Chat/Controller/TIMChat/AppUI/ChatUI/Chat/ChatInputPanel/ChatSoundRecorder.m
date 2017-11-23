//
//  ChatSoundRecorder.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/17.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ChatSoundRecorder.h"


#define kChatRecordMaxDuration 60


@implementation ChatRecoredView

- (void)dealloc
{
    [self.KVOController unobserveAll];
//    self.KVOController = nil;
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self sizeWith:self.image.size];
        [self relayoutFrameOfSubViews];
    }
    return self;
}

- (void)addOwnViews
{
    self.image = [UIImage imageNamed:@"sound_record"];
    
    _countdownTip = [[UILabel alloc] init];
    _countdownTip.font = [UIFont boldSystemFontOfSize:20];
    _countdownTip.hidden = YES;
    [self addSubview:_countdownTip];
    
    _imageTip = [[UIImageView alloc] init];
    _imageTip.contentMode = UIViewContentModeCenter;
    [self addSubview:_imageTip];
    
    _tip = [[UILabel alloc] init];
    _tip.textColor = kWhiteColor;
    _tip.font = kAppSmallTextFont;
    _tip.textAlignment = NSTextAlignmentCenter;
    _tip.layer.cornerRadius = 2;
    [self addSubview:_tip];
}

- (void)configOwnViews
{
    _imageTip.image = [UIImage imageNamed:@"microphone1"];
    
    _countdownTip.text = nil;
    _countdownTip.hidden = YES;
    _countdownTip.textAlignment = NSTextAlignmentCenter;
    
    _tip.backgroundColor = kClearColor;
    _tip.text = @"手指上滑，取消发送";
}

- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.bounds;
    [_imageTip sizeWith:CGSizeMake(rect.size.width/2, rect.size.height/2)];
    [_imageTip alignParentCenter];
    
    [_countdownTip sameWith:_imageTip];
    
    [_tip sizeWith:CGSizeMake(120, 20)];
    [_tip layoutParentHorizontalCenter];
    [_tip alignParentBottomWithMargin:kDefaultMargin];
}

- (void)prepareForUse
{
    [self configOwnViews];
}

- (void)kvoSoundRecorder:(ChatSoundRecorder *)rec
{
    self.KVOController = [FBKVOController controllerWithObserver:self];
    
    __weak ChatRecoredView *ws = self;
    [self.KVOController observe:rec keyPath:@"recordPeak" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [ws onRecorderPeakChanged:(ChatSoundRecorder *)object];
    }];
    
    [self.KVOController observe:rec keyPath:@"recordState" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [ws onRecorderPeakStateChanged:(ChatSoundRecorder *)object];
    }];
}

- (void)onRecorderPeakChanged:(ChatSoundRecorder *)rec
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger peaker = rec.recordPeak;
        NSString *tip = [NSString stringWithFormat:@"microphone%d", (int)peaker];
        DebugLog(@"=--=-=-=-=-=-=-=-=-=-=-=");
        _imageTip.image = [UIImage imageNamed:tip];
    });
}

- (void)onRecorderPeakStateChanged:(ChatSoundRecorder *)rec
{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (rec.recordState)
        {
            case EChatRecorder_Stoped:
            {
                [self fadeOut:0.2 delegate:nil];
            }
                break;
            case EChatRecorder_Recoring:
            {
                _imageTip.hidden = NO;
                [self onRecorderPeakChanged:rec];
                
                _tip.text = @"手指上滑，取消发送";
                _tip.backgroundColor = kClearColor;
            }
                break;
            case EChatRecorder_RelaseCancel:
            {
                _tip.text = @"松开手指，取消发送";
                _tip.backgroundColor = kRedColor;
            }
                break;
            case EChatRecorder_Countdown:
            {
                _imageTip.hidden = YES;
                _countdownTip.text = [NSString stringWithFormat:@"%d", (int)(kChatRecordMaxDuration - rec.recordDuration)];
                _countdownTip.hidden = NO;
            }
                break;
            case EChatRecorder_MaxRecord:
            {
                _tip.text = @"录音超过一分钟自动发送";
                _tip.backgroundColor = kClearColor;
                
            }
                break;
            case EChatRecorder_TooShort:
            {
                _tip.text = @"录音太短，取消发送";
                _tip.backgroundColor = kClearColor;
            }
                break;
                
            default:
                break;
        }
    });
}

@end


@interface ChatSoundRecorder()

@property (nonatomic, strong) AVAudioSession    *session;
@property (nonatomic, strong) AVAudioRecorder   *recorder;


@property (nonatomic, weak) IMAConversation     *conversation;



@property (nonatomic, copy) NSString            *recordSavePath;
@property (nonatomic, strong) NSTimer           *recorderTimer;
@property (nonatomic, strong) NSTimer           *recorderPeakerTimer;
@property (nonatomic, strong) ChatRecoredView   *recordTipView;


@end

@implementation ChatSoundRecorder

static ChatSoundRecorder *_sharedInstance = nil;
+ (void)configWith:(IMAConversation *)conv
{
    [ChatSoundRecorder sharedInstance].conversation = conv;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc ] init];
        
    });
    
    return _sharedInstance;
}

+ (void)destory
{
    [_sharedInstance stopRecord];
    _sharedInstance.recorder = nil;
    
    [_sharedInstance.recordTipView removeFromSuperview];
    _sharedInstance.recordTipView = nil;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _recordPeak = 1;
        _recordDuration = 0;
        [self activeAudioSession];
    }
    return self;
}

- (void)dealloc
{
    AVAudioSession *aSession = [AVAudioSession sharedInstance];
    [aSession setCategory:_audioSesstionCategory withOptions:_audioSesstionCategoryOptions error:nil];
    [aSession setMode:_audioSesstionMode error:nil];
    
    [_recordTipView removeFromSuperview];
    _recordTipView = nil;
}

// 开启始终以扬声器模式播放声音
- (void)activeAudioSession
{
    self.session = [AVAudioSession sharedInstance];
    NSError *sessionError = nil;
    [self.session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    _audioSesstionCategory = [self.session category];
    _audioSesstionMode = [self.session mode];
    _audioSesstionCategoryOptions = [self.session categoryOptions];
    
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"    
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride),  &audioRouteOverride);
    #pragma clang diagnostic pop
    if(!self.session)
    {
        DebugLog(@"Error creating session: %@", [sessionError description]);
    }
    else
    {
        [self.session setActive:YES error:nil];
    }
}

- (BOOL)initRecord
{
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    
    NSString *strUrl = [NSString stringWithFormat:@"%@/%@.mp4", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], [NSString uuid]];
    NSURL *url = [NSURL fileURLWithPath:strUrl];
    
    self.recordSavePath = strUrl;
    //    self.audioRecord.filePath = strUrl;
    
    NSError *error = nil;
    //初始化
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&error];
    //开启音量检测
    self.recorder.meteringEnabled = YES;
    
    if ([self.recorder prepareToRecord])
    {
        return YES;
    }
    
    DebugLog(@"录音机初始化失败");
    return NO;
}


- (void)showRecordView
{
    UIViewController *topViewController = [AppDelegate sharedAppDelegate].topViewController;
    
    if (!_recordTipView)
    {
        _recordTipView = [[ChatRecoredView alloc] init];
        [_recordTipView kvoSoundRecorder:self];
        
        UIView *view = topViewController.view;
        [view addSubview:_recordTipView];
        
        [_recordTipView layoutParentCenter];
        [_recordTipView move:CGPointMake(0, -32)];
    
    }
    
    //禁用导航栏上右侧按钮
    UIBarButtonItem *rightItem = topViewController.navigationItem.rightBarButtonItem;
    rightItem.enabled = NO;
    
    [_recordTipView prepareForUse];
    [_recordTipView fadeIn:0.2 delegate:nil];
}

- (void)startRecord
{
    // 获取麦克风权限
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    if ([avSession respondsToSelector:@selector(requestRecordPermission:)])
    {
        [avSession requestRecordPermission:^(BOOL available) {
            if (!available)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:@"无法录音" message:@"请在“设置-隐私-麦克风”中允许访问麦克风。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self startRecording];
                });
            }
        }];
    }
}

- (void)startRecording
{
    if (self.recordState == EChatRecorder_TooShort)
    {
        return;
    }
    
    [self.recorder stop];
    if (![self initRecord])
    {
        [[HUDHelper sharedInstance] tipMessage:@"初始化录音机失败"];
        return;
    }
    
    [self.recorder record];
    
    [self showRecordView];
    
    self.recordPeak = 1;
    self.recordDuration = 0;
    self.recordState = EChatRecorder_Recoring;
    
    _recorderTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onRecording) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_recorderTimer forMode:NSRunLoopCommonModes];
    
    _recorderPeakerTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(onRecordPeak) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_recorderPeakerTimer forMode:NSRunLoopCommonModes];
}

- (void)onRecordPeak
{
    [_recorder updateMeters];
    
    CGFloat peakPower = 0;
    peakPower = [_recorder peakPowerForChannel:0];
    peakPower = pow(10, (0.05 * peakPower));
    
    NSInteger peak = (NSInteger)((peakPower * 100)/20 + 1);
    if (peak < 1)
    {
        peak = 1;
    }
    else if (peak > 5)
    {
        peak = 5;
    }
    if (peak != self.recordPeak)
    {
        self.recordPeak = peak;
    }
}

- (void)onRecording
{
    _recordDuration++;
    if (_recordDuration == kChatRecordMaxDuration)
    {
        [_recorderTimer invalidate];
        _recorderTimer = nil;
        
        [_recorderPeakerTimer invalidate];
        _recorderPeakerTimer = nil;
        
        self.recordState = EChatRecorder_MaxRecord;
        [self stopRecord];
    }
    else if (_recordDuration >= 50)
    {
        // 开始倒计时
        self.recordDuration = _recordDuration;
        self.recordState = EChatRecorder_Countdown;
        
    }
    else if (_recordDuration == 1)
    {
        // 预添加语音消息到界面
        
        if ([_recorderDelegate respondsToSelector:@selector(onChatInput:willSendMsg:)])
        {
            _recordingMsg = [IMAMsg msgWithEmptySound];
            [_recorderDelegate onChatInput:nil willSendMsg:_recordingMsg];
        }
        
    }
    
    
}

- (void)willCancelRecord
{
    if (_recordDuration > 50)
    {
        self.recordState = EChatRecorder_Countdown;
    }
    else
    {
        self.recordState = EChatRecorder_RelaseCancel;
    }
}

- (void)continueRecord
{
    if (_recordDuration > 50)
    {
        self.recordState = EChatRecorder_Countdown;
    }
    else
    {
        self.recordState = EChatRecorder_Recoring;
    }
}

- (void)stopRecord
{
    //禁用导航栏上右侧按钮
    UIBarButtonItem *rightItem = [AppDelegate sharedAppDelegate].topViewController.navigationItem.rightBarButtonItem;
    rightItem.enabled = YES;
    
    [_recorderTimer invalidate];
    _recorderTimer = nil;
    
    [_recorderPeakerTimer invalidate];
    _recorderPeakerTimer = nil;
    
    NSTimeInterval duration = self.recorder.currentTime;
    
    
    if (self.recordState == EChatRecorder_RelaseCancel)
    {
        // TODO:取消发送
        self.recordState = EChatRecorder_Stoped;
        if ([_recorderDelegate respondsToSelector:@selector(onChatInput:cancelSendMsg:)])
        {
            [_recorderDelegate onChatInput:nil cancelSendMsg:_recordingMsg];
        }
        return;
    }
    
    if (duration < 0.5)
    {
        // 录音太短
        self.recordState = EChatRecorder_TooShort;
    }
    else
    {
        [self.recorder stop];
        NSData *audioData = [NSData dataWithContentsOfFile:self.recordSavePath];
        NSInteger dur = (NSInteger)(duration + 0.5);
        IMAMsg *smsg = [IMAMsg msgWithSound:audioData duration:dur];
        // TODO:发送消息
        if ([_recorderDelegate respondsToSelector:@selector(onChatInput:replaceWith:oldMsg:)])
        {
            [_recorderDelegate onChatInput:nil replaceWith:smsg oldMsg:_recordingMsg];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.recordState = EChatRecorder_Stoped;
    });
    
    
    [self.recorder stop];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.recorder.url.path])
    {
        if (!self.recorder.recording)
        {
            [self.recorder deleteRecording];
        }
    };
    
}


- (NSInteger)recordTime
{
    return self.recorder.currentTime + 0.5;
}


//==========================================


@end


@interface ChatSoundPlayer ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *soundPlayer;
@property (nonatomic, copy) CommonVoidBlock playCompletion;

@end

@implementation ChatSoundPlayer

static ChatSoundPlayer *_sharedPlayer = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPlayer = [[ChatSoundPlayer alloc ] init];
        
    });
    
    return _sharedPlayer;
}

+ (void)destory
{
    [_sharedPlayer stopPlay];
    _sharedPlayer.soundPlayer = nil;
    _sharedPlayer.playCompletion = nil;
}


- (void)playWith:(NSData *)data finish:(CommonVoidBlock)completion
{
    [self stopPlay];
    
    self.playCompletion = completion;
    
    NSError *playerError = nil;
    _soundPlayer = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
    
    if (_soundPlayer)
    {
        _soundPlayer.delegate = self;
        [_soundPlayer prepareToPlay];
        [_soundPlayer play];
    }
    else
    {
        DebugLog(@"Error creating player: %@", [playerError description]);
        if (_playCompletion)
        {
            _playCompletion();
        }
    }
    
}

- (void)playWithUrl:(NSURL *)url finish:(CommonVoidBlock)completion
{
    [self stopPlay];
    
    self.playCompletion = completion;
    
    NSError *playerError = nil;
    NSError *err = nil;
    _soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    
    if (_soundPlayer)
    {
        _soundPlayer.delegate = self;
        [_soundPlayer prepareToPlay];
        [_soundPlayer play];
    }
    else
    {
        DebugLog(@"Error creating player: %@", [playerError description]);
        if (_playCompletion)
        {
            _playCompletion();
        }
    }
}
- (void)stopPlay
{
    if (_playCompletion)
    {
        _playCompletion();
    }
    
    
    if (_soundPlayer)
    {
        if (_soundPlayer.isPlaying)
        {
            [_soundPlayer stop];
        }
        
        _soundPlayer.delegate = nil;
        _soundPlayer = nil;
    }
    
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (_playCompletion)
    {
        _playCompletion();
    }
    _playCompletion = nil;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error
{
    if (_playCompletion)
    {
        _playCompletion();
    }
    _playCompletion = nil;
}


@end
