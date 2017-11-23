//
//  ChatTextTableViewCell.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/10.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ChatTableViewCell.h"


//==============================================================
@implementation ChatTextTableViewCell

// 只创建，外部统一添加
- (UIView *)addElemContent
{
    _chatText = [[UILabel alloc] init];
    _chatText.textAlignment = NSTextAlignmentLeft;
    _chatText.numberOfLines = 0;
    _chatText.lineBreakMode = NSLineBreakByWordWrapping;
    _chatText.userInteractionEnabled = YES;
    return _chatText;
}

- (void)configContent
{
    [super configContent];
    
    _chatText.font = [_msg textFont];
    _chatText.textColor = [_msg textColor];
    
    TIMTextElem *elem = (TIMTextElem *)[_msg.msg getElem:0];
    _chatText.text = [elem text];
    
}

@end
//==============================================================
@implementation ChatImageTableViewCell

// 只创建，外部统一添加
- (UIView *)addElemContent
{
    _chatImage = [[UIImageView alloc] init];
    _chatImage.backgroundColor = [UIColor flatGrayColor];
    _chatImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImage:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_chatImage addGestureRecognizer:tap];
    
    
    return _chatImage;
}

- (void)onTapImage:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        
        UIView *keyWindow = [UIApplication sharedApplication].keyWindow;
        CGRect rect = [_chatImage relativePositionTo:keyWindow];
        ChatImageBrowserView *view = [[ChatImageBrowserView alloc] initWithPicModel:_msg thumbnail:_chatImage.image fromRect:rect];
        [keyWindow addSubview:view];
    }
    
}

- (void)configContent
{
    [super configContent];
    
    TIMImageElem *elem = (TIMImageElem *)[_msg.msg getElem:0];
    
    __weak UIImageView *wci = _chatImage;
    [elem asyncThumbImage:^(NSString *path, UIImage *image, BOOL succ, BOOL isAsync) {
        wci.image = image ? image : [UIImage imageNamed:@"default_image"];
    } inMsg:_msg];
    
}

- (NSArray *)showMenuItems
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[super showMenuItems]];
    
    if (_msg.status != EIMAMsg_SendFail && ![_msg isMineMsg])
    {
        UIMenuItem *saveItem = [[UIMenuItem alloc] initWithTitle:@"保存" action:@selector(saveImage:)];
        [array addObject:saveItem];
    }
    return array;
}

- (void)saveImage:(UIMenuItem *)item
{
    UIImageWriteToSavedPhotosAlbum(_chatImage.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error)
    {
        [[HUDHelper sharedInstance] tipMessage:@"已保存到相册"];
    }
    else
    {
        [[HUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:@"保存失败 %@",error]];
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    BOOL can = [super canPerformAction:action withSender:sender] || action == @selector(saveImage:);
    return can;
}

@end

//==============================================================
@implementation ChatSoundTableViewCell

- (void)dealloc
{
    
}

// 只创建，外部统一添加
- (UIView *)addElemContent
{
    _soundButton = [[ImageTitleButton alloc] init];
    _soundButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_soundButton addTarget:self action:@selector(onPlaySound) forControlEvents:UIControlEventTouchUpInside];
    _soundButton.userInteractionEnabled = YES;
    return _soundButton;
}

- (void)configSendingTips
{
    [super configSendingTips];
    if (_msg.status == EIMAMsg_WillSending)
    {
        _elemContentRef.hidden = YES;
        [_contentBack startGlowing];
    }
    else
    {
        _elemContentRef.hidden = NO;
        [_contentBack stopGlowing];
    }
    
}

