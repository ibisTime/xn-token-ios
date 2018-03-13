//
//  ImageThumbPickerViewController.h
//  MyDemo
//
//  Created by wilderliao on 15/8/24.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ImageThumbPickerViewController : UIViewController
{
@protected
    UIImage         *_showImage;
    UIImageView     *_imageView;
    BOOL            _bIsSendOriPic;
}
@property (nonatomic, readonly) UIImage *showImage;
@property (nonatomic, copy) CommonCompletionBlock sendImageBlock;

- (instancetype)initWith:(UIImage *)image;
@end