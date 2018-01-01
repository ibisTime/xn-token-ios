//
//  MicroVideoView.m
//  MicroVideo
//
//  Created by wilderliao on 16/5/16.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "MicroVideoView.h"

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kRecordMaxTime 5.0
#define kRefreshRate 60.0
//每秒刷新30次
#define kReduceWidth (kScreenWidth/kRecordMaxTime/kRefreshRate)

typedef void (^VonvertSucc)(NSString *path);

typedef void(^ChangeFocusSucc)(AVCaptureDevice *captureDevice);

@interface MicroVideoView()<AVCaptureFileOutputRecordingDelegate>
{
    AVCaptureSession            *_session;
    AVCaptureDevice             *_videoDevice;
    AVCaptureDevice             *_audioDevice;
    AVCaptureDeviceInput        *_videoInput;
    AVCaptureDeviceInput        *_audioInput;
    AVCaptureMovieFileOutput    *_movieOutput;
    AVCaptureVideoPreviewLayer  *_previewLayer;
    
    UIView  *_showPlayerView;
    NSString *_savePath;
    BOOL _isCancelRecord;
}
@end

@implementation MicroVideoView

//<------------相机部分------------->
//获取摄像头授权
- (void)getAuthorization
{
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo])
    {
        case AVAuthorizationStatusAuthorized:   //已授权
        {
            DebugLog(@"AVAuthorizationStatusAuthorized");
            [self initialSession];
        }
            break;
        case AVAuthorizationStatusNotDetermined://未授权
        {
            DebugLog(@"AVAuthorizationStatusNotDetermined");
            __weak MicroVideoView *ws = self;
            //请求权限
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if(granted)
                     {
                         DebugLog(@"initialsession begin");
                         [ws initialSession];
                         return;
                     }
                     else
                     {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在设备的\"设置-隐私-相机\"中允许访问相机。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                         [alert show];
#pragma clang diagnostic pop
                         
                         [ws onCancelBtn:_cancelBtn];
                         return;
                     }
                 });
             }];
        }
            break;
        default:
        {
            DebugLog(@"default");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在设备的\"设置-隐私-相机\"中允许访问相机。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
#pragma clang diagnostic pop
            [self onCancelBtn:_cancelBtn];
            
        }
            break;
    }
}


- (void)initialSession
{
    //init AVCaptureSession
    _session = [[AVCaptureSession alloc] init];
    if ([_session canSetSessionPreset:AVCaptureSessionPreset640x480])
    {
        [_session setSessionPreset:AVCaptureSessionPreset640x480];
    }
    
    //
    [_session beginConfiguration];
    
    [self addVideo];
    [self addAudio];
    [self addPreviewLayer];
    
    [_session commitConfiguration];
    
    [_session startRunning];
    
}