- (void)configContent
{
    [super configContent];
    
    [self stopPlaySound];
    
    // 停止上一次的播放
    [_soundButton.imageView stopAnimating];
    
    BOOL isMine = [_msg isMineMsg];
    _soundButton.style = isMine ? ETitleLeftImageRight : EImageLeftTitleRight;
    [_soundButton setImage:isMine ? [UIImage imageNamed:@"my_voice3"] : [UIImage imageNamed:@"other_voice3"] forState:UIControlStateNormal];
    [_soundButton setTitleColor:[_msg textColor] forState:UIControlStateNormal];
    
    TIMSoundElem *elem = (TIMSoundElem *)[_msg.msg getElem:0];
    [_soundButton setTitle:[NSString stringWithFormat:@"%d''", elem.second] forState:UIControlStateNormal];
    
}

- (void)startPlaySoundAnimating
{
     BOOL isMine = [_msg isMineMsg];
    if (isMine)
    {
        _soundButton.imageView.animationImages = @[[UIImage imageNamed:@"my_voice1"], [UIImage imageNamed:@"my_voice2"], [UIImage imageNamed:@"my_voice3"]];
    }
    else
    {
        _soundButton.imageView.animationImages = @[[UIImage imageNamed:@"other_voice1"], [UIImage imageNamed:@"other_voice2"], [UIImage imageNamed:@"other_voice3"]];
    }

    _soundButton.imageView.animationDuration = 0.5;
    _soundButton.imageView.animationRepeatCount = 0;
    [_soundButton.imageView startAnimating];
}

- (void)stopPlaySoundAnimating
{
    [_soundButton.imageView stopAnimating];
    _soundButton.imageView.animationImages = nil;
}

- (void)startPlaySound
{
    [self startPlaySoundAnimating];
    TIMSoundElem *elem = (TIMSoundElem *)[_msg.msg getElem:0];
    __weak ChatSoundTableViewCell *ws = self;
    
    NSString *cache = [PathUtility getCachePath];
    NSString *loginId = [[TIMManager sharedInstance] getLoginUser];
    NSString *audioDir = [NSString stringWithFormat:@"%@/%@",cache,loginId];
    BOOL isDir = FALSE;
    BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:audioDir isDirectory:&isDir];
    if (!(isDir && isDirExist))
    {
        BOOL isCreateDir = [PathUtility createDirectoryAtCache:loginId];
        if (!isCreateDir) {
            return;
        }
    }
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@",cache,loginId,elem.uuid];
    if ([PathUtility isExistFile:path])
    {
        NSURL *url = [NSURL fileURLWithPath:path];
        [[ChatSoundPlayer sharedInstance] playWithUrl:url finish:^{
            [ws stopPlaySoundAnimating];
        }];
    }
    else
    {
        [elem getSound:path succ:^{
            NSURL *url = [NSURL fileURLWithPath:path];
            [[ChatSoundPlayer sharedInstance] playWithUrl:url finish:^{
                [ws stopPlaySoundAnimating];
            }];
        } fail:^(int code, NSString *msg) {
            NSLog(@"path--->%@",path);
            [[HUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:@"播放语音失败:%@，path=%@", IMALocalizedError(code, msg),path]];
        }];
    }
}

- (void)stopPlaySound
{
    [self stopPlaySoundAnimating];
    [[ChatSoundPlayer sharedInstance] stopPlay];
}

- (void)onPlaySound
{
    if (!_soundButton.imageView.isAnimating)
    {
        [self startPlaySound];
    }
    else
    {
        // 正在播放，再次点击，则停止播放
        [self stopPlaySound];
    }
}

@end

//==============================================================
@implementation ChatFileTableViewCell

// 只创建，外部统一添加
- (UIView *)addElemContent
{
    _filePanel = [[UIView alloc] init];
    
    _fileIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_image"]];
    [_fileIcon setFrame:CGRectMake(kDefaultMargin/2, kDefaultMargin/2, 60, 60)];
    [_filePanel addSubview:_fileIcon];
    
    _fileName = [[UILabel alloc] initWithFrame:CGRectMake(_fileIcon.bounds.size.width+kDefaultMargin, kDefaultMargin/2, 120, _fileIcon.bounds.size.height * 2/3)];
    _fileName.numberOfLines = 0;
    _fileName.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _fileName.font = kAppSmallTextFont;
    [_filePanel addSubview:_fileName];
    
    _fileSize = [[UILabel alloc] initWithFrame:CGRectMake(_fileIcon.bounds.size.width+kDefaultMargin, _fileName.origin.y+_fileName.size.height, 100, _fileIcon.bounds.size.height * 1/3)];
    _fileSize.font = kAppSmallTextFont;
    [_filePanel addSubview:_fileSize];
    
    return _filePanel;
}

