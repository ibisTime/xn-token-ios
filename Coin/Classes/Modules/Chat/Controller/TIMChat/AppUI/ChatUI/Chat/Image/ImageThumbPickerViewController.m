//
//  PopImageViewController.m
//  MyDemo
//
//  Created by wilderliao on 15/8/21.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageThumbPickerViewController.h"


@implementation ImageThumbPickerViewController

- (instancetype)initWith:(UIImage *)image
{
    if (self = [super init])
    {
        _showImage = image;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _imageView = [[UIImageView alloc] initWithImage:_showImage];
    _imageView.frame = self.view.bounds;
    _imageView.userInteractionEnabled  = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_imageView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapGestureRecognizer)];
    [_imageView addGestureRecognizer:tapGesture];
    
    [self setupBottomToorBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma initViewController




- (void)setupBottomToorBar
{
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    toolBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:toolBar];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(toolBar);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[toolBar]-0-|" options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[toolBar(44)]-0-|" options:0 metrics:0 views:views]];
    
    UIButton *orignal = [self createOriPicRadioBtn];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:orignal];
    
    UIButton *send = [self createSendBtn];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:send];
    
    toolBar.items = @[leftItem, rightItem];
}

- (UIButton *)createOriPicRadioBtn
{
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width-100, 20)];
    
    UIButton *oriPicRadioBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    oriPicRadioBtn.frame = CGRectMake(0, 0, 20, 20);
    CALayer * layer = [oriPicRadioBtn layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:10.0];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[[UIColor grayColor] CGColor]];
    [oriPicRadioBtn setImage:[UIImage imageNamed:@"chat_group_selected"] forState:UIControlStateSelected];
    [oriPicRadioBtn addTarget:self action:@selector(onClickOrignal:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(25, 0, 150, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.text = [self calImageSize];
    
    [container addSubview:oriPicRadioBtn];
    [container addSubview:label];
    
    [self.view addSubview:container];
    return (UIButton*)container;
}

- (NSString *)calImageSize
{
    NSData *imageData = UIImageJPEGRepresentation(_showImage, 1);
    
    CGFloat length = [imageData length];
    int loopNum = 0;//图片单位 0->B,1->KB,2->MB,3->GB
    while(TRUE)
    {
        if (length >= 1024)
        {
            length /= 1024.0;
        }
        else
        {
            break;
        }
        loopNum++;
    }
    NSString *imageUnit;
    switch (loopNum)
    {
        case 0:
            imageUnit = @"B";
            break;
        case 1:
            imageUnit = @"KB";
            break;
        case 2:
            imageUnit = @"MB";
            break;
        case 3:
            imageUnit = @"GB";
            break;
        default:
            imageUnit = @"";
            break;
    }
    
    NSString *strSize = [[NSString alloc] initWithFormat:@"原图(%.2f%@)", length, imageUnit];
    return strSize;
}

- (UIButton *)createSendBtn
{
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setBackgroundColor:[UIColor flatWhiteColor]];
    sendBtn.enabled = YES;
    sendBtn.titleLabel.font = kAppMiddleTextFont;
    sendBtn.frame = CGRectMake(0, 0, 60, 30);
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(onSendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return sendBtn;
}

#pragma mark - click事件响应
- (void)didTapGestureRecognizer
{
//    if (nil != self.navigationController && 1 < [self.navigationController.viewControllers count])
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    else
//    {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onClickOrignal:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    _bIsSendOriPic = button.selected;
}

- (void)onSendBtnClick:(id)sender
{
//        [self.delegate sendImageAction:_showImage isSendOriPic:bIsSendOriPic];
//        [self.navigationController popViewControllerAnimated:NO];
//        [self.delegate releasePicker];
    
    if (_sendImageBlock)
    {
        _sendImageBlock(self, _bIsSendOriPic);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
