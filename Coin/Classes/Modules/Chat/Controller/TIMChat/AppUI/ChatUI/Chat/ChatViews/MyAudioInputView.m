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

#import "MyAudioInputView.h"
#import "MyVolumeMeter.h"
#import "MyPttRecordBtn.h"
#import "NSStringEx.h"
#import "MyAudioManager.h"

@implementation AudioRecord


@end

@interface MyAudioInputView(){
    BOOL _hasStartRecording;
    MyVolumeMeter *_volumeMeter;
    
}

//@property (nonatomic, strong)AVAudioRecorder *recorder;
@property (nonatomic, strong)AudioRecord* audioRecord;

@property (nonatomic, strong)UILabel* pttTipsLable;
@property (nonatomic, strong)UIActivityIndicatorView* indicator;
@property (nonatomic, strong)UILabel* preparingTipsLable;
@property (nonatomic, strong)UILabel* timeLable;
@property (nonatomic, strong)UILabel* operationTipsLabel;
@property (nonatomic, strong)UIView* operationViewContainer;
@property (nonatomic, strong)UIButton *playBtn;
@property (nonatomic, strong)UIButton *deleteBtn;
@property (nonatomic, strong)UIImageView *playBtnBg;
@property (nonatomic, strong)UIImageView *deleteBtnBg;
@property (nonatomic, strong)MyPttRecordBtn *recordBtn;
@property (nonatomic, strong)UIImage *operationBgNor;
@property (nonatomic, strong)UIImage *operationBgSel;
@property (nonatomic, strong)UIButton *cancelBtn;
@property (nonatomic, strong)UIButton *sendBtn;
@property (nonatomic, strong)NSTimer *refreshTimer;

@end