- (void)configContent
{
    [super configContent];
    
    TIMFileElem *elem = (TIMFileElem *)[_msg.msg getElem:0];
    NSString *fileSize = [self calculSize:elem.fileSize];
    NSString *fileName = [elem.filename lastPathComponent];
    _fileName.text = fileName;
    _fileSize.text = fileSize;
    
}

//计算文件大小
- (NSString *)calculSize:(NSInteger)size
{
    int loopCount = 0;
    int mod=0;
    while (size >=1024)
    {
        mod = size%1024;
        size /= 1024;
        loopCount++;
        if (loopCount > 4)
        {
            break;
        }
    }
    
    CGFloat rate=1;
    int loop = loopCount;
    while (loop--)
    {
        rate *= 1000.0;
    }
    CGFloat fSize = size + (CGFloat)mod/rate;
    NSString *sizeUnit;
    switch (loopCount)
    {
        case 0:
            sizeUnit = [[NSString alloc] initWithFormat:@"%.0fB",fSize];
            break;
        case 1:
            sizeUnit = [[NSString alloc] initWithFormat:@"%0.1fKB",fSize];
            break;
        case 2:
            sizeUnit = [[NSString alloc] initWithFormat:@"%0.2fMB",fSize];
            break;
        case 3:
            sizeUnit = [[NSString alloc] initWithFormat:@"%0.3fGB",fSize];
            break;
        case 4:
            sizeUnit = [[NSString alloc] initWithFormat:@"%0.4fTB",fSize];
            break;
        default:
            break;
    }
    return sizeUnit;
}

- (NSArray *)showMenuItems
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[super showMenuItems]];
    
    if (_msg.status != EIMAMsg_SendFail && ![_msg isMineMsg])
    {
        UIMenuItem *downloadItem = [[UIMenuItem alloc] initWithTitle:@"下载" action:@selector(downloadItem:)];
        [array addObject:downloadItem];
    }
    return array;
}

- (void)downloadItem:(id)sender
{
    DebugLog(@"downloadItem");
    
    TIMFileElem *elem = (TIMFileElem *)[_msg.msg getElem:0];
    
    if (!(elem.uuid && elem.uuid.length > 0))
    {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:@"文件uuid为空"];
        return;
    }
    
    NSString *cachesPaths =[PathUtility getCachePath];
    NSString *fileName=[cachesPaths stringByAppendingPathComponent:[elem.filename lastPathComponent]];

    [[HUDHelper sharedInstance] syncLoading:@"正在下载"];

    [elem getFile:fileName succ:^{
        [[HUDHelper sharedInstance] syncStopLoading];
        
//        [data writeToFile:fileName atomically:YES];
        
        DebugLog(@"save path = %@", cachesPaths);
        NSString *msg = [[NSString alloc] initWithFormat:@"下载成功，文件已保存到%@",cachesPaths];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    } fail:^(int code, NSString *msg) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:IMALocalizedError(code, msg)];
    }];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    BOOL can = [super canPerformAction:action withSender:sender] || action == @selector(downloadItem:);
    return can;
}
@end
//==============================================================

@implementation ChatVideoTableViewCell

- (UIView *)addElemContent
{
    _videoPanel = [[MicroVideoPlayView alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
    return _videoPanel;
}

- (void)configContent
{
    [super configContent];
    
    [_videoPanel setMessage:_msg];
}

@end

//==============================================================
