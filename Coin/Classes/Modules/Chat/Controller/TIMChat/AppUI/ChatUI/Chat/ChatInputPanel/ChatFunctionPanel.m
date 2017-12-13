//
//  ChatFunctionPanel.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/21.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ChatFunctionPanel.h"
#import "LangSwitcher.h"
@implementation ChatFunctionPanel

- (instancetype)init
{
    if (self = [super init])
    {
        _contentHeight = 105;
    }
    return self;
}
- (void)addOwnViews
{
    _image = [[ImageTitleButton alloc] initWithStyle:EImageTopTitleBottom];
    _image.imageSize = CGSizeMake(60, 60);
    _image.margin = UIEdgeInsetsMake(10, 0, 0, 10);
    _image.titleLabel.textAlignment = NSTextAlignmentCenter;
    _image.titleLabel.font = kAppMiddleTextFont;
    [_image setTitleColor:kGrayColor forState:UIControlStateNormal];
    [_image setTitle:[LangSwitcher switchLang:@"图片" key:nil] forState:UIControlStateNormal];
    [_image setImage:[UIImage imageNamed:@"input_image"] forState:UIControlStateNormal];
    [_image addTarget:self action:@selector(onClickImage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_image];
    
    _photo = [[ImageTitleButton alloc] initWithStyle:EImageTopTitleBottom];
    _photo.imageSize = CGSizeMake(60, 60);
    _photo.margin = UIEdgeInsetsMake(10, 0, 0, 10);
    _photo.titleLabel.textAlignment = NSTextAlignmentCenter;
    _photo.titleLabel.font = kAppMiddleTextFont;
    [_photo setTitleColor:kGrayColor forState:UIControlStateNormal];
    [_photo setTitle:[LangSwitcher switchLang:@"拍摄" key:nil] forState:UIControlStateNormal];
    
    [_photo setImage:[UIImage imageNamed:@"input_photo"] forState:UIControlStateNormal];
    [_photo addTarget:self action:@selector(onClickPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_photo];
    
    _file = [[ImageTitleButton alloc] initWithStyle:EImageTopTitleBottom];
    _file.imageSize = CGSizeMake(60, 60);
    _file.margin = UIEdgeInsetsMake(10, 0, 0, 10);
    _file.titleLabel.textAlignment = NSTextAlignmentCenter;
    _file.titleLabel.font = kAppMiddleTextFont;
    [_file setTitleColor:kGrayColor forState:UIControlStateNormal];
    [_file setTitle:@"文件" forState:UIControlStateNormal];
    
    [_file setImage:[UIImage imageNamed:@"input_file"] forState:UIControlStateNormal];
    [_file addTarget:self action:@selector(onClickFile:) forControlEvents:UIControlEventTouchUpInside];
    
    _file.hidden = YES;

    [self addSubview:_file];

    _video = [[ImageTitleButton alloc] initWithStyle:EImageTopTitleBottom];
    _video.imageSize = CGSizeMake(60, 60);
    _video.margin = UIEdgeInsetsMake(10, 0, 0, 10);
    _video.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_video setTitleColor:kGrayColor forState:UIControlStateNormal];
    _video.titleLabel.font = kAppMiddleTextFont;
    [_video setTitle:@"小视频" forState:UIControlStateNormal];
    [_video setImage:[UIImage imageNamed:@"input_video"] forState:UIControlStateNormal];
    [_video addTarget:self action:@selector(onClickVideo:) forControlEvents:UIControlEventTouchUpInside];
    _video.hidden = YES;
    
    [self addSubview:_video];
}

- (void)onClickImage:(UIButton *)btn
{
    if ([_chatDelegate respondsToSelector:@selector(onChatInputSendImage:)])
    {
        [_chatDelegate onChatInputSendImage:self];
    }
}

- (void)onClickPhoto:(UIButton *)btn
{
    if ([_chatDelegate respondsToSelector:@selector(onChatInputTakePhoto:)])
    {
        [_chatDelegate onChatInputTakePhoto:self];
    }
}

- (void)onClickFile:(UIButton *)btn
{
    if ([_chatDelegate respondsToSelector:@selector(onChatInputSendFile:)])
    {
        [_chatDelegate onChatInputSendFile:self];
    }
}

- (void)onClickVideo:(UIButton *)btn
{
    if ([_chatDelegate respondsToSelector:@selector(onChatInputRecordVideo:)])
    {
        [_chatDelegate onChatInputRecordVideo:self];
    }
}

- (void)relayoutFrameOfSubViews
{
    [self alignSubviews:@[_image, _photo, _video, _file] horizontallyWithPadding:0 margin:0 inRect:self.bounds];
}


@end
