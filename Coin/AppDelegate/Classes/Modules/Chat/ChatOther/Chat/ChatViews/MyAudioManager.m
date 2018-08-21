//
// Copyright 1999-2015 MyApp
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "MyAudioManager.h"
#import <AVFoundation/AVFoundation.h>
#import "NSStringEx.h"

@interface MyAudioManager()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSURL *recordFileURL;
@property (nonatomic, copy)   NSString *recordUrlKey;
@property (nonatomic, copy) didPlayFinish finishBlock;

@end


@implementation MyAudioManager


+ (instancetype)sharedInstance
{
    static MyAudioManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc ] init];
        [_sharedInstance activeAudioSession];
    });
    
    return _sharedInstance;
}

// 开启始终以扬声器模式播放声音
- (void)activeAudioSession
{
    self.session = [AVAudioSession sharedInstance];
    NSError *sessionError = nil;
    [self.session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    AudioSessionSetProperty (
                             kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride
                             );
#pragma clang diagnostic pop
    if(!self.session) {
        DebugLog(@"Error creating session: %@", [sessionError description]);
    }
    else {
        [self.session setActive:YES error:nil];
    }
}

- (void)playWithData:(NSData *)data finish:(void (^)())didFinish;
{
    [self stopPlay];
    
    self.finishBlock = didFinish;
    if (self.player) {
        if (self.player.isPlaying) {
            [self.player stop];
        }
        
        self.player.delegate = nil;
        self.player = nil;
    }
    
    NSError *playerError = nil;
    self.player = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
    if (self.player)
    {
        self.player.delegate = self;
        [self.player play];
    }
    else
    {
        DebugLog(@"Error creating player: %@", [playerError description]);
    }
}

- (void)stopPlay
{
    if (self.player)
    {
        if (self.player.isPlaying)
        {
            [self.player stop];
        }
        
        self.player.delegate = nil;
        self.player = nil;
        
        if (_finishBlock)
        {
            _finishBlock();
        }
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
    self.recordUrlKey = strUrl;
//    self.audioRecord.filePath = strUrl;
    
    NSError *error;
    //初始化
    _recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    //开启音量检测
    self.recorder.meteringEnabled = YES;
    
    
    if ([self.recorder prepareToRecord]){
        return YES;
    }
    return NO;
}


- (BOOL)startRecord
{
    return [self.recorder record];
}

- (void)stopRecordWithBlock:(didRecordFinish)block
{
    NSTimeInterval duration = self.recorder.currentTime;
    [self.recorder stop];
    
    if (block) {
        block(self.recordUrlKey, (NSInteger)(round(duration)));
    }
}


- (CGFloat)peakPowerMeter{
    CGFloat peakPower = 0;
    //    peakPower = [self.recorder peakPowerForChannel:0];
//    peakPower = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
    peakPower = 0.5;
    return peakPower;
}

- (NSInteger)recordTime{
    return self.recorder.currentTime+0.5;
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (self.finishBlock) {
        self.finishBlock();
    }
}
@end