@implementation MyAudioInputView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        NSError* error;
//        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
//        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
//        [audioSession setActive:YES error: &error];
        
        _pttTipsLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, frame.size.width, 16)];
        _pttTipsLable.text = @"按住说话";
        _pttTipsLable.font = [UIFont  systemFontOfSize:16];
        _pttTipsLable.textAlignment = NSTextAlignmentCenter;
        _pttTipsLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_pttTipsLable];
        
        // 正在准备失败时的提示
        _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGFloat indicatorWidth = _indicator.frame.size.width;
        _indicator.frame = CGRectMake(frame.size.width / 2 - indicatorWidth - 20, 18, indicatorWidth, indicatorWidth);
        _indicator.hidden = YES;
        [self addSubview:_indicator];
        _preparingTipsLable = [[UILabel alloc]initWithFrame:CGRectMake(_indicator.frame.origin.x + indicatorWidth + 4, 20, 100, 16)];
        _preparingTipsLable.text = @"准备中";
        _preparingTipsLable.hidden = YES;
        _preparingTipsLable.font = [UIFont  systemFontOfSize:16];
        _preparingTipsLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_preparingTipsLable];
        
        
        // 显示时间
        _timeLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, frame.size.width, 16)];
        _timeLable.text = @"0:00";
        _timeLable.font = [UIFont  systemFontOfSize:16];
        _timeLable.hidden = YES;
        _timeLable.textAlignment = NSTextAlignmentCenter;
        _timeLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_timeLable];
        
        // 操作按钮提示语
        _operationTipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, frame.size.width, 16)];
        _operationTipsLabel.font = [UIFont  systemFontOfSize:16];
        _operationTipsLabel.hidden = YES;
        _operationTipsLabel.textAlignment = NSTextAlignmentCenter;
        _operationTipsLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_operationTipsLabel];
        
        _operationViewContainer = [[UIView alloc]initWithFrame:CGRectMake(20, 60, frame.size.width - 40, 51)];
        [self addSubview:_operationViewContainer];
        _operationViewContainer.hidden = YES;
        
        // 按住录音时显示操作指引的那条线
        UIImage* image = [UIImage imageNamed:@"aio_voice_line.png"];
        UIImageView *line = [[UIImageView alloc]initWithImage:image];
        CGSize lineSize = {image.size.width,image.size.height};
        line.frame = CGRectMake((_operationViewContainer.frame.size.width - lineSize.width) / 2, _operationViewContainer.frame.size.height - lineSize.height, lineSize.width, lineSize.height);
        [_operationViewContainer addSubview:line];
        
        // 按住说话时显示的操作按钮的背景图
        _operationBgNor = [UIImage imageNamed:@"aio_voice_operate_nor.png"];
        _operationBgSel = [UIImage imageNamed:@"aio_voice_operate_press.png"];
        _playBtnBg = [[UIImageView alloc]initWithImage:_operationBgNor];
        _playBtnBg.frame = CGRectMake(0, 0, _operationBgNor.size.width, _operationBgNor.size.height);
        [_operationViewContainer addSubview:_playBtnBg];
        
        // 试听按钮图片
        UIImage *playImage = [UIImage imageNamed:@"aio_voice_operate_listen_nor.png"];
        _playBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, playImage.size.width, playImage.size.height)];
        _playBtn.center = _playBtnBg.center;
        [_playBtn setImage:playImage forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"aio_voice_operate_listen_press.png"] forState:UIControlStateHighlighted];
        [_operationViewContainer addSubview:_playBtn];
        
        // 删除按扭背景图片
        _deleteBtnBg = [[UIImageView alloc]initWithImage:_operationBgNor];
        _deleteBtnBg.frame = CGRectMake(_operationViewContainer.frame.size.width - _operationBgNor.size.width, 0, _operationBgNor.size.width, _operationBgNor.size.height);
        [_operationViewContainer addSubview:_deleteBtnBg];
        
        // 删除按钮图片
        UIImage *deleteImage = [UIImage imageNamed:@"aio_voice_operate_delete_nor.png"];
        _deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, deleteImage.size.width, deleteImage.size.height)];
        [_deleteBtn setImage:deleteImage forState:UIControlStateNormal];
        _deleteBtn.center = _deleteBtnBg.center;
        [_deleteBtn setImage:[UIImage imageNamed:@"aio_voice_operate_delete_press.png"] forState:UIControlStateHighlighted];
        [_operationViewContainer addSubview:_deleteBtn];
        
        
        // 按住说话按钮
        UIImage *recordBtnImageNor = [UIImage imageNamed:@"aio_voice_button_nor.png"];
        UIImage *recordBtnImagePre = [UIImage imageNamed:@"aio_voice_button_press.png"];
        CGRect recordBtnFrame = CGRectMake((frame.size.width - recordBtnImageNor.size.width) / 2, 51, recordBtnImageNor.size.width, recordBtnImageNor.size.height);
        _recordBtn = [[MyPttRecordBtn alloc]initWithFrame:recordBtnFrame];
        [_recordBtn setImage:recordBtnImageNor forState:UIControlStateNormal];
        [_recordBtn setImage:recordBtnImagePre forState:UIControlStateHighlighted];
        _recordBtn.touchDelegate = self;
        
        
        UIImageView *voiceIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aio_voice_button_icon.png"]];
        voiceIcon.frame = CGRectMake((recordBtnFrame.size.width - voiceIcon.image.size.width) / 2, (recordBtnFrame.size.height - voiceIcon.image.size.height) / 2, voiceIcon.image.size.width, voiceIcon.image.size.height);
        [_recordBtn addSubview:voiceIcon];
        
        [self addSubview:_recordBtn];
        
        
        CGFloat btnHeight = 39;
        // 取消按钮
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(0, frame.size.height - btnHeight, frame.size.width/2, btnHeight);
        _cancelBtn.hidden = YES;
        [_cancelBtn addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitle:NSLocalizedString(@"QQ_TXTID_Cancel",@"取消")forState:UIControlStateNormal];
        [_cancelBtn setBackgroundImage:[[UIImage imageNamed:@"aio_record_cancel_button.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3]forState:UIControlStateNormal];
        [_cancelBtn setBackgroundImage:[[UIImage imageNamed:@"aio_record_cancel_button_press.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3]forState:UIControlStateHighlighted];
        [self addSubview:_cancelBtn];
        
        //发送按钮
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.frame = CGRectMake(frame.size.width/2, frame.size.height - btnHeight, frame.size.width/2, btnHeight);
        _sendBtn.hidden = YES;
        [_sendBtn addTarget:self action:@selector(onSend) forControlEvents:UIControlEventTouchUpInside];
        [_sendBtn setTitle:NSLocalizedString(@"QQ_TXTID_Send",@"发送") forState:UIControlStateNormal];
        [_sendBtn setBackgroundImage:[[UIImage imageNamed:@"aio_record_send_button.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3]forState:UIControlStateNormal];
        [_sendBtn setBackgroundImage:[[UIImage imageNamed:@"aio_record_send_button_press.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3] forState:
         UIControlStateHighlighted];
        [self addSubview:_sendBtn];
        
    }
    return self;
}

- (AudioRecord*)audioRecord{
    if (_audioRecord == nil) {
        _audioRecord = [[AudioRecord alloc] init];
    }
    return _audioRecord;
}

- (void)removeFromSuperview{
    if (_refreshTimer) {
        [_refreshTimer invalidate];
        _refreshTimer = nil;
    }
    [super removeFromSuperview];
}


- (void)resetToStart
{
    _operationViewContainer.hidden = YES;
    _operationTipsLabel.hidden = YES;
    
    _timeLable.hidden = YES;
    _timeLable.text = @"0:00";
    [_refreshTimer invalidate];
    _refreshTimer = nil;
    
    [_recordBtn removeFromSuperview];
    [self addSubview:_recordBtn];
    
    _pttTipsLable.hidden = NO;
    
    _hasStartRecording = NO;
    
    [_volumeMeter endMonitor];
    [_volumeMeter removeFromSuperview];
    
    [_indicator stopAnimating];
    _preparingTipsLable.hidden = YES;
    
    _cancelBtn.hidden = YES;
    _sendBtn.hidden = YES;
    
}

- (void)onRecordDeviceReady{
    // 已经开始录音了才处理，防止按键太快松开后设备才准备好导致进入录音状态
    if (_hasStartRecording) {
        _timeLable.hidden = NO;
        _operationViewContainer.hidden = NO;
        _operationViewContainer.transform = CGAffineTransformMakeScale(0.86, 0.86);
        [UIView animateWithDuration:0.15f animations:^{
            _operationViewContainer.alpha = 1.f;
            _operationViewContainer.transform = CGAffineTransformIdentity;
        }];
        
        
        [_refreshTimer invalidate];
        _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateRecordTime) userInfo:nil repeats:YES];
        
        [_indicator stopAnimating];
        _preparingTipsLable.hidden = YES;
        
        if (_volumeMeter != nil) {
            [_volumeMeter removeFromSuperview];
        }
        _volumeMeter = [[MyVolumeMeter alloc]initWithFrame:CGRectMake((self.bounds.size.width - 150) / 2, 14, 150, 30)];
        _volumeMeter.volumeMeterDelegate = self;
        [self insertSubview:_volumeMeter atIndex:0];
        [_volumeMeter startMonitor];
    }

}


// 进入试听状态
- (void)showAudioPlayView
{
}


- (void)onPlayedTime:(int)seconds
{
    [self refreshTimeLable:seconds];
}

// 刷新时间
- (void)refreshTimeLable:(int)seconds
{
    int min = seconds / 60;
    int sec = seconds % 60;
    NSString *minString = [NSMutableString stringWithFormat:@"%d", min];
    NSMutableString *secString = [NSMutableString stringWithFormat:@"%d", sec];
    if (sec < 10) {
        [secString insertString:@"0" atIndex:0];
    }
    _timeLable.text = [NSString stringWithFormat:@"%@:%@", minString, secString];
    
}

- (void)showOpreateTips:(NSString *)tips
{
    _operationTipsLabel.text = tips;
    _operationTipsLabel.hidden = NO;
    _timeLable.hidden = YES;
    _volumeMeter.hidden = YES;
}

- (void)hideOperateTips
{
    _operationTipsLabel.hidden = YES;
    _timeLable.hidden = NO;
    _volumeMeter.hidden = NO;
}

- (void)updateRecordTime
{
    [self refreshTimeLable:round([[MyAudioManager sharedInstance] recordTime])];
}

// 取消按钮点击
- (void)onCancel
{
    [self stopRecord];
    [_volumeMeter endMonitor];
    
    [self resetToStart];
}

// 发送按钮点击
- (void)onSend
{
    // 发送消息
    [self sendAudio];
    
    // 停掉视频播放和音量监听，重置UI状态
    [_volumeMeter endMonitor];
    [self resetToStart];
}

// 计算两点距离
- (CGFloat)distanceFromPoint:(CGPoint)start toPoint:(CGPoint)end
{
    CGFloat xDis = start.x - end.x;
    CGFloat yDis = start.y - end.y;
    return sqrt((xDis * xDis) + (yDis * yDis));
}

// 按住说好移动过程中对操作按钮进行缩放
- (CGFloat)scacleOfView:(UIImageView *)view forPoint:(CGPoint)point
{
    CGFloat maxRadius = 100;
    CGFloat minRadius = 45;
    CGFloat distance = [self distanceFromPoint:point toPoint:view.center];
    CGFloat maxScale = 1.75;
    
    CGFloat scale = 1.f;
    if (distance <= minRadius) {
        scale = maxScale;
    }
    else if (distance > minRadius && distance < maxRadius) {
        scale = (maxRadius - distance) / (maxRadius - minRadius) * (maxScale - 1) + 1;
    }
    return scale;
    
}


#pragma mark QQPttTouchDelegate 按住说话按钮的点击事件回调
// 点击按住说好按钮，开始事件
- (void)touchBegin:(NSSet*)touches
{
    self.recordAuthority = NO;
    // 获取麦克风权限
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    if ([avSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [avSession requestRecordPermission:^(BOOL available) {
            self.recordAuthority = available;
            
            if (available) {
                //启动录音
                _pttTipsLable.hidden = YES;
                _preparingTipsLable.hidden = NO;
                [_indicator startAnimating];
                _indicator.hidden = NO;
                
                
                _hasStartRecording = YES;
                
                if ([self initRecord]) {
                    [self onRecordDeviceReady];
                    if (![self startRecord]) {
                        [self showOpreateTips:@"启动录音失败"];
                        return;
                    };
                }else{
                    //提示失败
                    //        _pttTipsLable.hidden = NO;
                    [self showOpreateTips:@"启动录音失败"];
                    return;
                }
                
                
                
                // 在录音时，禁用其他区域的事件响应
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:@"无法录音" message:@"请在“设置-隐私-麦克风”中允许访问麦克风。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                });
            }
        }];
    }
    // 做一个回弹的动画
    _recordBtn.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.08f animations:^{
        _recordBtn.transform = CGAffineTransformMakeScale(1.14, 1.14);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08 animations:^{
            _recordBtn.transform = CGAffineTransformMakeScale(0.96, 0.96);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.04 animations:^{
                _recordBtn.transform = CGAffineTransformIdentity;
            } completion:NULL];
        }];
    }];
}

//手指滑动事件
- (void)touchMove:(NSSet *)touches
{
    if (self.recordAuthority == NO) {
        return;
    }
    if (!_operationViewContainer.hidden) {
        UITouch* touch = [touches anyObject];
        CGPoint point = [touch locationInView:_operationViewContainer];
        
        CGFloat scale = [self scacleOfView:_playBtnBg forPoint:point];
        _playBtnBg.transform = CGAffineTransformMakeScale(scale, scale);
        
        NSString *operateTips = nil;
        
        // 达到最大缩放比例，设置选中状态
        if (scale >= 1.75) {
            _playBtnBg.image = _operationBgSel;
            _playBtn.highlighted = YES;
            operateTips = @"松手试听(暂不支持)";
        }
        else {
            _playBtnBg.image = _operationBgNor;
            _playBtn.highlighted = NO;
        }
        
        // 计算删除按钮的缩放比例，正常不会跟播放按钮同时放大，应该可以优化成播放按钮没放大时才计算 by robliu
        scale = [self scacleOfView:_deleteBtnBg forPoint:point];
        _deleteBtnBg.transform = CGAffineTransformMakeScale(scale, scale);
        
        // 达到最大缩放比例，设置选中状态
        if (scale >= 1.75) {
            _deleteBtnBg.image = _operationBgSel;
            _deleteBtn.highlighted = YES;
            operateTips = @"松手取消发送";
        }
        else {
            _deleteBtnBg.image = _operationBgNor;
            _deleteBtn.highlighted = NO;
        }
        
        if (operateTips != nil) {
            [self showOpreateTips:operateTips];
        }
        else {
            [self hideOperateTips];
        }
    }
}

// 取消事件，暂跟end事件同样处理
- (void)touchCancel:(NSSet *)touches
{
    if (self.recordAuthority == NO) {
        return;
    }
    [self touchEnd:touches];
}

// end事件处理
- (void)touchEnd:(NSSet *)touches
{
    if (self.recordAuthority == NO) {
        return;
    }
    // 播放试听
    if ([_playBtn isHighlighted]) {
        //暂不支持试听
        CGFloat recordTime = [[MyAudioManager sharedInstance] recordTime];
        // 时间太短了提示，不进入试听，回到初始状态
        if (recordTime < 2) {

            [self resetToStart];
        }
        else {
            [self showAudioPlayView];
            
            [self resetToStart];
        }
        [self stopRecord];
    }
    // 删除录音
    else if ([_deleteBtn isHighlighted]) {
        _deleteBtnBg.transform = CGAffineTransformIdentity;
        _deleteBtnBg.image = _operationBgNor;
        _deleteBtn.highlighted = NO;
        [self stopRecord];
        [self resetToStart];
    }
    else {
        //取文件数据,发送数据
        self.audioRecord.audioData = [NSData dataWithContentsOfFile:self.audioRecord.filePath];
        self.audioRecord.duration = [[MyAudioManager sharedInstance] recordTime];
        [self stopRecord];
        [self sendAudio];
        [self resetToStart];
    }
    
    [_refreshTimer invalidate];
    _refreshTimer = nil;
    _hasStartRecording = NO;
}

// 获取音量
- (CGFloat)peakPowerLevel
{
    return [[MyAudioManager sharedInstance] peakPowerMeter];
}


- (BOOL)initRecord{
    return [[MyAudioManager sharedInstance] initRecord];
}

- (BOOL)startRecord{
    return [[MyAudioManager sharedInstance] startRecord];
}

- (void)stopRecord{
    return [[MyAudioManager sharedInstance] stopRecordWithBlock:^(NSString *urlKey, NSInteger time){
        self.audioRecord.filePath = urlKey;
        self.audioRecord.audioData = [NSData dataWithContentsOfFile:self.audioRecord.filePath];
        self.audioRecord.duration = time;
    }];
}

- (void)sendAudio{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendAudioRecord:)]) {
        [self.delegate sendAudioRecord:self.audioRecord];
    }
    return;
}

@end
