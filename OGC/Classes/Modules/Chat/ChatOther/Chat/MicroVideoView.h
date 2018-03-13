//
//  MicroVideoView.h
//  MicroVideo
//
//  Created by wilderliao on 16/5/16.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MicroVideoDelegate <NSObject>

- (void)touchUpDone:(NSString *)savePath;

@end

@interface MicroVideoView : UIImageView
{
    UIButton        *_recordBtn;
    UIButton        *_cancelBtn;
    UIView          *_upSlidePanel;
    UIImageView     *_upSlidePic;
    UILabel         *_upSlideText;
    UIImageView     *_touchUpCancel;
    UIView          *_progressView;
    UIImageView     *_focusView;
    
    NSTimer         *_timer;
    __weak id<MicroVideoDelegate> _delegate;
}

@property (nonatomic, weak) id<MicroVideoDelegate> delegate;

@property (nonatomic, strong) NSTimer *timer;
@end