- (void)addVideo
{
    _videoDevice = [self deviceWithMediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    
    [self addVideoInput];
    [self addMovieOutput];
}

- (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType position:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = devices.firstObject;
    
    for (AVCaptureDevice *device in devices)
    {
        if (device.position == position)
        {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

- (void)addVideoInput
{
    if (!_videoDevice || !_session)
    {
        return;
    }
    
    NSError *error;
    
    // 视频输入对象
    // 根据输入设备初始化输入对象，用户获取输入数据
    _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:_videoDevice error:&error];
    if (error)
    {
        NSLog(@"获取摄像头出错--->>>%@",error);
        return;
    }
    
    // 将视频输入对象添加到会话 (AVCaptureSession) 中
    if ([_session canAddInput:_videoInput])
    {
        [_session addInput:_videoInput];
    }
    
}

- (void)addMovieOutput
{
    if (!_session)
    {
        return;
    }
    // 拍摄视频输出对象
    // 初始化输出设备对象，用户获取输出数据
    _movieOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    if ([_session canAddOutput:_movieOutput])
    {
        [_session addOutput:_movieOutput];
        
        AVCaptureConnection *captureConnection = [_movieOutput connectionWithMediaType:AVMediaTypeVideo];

        if ([captureConnection isVideoStabilizationSupported])
        {
            if ([captureConnection respondsToSelector:@selector(setPreferredVideoStabilizationMode:)])
            {
                captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
            }
        }
        
        captureConnection.videoScaleAndCropFactor = captureConnection.videoMaxScaleAndCropFactor;
    }
}

- (void)addAudio
{
    NSError *error;
    // 添加一个音频输入设备
    _audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    //  音频输入对象
    _audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:_audioDevice error:&error];
    if (error)
    {
        NSLog(@"获取音频设备出错--->>>%@",error);
        return;
    }
    // 将音频输入对象添加到会话 (AVCaptureSession) 中
    if ([_session canAddInput:_audioInput])
    {
        [_session addInput:_audioInput];
    }
}

//创建预览层
- (void)addPreviewLayer
{
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    _previewLayer.frame = _showPlayerView.bounds;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.connection.videoOrientation = [_movieOutput connectionWithMediaType:AVMediaTypeVideo].videoOrientation;
    _previewLayer.position = CGPointMake(_showPlayerView.frame.size.width * 0.5, _showPlayerView.frame.size.height * 0.5);
    
    CALayer *layer = _showPlayerView.layer;
    layer.masksToBounds = YES;
    self.layer.masksToBounds = YES;
    [layer addSublayer:_previewLayer];
}

- (NSURL *)outputCaches
{
    NSString *tempDir = NSTemporaryDirectory();
    _savePath = [NSString stringWithFormat:@"%@%@", tempDir, @"record_video.MOV"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:_savePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:_savePath error:nil];
    }
    return [NSURL fileURLWithPath:_savePath];
}

- (void)startRecord
{
    [_movieOutput startRecordingToOutputFileURL:[self outputCaches] recordingDelegate:self];
}

- (void)stopRecord
{
    // 取消视频拍摄
    [_movieOutput stopRecording];
}

- (void)quit
{
    [_session stopRunning];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    if (!_isCancelRecord)
    {
        NSLog(@"didFinishRecordingToOutputFileAtURL--> %@", _savePath);

        NSString *nsTmpDIr = NSTemporaryDirectory();
        NSString *videoPath = [NSString stringWithFormat:@"%@record_video_mp4_%3.f.%@", nsTmpDIr, [NSDate timeIntervalSinceReferenceDate], @"mp4"];

        AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:outputFileURL options:nil];
        __weak MicroVideoView *ws = self;
        
        [[HUDHelper sharedInstance] syncLoading:@"正在格式转换"];
        
        [self convertToMP4:urlAsset videoPath:videoPath succ:^(NSString *path) {

            dispatch_async(dispatch_get_main_queue(), ^{
                [[HUDHelper sharedInstance] syncStopLoading];
                
                [ws.delegate touchUpDone:path];
                [self onCancelBtn:_cancelBtn];
            });

        } fail:^{
            [[HUDHelper sharedInstance] syncStopLoadingMessage:@"格式转换失败"];
        }];
    }
}

- (void)convertToMP4:(AVURLAsset*)avAsset videoPath:(NSString*)videoPath succ:(VonvertSucc)succ fail:(void (^)())fail
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
                    if (fail)
                    {
                       fail();
                    }
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    if (fail)
                    {
                        fail();
                    }
                    break;
                default:
                    if (succ)
                    {
                        succ(videoPath);
                    }
                    break;
            }
        }];
    }
}

