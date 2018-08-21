//
//  SelectScrollView.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/24.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "SelectScrollView.h"

#import "UIView+Responder.h"
#import "UIScrollView+TLAdd.h"



#import "TLUIHeader.h"
#import "AppColorMacro.h"

#define kHeadBarHeight 45

@interface SelectScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *itemTitles;



@property (nonatomic, strong) NSMutableArray *btnArray;

@property (nonatomic, assign) CGFloat leftLength;

@end

@implementation SelectScrollView

- (instancetype)initWithFrame:(CGRect)frame itemTitles:(NSArray *)itemTitles {
    
    if (self = [super initWithFrame:frame]) {
        
        _itemTitles = itemTitles;
        
        _btnArray = [NSMutableArray array];
        
        [self initTopView];
        
        [self initScrollView];
        
    }
    
    return self;
}


#pragma mark - Init

- (void)initTopView {
    
    CoinWeakSelf;
    
    _headView = [[SortBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeadBarHeight) sortNames:_itemTitles sortBlock:^(NSInteger index) {
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(kScreenWidth*index, 0, kScreenWidth, weakSelf.scrollView.height) animated:YES];
        
        if (weakSelf.selectBlock) {
            weakSelf.selectBlock(index);
        }
        
    }];
    
    [self addSubview:_headView];
    
}

- (void)initScrollView {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kHeadBarHeight, kScreenWidth, kSuperViewHeight - kHeadBarHeight)];
    _scrollView.contentSize = CGSizeMake(kScreenWidth * _itemTitles.count, kSuperViewHeight - kHeadBarHeight);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.scrollEnabled = NO;
    
    [_scrollView adjustsContentInsets];
    
    [self insertSubview:_scrollView belowSubview:_headView];
    
    _scrollView.contentOffset = CGPointMake(0, 0);
    
    [self addSubview:_scrollView];
}

#pragma mark - Setting

- (void)setCurrentIndex:(NSInteger)currentIndex {
    
    _currentIndex = currentIndex;
    
    _headView.curruntIndex = _currentIndex;

}

@end
