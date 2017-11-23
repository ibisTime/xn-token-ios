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

#import "MyEmojView.h"
#import "EmojHelper.h"
#import "MyEmojBoardView.h"
#import "MyUIDefine.h"

@interface MyEmojView()
{
    CGFloat _boardWidth;        //表情键盘的宽度
}

@property (nonatomic, strong)UIPageControl* emojPageControll;
@property (nonatomic, strong)UIScrollView* emojScrollView;
- (NSInteger)pageCount;
- (void)pageChange;

@end

@implementation MyEmojView

- (instancetype)initWithFrame:(CGRect)frame
{
    _boardWidth = frame.size.width;
    if (self = [super initWithFrame:frame])
    {
        self.emojScrollView.frame = self.bounds;
        _emojScrollView.contentSize = CGSizeMake([self pageCount]*self.emojScrollView.frame .size.width, self.bounds.size.height);
        //初始化两屏 （根据需要初始化，不用全部载入，提升性能）
        for (int i=0; i<2; i++)
        {
            MyEmojBoardView* boardView = [MyEmojBoardView viewWithPage:i frame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, CHAT_EMOJ_VIEW_H-CHAT_EMOJ_VIEW_PAGE_CNTL_H)];
            [self.emojScrollView addSubview:boardView];
        }
        
        self.emojPageControll.frame = CGRectMake(0, CGRectGetHeight(self.frame)-CHAT_EMOJ_VIEW_PAGE_CNTL_H, CGRectGetWidth(self.frame), CHAT_EMOJ_VIEW_PAGE_CNTL_H);
    }
    
    return self;
}
- (void)relayoutFrameOfSubViews
{
    self.emojScrollView.frame = self.bounds;
    _emojScrollView.contentSize = CGSizeMake([self pageCount]*self.emojScrollView.frame .size.width, self.bounds.size.height);
    //初始化两屏 （根据需要初始化，不用全部载入，提升性能）
    
    NSInteger i = 0;
    for (UIView *view in self.emojScrollView.subviews)
    {
        if ([view isKindOfClass:[MyEmojBoardView class]])
        {
            MyEmojBoardView *boardView = (MyEmojBoardView *)view;
            boardView.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, CHAT_EMOJ_VIEW_H-CHAT_EMOJ_VIEW_PAGE_CNTL_H);
            i++;
        }
    }
    
    self.emojPageControll.frame = CGRectMake(0, CGRectGetHeight(self.frame)-CHAT_EMOJ_VIEW_PAGE_CNTL_H, CGRectGetWidth(self.frame), CHAT_EMOJ_VIEW_PAGE_CNTL_H);
}

- (void)setDelegate:(id<MyEmojBoardDelegate>)delegate
{
    _delegate = delegate;
    for (UIView *view in self.emojScrollView.subviews)
    {
        if ([view isKindOfClass:[MyEmojBoardView class]])
        {
            MyEmojBoardView *boardView = (MyEmojBoardView *)view;
            boardView.delegate = _delegate;
        }
    }
}

- (UIPageControl *)emojPageControll
{
    if (!_emojPageControll)
    {
        _emojPageControll = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _emojPageControll.numberOfPages = [self pageCount];
        _emojPageControll.currentPage = 0;
        _emojPageControll.pageIndicatorTintColor = RGBACOLOR(0xAA, 0xAA, 0xAA, 1);
        _emojPageControll.currentPageIndicatorTintColor = RGBACOLOR(0x77, 0x77, 0x77, 1);;
        _emojPageControll.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [_emojPageControll addTarget:self action:@selector(pageChange) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_emojPageControll];
        
    }
    return  _emojPageControll;
}

- (UIScrollView*)emojScrollView
{
    if (!_emojScrollView)
    {
        _emojScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _emojScrollView.pagingEnabled = YES;
        _emojScrollView.delegate = self;
        _emojScrollView.showsHorizontalScrollIndicator = NO;
        _emojScrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_emojScrollView];
    }
    return _emojScrollView;
}



-(NSInteger)pageCount
{
    return ceilf([EmojHelper emojCount]*1.0/(CHAT_EMOJ_COL*CHAT_EMOJ_ROW-1));
}


- (void)pageChange
{
    NSInteger page = self.emojPageControll.currentPage;
    CGRect frame = self.emojScrollView.frame;
    frame.origin.x = _boardWidth * page;
    frame.origin.y = 0;
    [self.emojScrollView scrollRectToVisible:frame animated:YES];
}

#pragma mark- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.emojScrollView.frame.size.width;
    int page = floor((self.emojScrollView.contentOffset.x + pageWidth / 2) / pageWidth);
    
    if ( page == self.emojPageControll.currentPage)
    {
        return;
    }
    
    self.emojPageControll.currentPage = page;
    
    //左边的表情键盘view
    if (page - 1 >= 0 && [self.emojScrollView viewWithTag:[MyEmojBoardView viewTagWithPage:page-1]] == nil)
    {
        MyEmojBoardView* boardView = [MyEmojBoardView viewWithPage:page-1 frame:CGRectMake((page-1)*SCREEN_WIDTH, 0, SCREEN_WIDTH, CHAT_EMOJ_VIEW_H-CHAT_EMOJ_VIEW_PAGE_CNTL_H)];
        boardView.delegate = self.delegate; 
        [self.emojScrollView addSubview:boardView];
    }
    
    //右边的表情键盘view
    if (page + 1 < self.emojPageControll.numberOfPages && [self.emojScrollView viewWithTag:[MyEmojBoardView viewTagWithPage:page+1]] == nil)
    {
        MyEmojBoardView* boardView = [MyEmojBoardView viewWithPage:page+1 frame:CGRectMake((page+1)*SCREEN_WIDTH, 0, SCREEN_WIDTH, CHAT_EMOJ_VIEW_H-CHAT_EMOJ_VIEW_PAGE_CNTL_H)];
        boardView.delegate = self.delegate;
        [self.emojScrollView addSubview:boardView];
    }
    
    //移除剩余的view
    for (int i = 0; i < self.emojPageControll.numberOfPages; ++i)
    {
        if (i != page - 1 && i != page && i != page + 1)
        {
            UIView* subView = [self.emojScrollView viewWithTag:[MyEmojBoardView viewTagWithPage:i]];
            [subView removeFromSuperview];
        }
    }
}

@end
