//
//  ChatSystemFacePageView.m
//  TIMChat
//
//  Created by AlexiChen on 16/5/9.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ChatSystemFacePageView.h"


@implementation ChatSystemFacePageView

- (void)onClickFace:(UIButton *)btn
{
    //    NSInteger idx = btn.tag - 1;
    ChatSystemFaceItem *item = [[ChatSystemFaceHelper sharedHelper].systemFaces objectAtIndex:btn.tag ];
    if (item)
    {
        [_inputDelegate onInputSystemFace:item];
    }
}

- (void)onClickDelte:(UIButton *)btn
{
    [_inputDelegate onDelete];
}

- (void)addOwnViews
{
    for (NSInteger i = 0; i < 20; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(onClickFace:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn.showsTouchWhenHighlighted = YES;
        //        btn.backgroundColor = kRandomFlatColor;
    }
    
    UIButton *del = [UIButton buttonWithType:UIButtonTypeSystem];
    [del setImage:[UIImage imageNamed:@"face_delete"] forState:UIControlStateNormal];
    [del setImage:[UIImage imageNamed:@"face_delete_pressed"] forState:UIControlStateHighlighted];
    [del addTarget:self action:@selector(onClickDelte:) forControlEvents:UIControlEventTouchUpInside];
    del.showsTouchWhenHighlighted = YES;
    [self addSubview:del];
}

- (void)configStart:(NSInteger)index
{
    if (_hasConfiged)
    {
        return;
    }
    NSArray *faces = [ChatSystemFaceHelper sharedHelper].systemFaces;
    
    if (index < 0 || index >= faces.count)
    {
        DebugLog(@"参数错误");
        return;
    }
    NSInteger i = 0;
    while (i < 20)
    {
        UIButton *btn = self.subviews[i];
        if (index + i < faces.count)
        {
            btn.hidden = NO;
            ChatSystemFaceItem *item = faces[index + i];
            btn.tag = item.emojiIndex;
            
            [btn setImage:[item inputGif] forState:UIControlStateNormal];
        }
        else
        {
            btn.hidden = YES;
        }
        
        i++;
    }
    
    _hasConfiged = YES;
}

- (void)relayoutFrameOfSubViews
{
    CGSize faceSize = CGSizeMake(32, 32);
    CGSize margin = CGSizeMake(kDefaultMargin, kDefaultMargin);
    
    CGRect rect = self.bounds;
    NSInteger hp = (rect.size.width - faceSize.width * 7 - margin.width * (7 - 1))/2;
    NSInteger vp = (rect.size.height - faceSize.height * 3 - margin.height * (3 - 1))/2;
    
    CGRect faceRect = CGRectInset(rect, hp, vp);
    [self gridViews:self.subviews inColumn:7 size:faceSize margin:margin inRect:faceRect];
}


@end


@implementation ChatSystemFaceView

- (instancetype)init
{
    if (self = [super init])
    {
        _contentHeight = 215;
    }
    return self;
}

- (void)addOwnViews
{
    [super addOwnViews];
    
    _pageControl.hidden = NO;
    _pageControl.pageIndicatorTintColor = [UIColor flatGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor flatOrangeColor];
    
    NSInteger count = [ChatSystemFaceHelper sharedHelper].systemFaces.count;
    NSInteger pages = count % 20 ? count / 20 + 1 :  count / 20;
    
    NSMutableArray *pageViews = [NSMutableArray array];
    for (NSInteger i = 0; i < pages; i++)
    {
        ChatSystemFacePageView *page = [[ChatSystemFacePageView alloc] init];
        [pageViews addObject:page];
        
    }
    
    [self setFrameAndLayout:CGRectMake(0, 0, kMainScreenWidth, 215) withPages:pageViews];
}

- (void)setInputDelegate:(id<ChatSystemFaceInputDelegate>)inputDelegate
{
    for (ChatSystemFacePageView *view in _pages)
    {
        view.inputDelegate = inputDelegate;
    }
}

- (void)loadPage:(NSInteger)page feedBack:(BOOL)need
{
    [super loadPage:page feedBack:need];
    
    if (page >= 0 && page < _pages.count)
    {
        ChatSystemFacePageView *pageView = (ChatSystemFacePageView *)_pages[page];
        [pageView configStart:page * 20];
    }
    
}
- (void)relayoutFrameOfSubViews
{
    [_pageControl sizeWith:CGSizeMake(self.bounds.size.width, 30)];
    [_pageControl layoutParentHorizontalCenter];
    [_pageControl alignParentBottom];
    
    _scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 30);
}


@end