//<------------UI部分------------->
- (instancetype)initWithFrame:(CGRect)frame
{
    NSLog(@"w=%f,h=%f",frame.size.width,frame.size.height);
    if (frame.size.width < 240)
    {
        frame.size.width = 240;
    }
    if (frame.size.height < 240)
    {
        frame.size.height = 240;
    }
    if (self = [super initWithFrame:frame])
    {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.userInteractionEnabled = YES;
    
    [self setImage:[UIImage imageNamed:@"record_video_bg"]];
    
    [self addSubviews];
    [self configSubviews];
    [self addGensture];
    
    [self getAuthorization];
}

- (void)addGensture
{
    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.delaysTouchesBegan = YES;
    
    UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.delaysTouchesBegan = YES;
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    [_showPlayerView addGestureRecognizer:singleTap];
    [_showPlayerView addGestureRecognizer:doubleTap];
}

-(void)singleTap:(UITapGestureRecognizer *)tapGesture
{
    CGPoint point = [tapGesture locationInView:_showPlayerView];
    
    [_focusView.layer removeAllAnimations];
    
    __weak MicroVideoView *ws = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [ws layoutFoucsView:point];
    });
    
    CGPoint capturePoint = [_previewLayer captureDevicePointOfInterestForPoint:point];
    
    [self modifyCaptureProperty:^(AVCaptureDevice *captureDevice) {
        //聚焦
        if ([captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
        {
            [captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        else
        {
            NSLog(@"聚焦失败");
        }
        
        //聚焦点的位置
        if ([captureDevice isFocusPointOfInterestSupported])
        {
            [captureDevice setFocusPointOfInterest:capturePoint];
        }
        
        //曝光模式
        if ([captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose])
        {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        else
        {
            NSLog(@"曝光模式修改失败");
        }
        
        //曝光点的位置
        if ([captureDevice isExposurePointOfInterestSupported])
        {
            [captureDevice setExposurePointOfInterest:capturePoint];
        }
    }];
}

-(void)doubleTap:(UITapGestureRecognizer *)tapGesture
{
    CGPoint point = [tapGesture locationInView:_showPlayerView];
    
    [_focusView.layer removeAllAnimations];
    
    __weak MicroVideoView *ws = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [ws layoutFoucsView:point];
    });
    
    [self modifyCaptureProperty:^(AVCaptureDevice *captureDevice){
        
        if (captureDevice.videoZoomFactor == 1.0)
        {
            CGFloat current = 2.0;
            if (current < captureDevice.activeFormat.videoMaxZoomFactor)
            {
                [captureDevice rampToVideoZoomFactor:current withRate:10];
            }
        }
        else
        {
            [captureDevice rampToVideoZoomFactor:1.0 withRate:10];
        }
        
    }];
}

- (void)layoutFoucsView:(CGPoint)point
{
    NSLog(@"(------%f,%f-----)",point.x, point.y);

    CGFloat focusViewWidth = _focusView.frame.size.width;
    CGFloat focueviewHeight = _focusView.frame.size.height;
    
    [_focusView setFrame:CGRectMake(point.x - focusViewWidth/2, point.y, focusViewWidth, focueviewHeight)];
    _focusView.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _focusView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        _focusView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        if (!finished)
        {
            NSLog(@"fail 0.5");
            _focusView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            _focusView.alpha = 1;
        }
        else
        {
            [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                _focusView.alpha = 0;
            } completion:^(BOOL finished) {
                
                _focusView.hidden = YES;
                _focusView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                
                if (!finished)
                {
                    NSLog(@"fail 2.0");
                    _focusView.alpha = 0;
                }
                
            }];
        }
    }];
}

-(void)modifyCaptureProperty:(ChangeFocusSucc)capture
{
    AVCaptureDevice *captureDevice= [_videoInput device];
    NSError *error;

    BOOL isLock = [captureDevice lockForConfiguration:&error];
    if (!isLock)
    {
        NSLog(@"锁定锁定出错:%@",error.localizedDescription);
    }
    else
    {
        [_session beginConfiguration];
        capture(captureDevice);
        [captureDevice unlockForConfiguration];
        [_session commitConfiguration];
    }
}

- (void)addSubviews
{
    //预览视图
    _showPlayerView = [[UIView alloc] init];
    [self addSubview:_showPlayerView];
    
    //录制按钮
    _recordBtn = [[UIButton alloc] init];
    [self addSubview:_recordBtn];
    
    //取消按钮
    _cancelBtn = [[UIButton alloc] init];
    [self addSubview:_cancelBtn];
    
    //上滑取消显示面板视图
    _upSlidePanel = [[UIView alloc] init];
    [self addSubview:_upSlidePanel];
    
    _upSlidePic = [[UIImageView alloc] init];
    [_upSlidePanel addSubview:_upSlidePic];
    
    _upSlideText = [[UILabel alloc] init];
    [_upSlidePanel addSubview:_upSlideText];
    
    //松手取消文本
    _touchUpCancel = [[UIImageView alloc] init];
    [self addSubview:_touchUpCancel];
    
    //录制时时间限制的动画线条
    _progressView = [[UIView alloc] init];
    [self addSubview:_progressView];
    
    _focusView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"record_focusbutton"]];
    [self addSubview:_focusView];
}

