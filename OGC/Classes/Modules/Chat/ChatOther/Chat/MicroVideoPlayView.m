//
//  MicroVideoPlayView.m
//  MicroVideo
//
//  Created by wilderliao on 16/5/23.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "MicroVideoPlayView.h"

#import <AVKit/AVKit.h>

#import <AVFoundation/AVFoundation.h>

#import <AssetsLibrary/AssetsLibrary.h>

@implementation MicroVideoPlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _selfFrame = frame;
        self.backgroundColor = [UIColor blackColor];
        [self addSubviews];
        [self configSubviews];
        [self relayoutSubViews];
        
        [self addObserver];
    }
    return self;
}

- (void)setMessage:(IMAMsg *)msg
{
    _msg = msg;
    [self setCoverImage];
}

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEndPlay:)name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onScaling:)];
    [self addGestureRecognizer:tap];
}

- (void)addSubviews
{
    _playerLayer = [AVPlayerLayer layer];
    [self.layer addSublayer:_playerLayer];
    
     _playerBtn = [[UIButton alloc] init];
    [self addSubview:_playerBtn];
}

- (void)configSubviews
{
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _playerLayer.masksToBounds = YES;
    
    [_playerBtn setBackgroundColor:[UIColor clearColor]];
    [_playerBtn setBackgroundImage:[UIImage imageNamed:@"record_playbutton"] forState:UIControlStateNormal];
    [_playerBtn setBackgroundImage:[UIImage imageNamed:@"record_errorbutton"] forState:UIControlStateDisabled];
    [_playerBtn addTarget:self action:@selector(onPlay:) forControlEvents:UIControlEventTouchUpInside];
}

//设置小视频消息封面图片
- (void)setCoverImage
{
    TIMUGCElem *elem = (TIMUGCElem *)[_msg.msg getElem:0];

    //将封面截图保存到 “Caches/视频id” 路径

    NSString *hostCachesPath = [self getHostCachesPath];
    if (!hostCachesPath)
    {
        return;
    }

    NSString *imagePath = [NSString stringWithFormat:@"%@/snapshot_%@", hostCachesPath, elem.videoId];

    NSFileManager *fileMgr = [NSFileManager defaultManager];

    if (elem.coverPath && [fileMgr fileExistsAtPath:elem.coverPath])
    {
        UIImage *image = [UIImage imageWithContentsOfFile:elem.coverPath];
        _coverImage = image;
        _playerLayer.contents = (__bridge id _Nullable)(image.CGImage);
    }
    else
    {
        __weak MicroVideoPlayView *ws = self;
//        if (elem.snapshot.uuid && elem.snapshot.uuid.length > 0)
        if (elem.videoId && elem.videoId.length > 0)
        {
            [elem.cover getImage:imagePath succ:^{
                UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                ws.coverImage = image;
                ws.playerLayer.contents = (__bridge id _Nullable)(image.CGImage);
            } fail:^(int code, NSString *msg) {
                UIImage *image = [UIImage imageNamed:@"default_video"];
                ws.coverImage = image;
                ws.playerLayer.contents = (__bridge id _Nullable)(image.CGImage);
                [[HUDHelper sharedInstance] syncStopLoadingMessage:IMALocalizedError(code, err)];
            }];
        }
    }
}

- (void)downloadVideo:(TIMSucc)succ fail:(TIMFail)fail
{
    TIMUGCElem *elem = (TIMUGCElem *)[_msg.msg getElem:0];

//    if (!(elem.video.uuid && elem.video.uuid.length > 0))
    if (!(elem.videoId && elem.videoId.length > 0))
    {
        DebugLog(@"小视频ID为空");
        if (fail)
        {
            fail(-1, @"小视频ID为空");
        }
        return;
    }
    
    NSString *hostCachesPath = [self getHostCachesPath];
    if (!hostCachesPath)
    {
        DebugLog(@"获取本地路径出错");
        if (fail)
        {
            fail(-2, @"获取本地路径出错");
        }
        return;
    }

    NSString *videoPath = [NSString stringWithFormat:@"%@/video_%@.%@", hostCachesPath, elem.videoId, elem.video.type];

    NSFileManager *fileMgr = [NSFileManager defaultManager];

    if ([fileMgr fileExistsAtPath:videoPath isDirectory:nil])
    {
        _videoURL = [NSURL fileURLWithPath:videoPath];
        [self initPlayer];
        if (succ)
        {
            succ();
        }
    }
    else
    {
        __weak MicroVideoPlayView *ws = self;
        [elem.video getVideo:videoPath succ:^{
            ws.videoURL = [NSURL fileURLWithPath:videoPath];
            [ws initPlayer];
            if (succ)
            {
                succ();
            }
        } fail:^(int code, NSString *err) {
            [[HUDHelper sharedInstance] syncStopLoadingMessage:IMALocalizedError(code, err)];
            if (fail)
            {
                fail(code,err);
            }
        }];
    }
}

- (NSString *)getHostCachesPath
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *cachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,  NSUserDomainMask,YES);
    NSString *cachesPath =[cachesPaths objectAtIndex:0];
    NSString *hostCachesPath = [NSString stringWithFormat:@"%@/%@",cachesPath, [IMAPlatform sharedInstance].host.profile.identifier];

    if (![fileMgr fileExistsAtPath:hostCachesPath])
    {
        NSError *err = nil;

        if (![fileMgr createDirectoryAtPath:hostCachesPath withIntermediateDirectories:YES attributes:nil error:&err])
        {
            DebugLog(@"Create HostCachesPath fail: %@", err);
            return nil;
        }
    }
    return hostCachesPath;
}

- (void)initPlayer
{
    _playItem = [AVPlayerItem playerItemWithURL:_videoURL];
    _player   = [AVPlayer playerWithPlayerItem:_playItem];
    
    [_playerLayer setPlayer:_player];
}

- (void)onPlay:(UIButton *)button
{
    [self downloadVideo:^{
        
        [_player play];
        button.hidden = YES;
        
    } fail:nil];
}

-(void)onEndPlay:(NSNotification *)notification
{
    AVPlayerItem *item = (AVPlayerItem *)notification.object;
    if (_playItem == item)
    {
        _playerBtn.hidden = NO;
        [_player seekToTime:CMTimeMake(0, 1)];
    }
}

- (void)onScaling:(UITapGestureRecognizer *)tap
{
    if (tap.state != UIGestureRecognizerStateEnded)
    {
        return;
    }
    
    CGRect screen = [UIScreen mainScreen].bounds;
    MicroVideoFullScreenPlayView *fullScreen = [[MicroVideoFullScreenPlayView alloc] initWithFrame:screen];
    [fullScreen setMessage:_msg];
    
    UIView *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:fullScreen];
}

- (void)relayoutSubViews
{
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    
    _playerLayer.frame = self.bounds;
    
    _playerBtn.frame = CGRectMake(selfWidth/2 - 30, selfHeight/2 - 30, 60, 60);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _msg = nil;
    _videoURL = nil;
    _coverImage = nil;
    _playerBtn = nil;
    _playItem = nil;
    _player = nil;
    _playerLayer = nil;
}

@end

/////////////////////////////////////////////////////
@implementation MicroVideoFullScreenPlayView

- (void)onScaling:(UITapGestureRecognizer *)tap
{
    [self removeFromSuperview];
}

- (void)relayoutSubViews
{
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    
    CGRect screen = [UIScreen mainScreen].bounds;
    
    _playerLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    _playerBtn.frame = CGRectMake(selfWidth/2 - 30, selfHeight/2 - 30, 60, 60);
}

@end
