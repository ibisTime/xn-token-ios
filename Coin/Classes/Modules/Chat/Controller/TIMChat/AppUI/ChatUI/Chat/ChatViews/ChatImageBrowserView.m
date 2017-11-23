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

#import "ChatImageBrowserView.h"
#import "UIViewAdditions.h"

@interface ChatImageBrowserView() <UIScrollViewDelegate>

#define PROGRESS_VIEW_WIDTH 60.f
#define BUTTON_SIDE_MARGIN 20.f
#define PREVIEW_ANIMATION_DURATION 0.5f

//@property (nonatomic, copy) NSString* urlPath;
@property (nonatomic, strong) IMAMsg        *model;
@property (nonatomic, assign) CGRect        fromRect;
@property (nonatomic, assign) BOOL          isOriginPhotoLoaded;

@property (nonatomic, strong) UIImage       *thumbnail;
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIImageView   *imageView;
@property (nonatomic, strong) UIButton      *saveBtn;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation ChatImageBrowserView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithPicModel:(IMAMsg *)picModel thumbnail:(UIImage*)thumbnail fromRect:(CGRect)rect
{
    self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    if (self)
    {
        self.fromRect = rect;
        self.thumbnail = thumbnail;
        self.model = picModel;
        
        [self initAllViews];
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperviewAnimation)];
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImageView:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        // enable double tap
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        self.isOriginPhotoLoaded = NO;
        self.saveBtn.enabled = NO;
        [self showImageViewAnimation];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showImageViewAnimation
{
    self.imageView.frame = self.fromRect;
    if (self.thumbnail)
    {
        self.alpha = 0.f;
        
        // calculate scaled frame
        CGRect finalFrame = [self calculateScaledFinalFrame];
        if (finalFrame.size.height > self.height)
        {
            self.scrollView.contentSize = CGSizeMake(self.width, finalFrame.size.height);
        }
        
        self.imageView.image = self.thumbnail;
        
        // animation frame
        [UIView animateWithDuration:PREVIEW_ANIMATION_DURATION animations:^{
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            self.imageView.frame = finalFrame;
            self.alpha = 1.f;
        } completion:^(BOOL finished) {
            if (self.model)
            {
                TIMImageElem *elem = (TIMImageElem *)[self.model.msg getElem:0];
                if (elem && elem.imageList && elem.imageList.count)
                {
                    for (TIMImage* timImage in elem.imageList)
                    {
                        if (timImage.type == TIM_IMAGE_TYPE_ORIGIN)
                        {
                            if (!(timImage.uuid && timImage.uuid.length > 0))
                            {
                                [[HUDHelper sharedInstance] tipMessage:@"图片uuid为空"];
                                break;
                            }
                            [_activityIndicator startAnimating];
                            
                            NSFileManager *fileManager = [NSFileManager defaultManager];
                            NSString *nsTmpDir = NSTemporaryDirectory();
                            NSString *imagePath = [NSString stringWithFormat:@"%@/image_%@", nsTmpDir, timImage.uuid];
                            BOOL isDirectory;
                            
                            if ([fileManager fileExistsAtPath:imagePath isDirectory:&isDirectory]
                                && isDirectory == NO)
                            {
                                NSData *data = [fileManager contentsAtPath:imagePath];
                                if (data)
                                {
                                    self.imageView.image = [UIImage imageWithData:data];
                                    [_activityIndicator stopAnimating];
                                }
                            }
                            else
                            {
                                [timImage getImage:imagePath succ:^{
                                    NSData *data = [fileManager contentsAtPath:imagePath];
                                    if (data)
                                    {
                                        self.imageView.image = [UIImage imageWithData:data];
                                        [_activityIndicator stopAnimating];
                                    }
                                    else
                                    {
                                        //展示x图
                                        [[HUDHelper sharedInstance] tipMessage:@"下载的图片是空的"];
                                        [_activityIndicator stopAnimating];
                                    }
                                    
                                } fail:^(int code, NSString *err) {
                                    //展示x图
                                    [[HUDHelper sharedInstance] tipMessage:@"下载原图失败"];
                                    [_activityIndicator stopAnimating];
                                }];
                            }
                            break;
                        }
                    }
                }
                else
                {
                    //展示发送的图片
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    NSString *imagePath = elem.path;
                    BOOL isDirectory;
                    
                    if ([fileManager fileExistsAtPath:imagePath isDirectory:&isDirectory]
                        && isDirectory == NO)
                    {
                        NSData *data = [fileManager contentsAtPath:imagePath];
                        if (data)
                        {
                            self.imageView.image = [UIImage imageWithData:data];
                        }
                    }
                    
                }
            }
        }];
    }
    else
    {
        self.imageView.frame = self.bounds;
        self.alpha = 0.f;
        
        // animation frame
        [UIView animateWithDuration:PREVIEW_ANIMATION_DURATION animations:^{
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            self.alpha = 1.f;
        } completion:^(BOOL finished) {
            
            if (self.model)
            {
                //[self.imageView setPathToNetworkImage:self.urlPath contentMode:UIViewContentModeScaleAspectFit];
                self.imageView.image = nil;
            }
        }];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeFromSuperviewAnimation
{
    
    // consider scroll offset
    CGRect newFromRect = self.fromRect;
    newFromRect.origin = CGPointMake(self.fromRect.origin.x + self.scrollView.contentOffset.x,
                                     self.fromRect.origin.y + self.scrollView.contentOffset.y);
    [UIView animateWithDuration:PREVIEW_ANIMATION_DURATION animations:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        self.imageView.frame = newFromRect;
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)initAllViews
{
    self.backgroundColor = [UIColor blackColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.zoomScale = 1.0;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = 2.0f;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:_scrollView];
    
    _imageView = [[UIImageView alloc] initWithFrame:_scrollView.bounds];
    _imageView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_imageView];
    
    
    UIImage *backgroundImage = [UIImage imageNamed:@"preview_button.png"];
    UIImage *saveImage = [UIImage imageNamed:@"preview_save_icon.png"];
    _saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, backgroundImage.size.width, backgroundImage.size.height)];
    [_saveBtn setImage:saveImage forState:UIControlStateNormal];
    [_saveBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [_saveBtn addTarget:self action:@selector(savePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveBtn];
    
    //    self.progressIndicator.center = CGPointMake(self.size.width / 2, self.size.height / 2);
    self.saveBtn.left = BUTTON_SIDE_MARGIN;
    self.saveBtn.bottom = self.height - BUTTON_SIDE_MARGIN;
    
    
    _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicator.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [self.scrollView addSubview:_activityIndicator];
    _activityIndicator.hidesWhenStopped = YES;
    
}

- (void)scaleImageView:(UITapGestureRecognizer *)tapGesture
{
    CGPoint tapPoint = [tapGesture locationInView:self.scrollView];
    if (self.scrollView.zoomScale > 1.f)
    {
        [self.scrollView setZoomScale:1.f animated:YES];
    }
    else
    {
        [self zoomScrollView:self.scrollView toPoint:tapPoint withScale:2.f animated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)calculateScaledFinalFrame
{
    CGSize thumbSize = self.thumbnail.size;
    CGFloat finalHeight = self.width * (thumbSize.height / thumbSize.width);
    CGFloat top = 0.f;
    if (finalHeight < self.height)
    {
        top = (self.height - finalHeight) / 2.f;
    }
    return CGRectMake(0.f, top, self.width, finalHeight);
}


- (void)zoomScrollView:(UIScrollView*)view toPoint:(CGPoint)zoomPoint withScale: (CGFloat)scale animated: (BOOL)animated
{
    //Normalize current content size back to content scale of 1.0f
    CGSize contentSize = CGSizeZero;
    
    contentSize.width = (view.contentSize.width / view.zoomScale);
    contentSize.height = (view.contentSize.height / view.zoomScale);
    
    //translate the zoom point to relative to the content rect
    //jimneylee add compare contentsize with bounds's size
    if (view.contentSize.width < view.bounds.size.width)
    {
        zoomPoint.x = (zoomPoint.x / view.bounds.size.width) * contentSize.width;
    }
    else
    {
        zoomPoint.x = (zoomPoint.x / view.contentSize.width) * contentSize.width;
    }
    if (view.contentSize.height < view.bounds.size.height)
    {
        zoomPoint.y = (zoomPoint.y / view.bounds.size.height) * contentSize.height;
    }
    else
    {
        zoomPoint.y = (zoomPoint.y / view.contentSize.height) * contentSize.height;
    }
    
    //derive the size of the region to zoom to
    CGSize zoomSize = CGSizeZero;
    zoomSize.width = view.bounds.size.width / scale;
    zoomSize.height = view.bounds.size.height / scale;
    
    //offset the zoom rect so the actual zoom point is in the middle of the rectangle
    CGRect zoomRect = CGRectZero;
    zoomRect.origin.x = zoomPoint.x - zoomSize.width / 2.0f;
    zoomRect.origin.y = zoomPoint.y - zoomSize.height / 2.0f;
    zoomRect.size.width = zoomSize.width;
    zoomRect.size.height = zoomSize.height;
    
    //apply the resize
    [view zoomToRect: zoomRect animated: animated];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)savePhoto
{
    if (self.isOriginPhotoLoaded && self.imageView.image)
    {
        self.saveBtn.enabled = NO;
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self,
                                       @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    else
    {
        [[HUDHelper sharedInstance] tipMessage:@"图片未下载完成，无法保存"];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
-(void) image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error)
    {
        [[HUDHelper sharedInstance] tipMessage:@"保存失败"];
    }
    else
    {
        
        [[HUDHelper sharedInstance] tipMessage:@"保存成功"];
        self.saveBtn.enabled = YES;
    }
}


#pragma mark - UIScrolViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}


-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5f : 0.f;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5f : 0.f;
    
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5f + offsetX, scrollView.contentSize.height * 0.5f + offsetY);
}

@end