- (void)configSubviews
{
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    
    CGFloat top = 25;
    
    [_showPlayerView setFrame:CGRectMake(0, top, selfWidth, selfHeight * 3/4 - top)];
    
    [_recordBtn setFrame:CGRectMake(selfWidth/2 - 30, selfHeight * 3/4 + selfHeight * 1/4 / 2 - 30, 60, 60)];
    [_recordBtn setBackgroundImage:[UIImage imageNamed:@"record_normal"] forState:UIControlStateNormal];
    [_recordBtn setBackgroundImage:[UIImage imageNamed:@"record_hover"] forState:UIControlStateHighlighted];
    [_recordBtn addTarget:self action:@selector(onRecordTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_recordBtn addTarget:self action:@selector(onRecordTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onRecordTouch:)];
    [_recordBtn addGestureRecognizer:pan];
    
    [_cancelBtn setFrame:CGRectMake(selfWidth * 3/4, selfHeight * 3/4 + selfHeight * 1/4 / 2 - 30, 60, 60)];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_cancelBtn addTarget:self action:@selector(onCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [_upSlidePanel setFrame:CGRectMake(selfWidth/2-30, top, 60, 15)];
    [_upSlidePanel setHidden:YES];
    [self bringSubviewToFront:_upSlidePanel];
    
    [_upSlidePic setFrame:CGRectMake(0, 5, 10, 12)];
    [_upSlidePic setImage:[UIImage imageNamed:@"record_upbutton"]];
    
    [_upSlideText setFrame:CGRectMake(10, 5, 50, 15)];
    [_upSlideText setText:@"上滑取消"];
    [_upSlideText setTextAlignment:NSTextAlignmentRight];
    [_upSlideText setFont:[UIFont systemFontOfSize:12.0]];
    [_upSlideText setTextColor:[UIColor blueColor]];
    
    [_touchUpCancel setFrame:CGRectMake(selfWidth/2 - 25, top+5, 50, 15)];
    [_touchUpCancel setImage:[UIImage imageNamed:@"record_cancelbutton"]];
    [_touchUpCancel setHidden:YES];
    [self bringSubviewToFront:_touchUpCancel];
    
    [_progressView setFrame:CGRectMake(0, selfHeight * 3/4, selfWidth, 4)];
    [_progressView setBackgroundColor:[UIColor blueColor]];
    [_progressView setHidden:YES];
    [_progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [_focusView setHidden:YES];
    [_focusView setBackgroundColor:[UIColor clearColor]];
    [_focusView setFrame:CGRectMake(selfWidth/2 - 50, selfHeight * 1/2 - 50,100, 100)];
}

- (void)reLayoutSubviews
{
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    
    NSLog(@"layoutSubviews");
    
    [_recordBtn setFrame:CGRectMake(selfWidth/2 - 30, selfHeight * 3/4 + selfHeight * 1/4 / 2 - 30, 60, 60)];
    
    [_progressView setFrame:CGRectMake(0, selfHeight * 3/4, selfWidth, 4)];
    
}

- (void)startAnimation
{
    [UIView animateWithDuration:0.5 animations:^{
        _progressView.hidden = NO;
        _cancelBtn.hidden = YES;
        _upSlidePanel.hidden = NO;
        
        _recordBtn.alpha = 0;
        _recordBtn.transform = CGAffineTransformMakeScale(2.0, 2.0);
        
        [self initTimer];
        [self startRecord];
    }];
}

- (void)stopAnimating
{
    _cancelBtn.hidden = NO;
    
    _progressView.hidden = YES;
    _upSlidePanel.hidden = YES;
    _touchUpCancel.hidden = YES;
    
    _recordBtn.alpha = 1.0;
    _recordBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [self reLayoutSubviews];

    [self stopRecord];
    
    if (_timer)
    {
        [_timer invalidate];
    }
    _timer = nil;
}

- (void)initTimer
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:(1/kRefreshRate) target:self selector:@selector(onRefresh:) userInfo:nil repeats:YES];
}

- (void)onRefresh:(NSTimer *)timer
{
    CGRect oldRect = _progressView.frame;
    if (oldRect.size.width-kReduceWidth < 0)
    {
        _isCancelRecord = NO;
        [self stopAnimating];
    }
    else
    {
        [_progressView setFrame:CGRectMake(oldRect.origin.x+kReduceWidth/2, oldRect.origin.y, oldRect.size.width-kReduceWidth, oldRect.size.height)];
    }
}

- (void)onRecordTouchDown:(UIButton *)button
{
    [self startAnimation];
}

- (void)onRecordTouchUpInside:(UIButton *)button
{
    _isCancelRecord = NO;
    [self stopAnimating];
}

- (void)onRecordTouch:(UIPanGestureRecognizer *)gesture
{
    //point.y 向上为负数，向下为正数
    CGPoint point = [gesture translationInView:self];
    
    if (point.y < -10) //向上移动
    {
        _touchUpCancel.hidden = NO;
        _upSlidePanel.hidden = YES;
    }
    else //向下移动
    {
        _touchUpCancel.hidden = YES;
        _upSlidePanel.hidden = NO;
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        _isCancelRecord = YES;
        [self stopAnimating];
    }
}

- (void)onCancelBtn:(UIButton *)button
{
    [self quit];
    [self removeFromSuperview];
}

@end
