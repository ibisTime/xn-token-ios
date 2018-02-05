//
//  TLSwitchView.m
//  Coin
//
//  Created by  tianlei on 2018/2/05.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TLSwitchView.h"
#import <CDCommon/UIView+Frame.h>

#define HAS_YES @"1"

#define HAS_NO @"0"

@interface TLSwitchView()<UIScrollViewDelegate>

/**
 上面类型
 */
@property (nonatomic, strong) UIScrollView *typeSwitchView;

/**
 下部内容切换
 */
@property (nonatomic, strong) UIScrollView *contentSwitchView;

@property (nonatomic, strong) NSMutableArray <NSString *> *hasAdd;

@end

@implementation TLSwitchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat topHeight = 50;
        
        //
        self.typeSwitchView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, topHeight)];
        [self addSubview:self.typeSwitchView];
        self.typeSwitchView.backgroundColor = [UIColor redColor];
        
        //
        self.contentSwitchView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.typeSwitchView.yy, frame.size.width, frame.size.height - topHeight )];
        [self addSubview:self.contentSwitchView];
        self.contentSwitchView.delegate = self;
        self.contentSwitchView.pagingEnabled = YES;
        
        
    }
    
    return self;
}

- (void)setCount:(NSInteger)count {
    
    _count = count;
    
    self.contentSwitchView.contentSize = CGSizeMake(_count * self.contentSwitchView.width, self.contentSwitchView.height);
    
    self.hasAdd = [[NSMutableArray alloc] initWithCapacity:_count];
    
    for (int i = 0 ; i < _count; i ++) {
        
        [self.hasAdd addObject:HAS_NO];
        
    }
}


// 不管是上部移动，还是下部移动，最后都会归集到这个事件上
// 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if ([scrollView isEqual:self.contentSwitchView]) {
        
        //滑动到了哪个
        NSInteger index = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
        
        //用于判断了是否添加了某个VC
        //可以用个数组保存是否添加过了
        
        BOOL already = [self.hasAdd[index] isEqualToString:HAS_YES];
        
        UIView *view = [self.delegate currentIndex:index alreadyAdd:already];
        if (!view) {
            return;
        }
        
        view.frame = CGRectMake(index*scrollView.width, 0, scrollView.width, scrollView.height);
        [self.contentSwitchView addSubview:view];
        self.hasAdd[index] = HAS_YES;
        
    }
    
}

//#pragma mark- 操作上面
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    //    //拖动结束
//    if ([scrollView isEqual:self.smallChooseScrollView]) {
//
//        //取出离中点最近的一个按钮
//
//    } else {
//
//        NSInteger index = (targetContentOffset -> x)/SCREEN_WIDTH;
//        UIButton *currentBtn = (UIButton *)[self.smallChooseScrollView viewWithTag:1000 + index];
//        if ([self.lasBtn isEqual:currentBtn]) {
//            return;
//        }
//
//        //     UIButton *currentBtn = self.tagLbls[index];
//        [currentBtn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
//        [self.lasBtn setTitleColor:[UIColor zh_textColor] forState:UIControlStateNormal];
//        self.lasBtn = currentBtn;
//        [self smallScroll:currentBtn];
//
//    }
    
    if ([scrollView isEqual:self.contentSwitchView]) {
        
        
    }
    
    
    
}


// 上不按钮点击事件
- (void)smallChoose:(UIButton *)btn {
    
    //点击上面按钮
    //1. 如果按钮为最后一个按钮，不进行处理
    
    //2. 改变下面的 contentScrollView
    
    //有两种模式，模式1  tab 全部位于屏幕内，模式2_tab_无限
    //3.让上部小按钮滚动到中间
    
}

//
- (void)smallScroll:(UIButton *)btn {
    
    //宽度 和 内容宽度
//    CGFloat w = self.smallChooseScrollView.width;
    //    CGFloat contentW = self.smallChooseScrollView.contentSize.width;
    //按钮中点 和 scrollview中点相比较
    
    //应当滚动的
//    CGFloat  dValue =  btn.centerX - w/2.0;
    
    
    //分析什么时候不该移动
    //找出临界值
    
    //1.按钮中点小于 1/2
    
    //最大滚动之
//    CGFloat maxScrollContent = self.smallChooseScrollView.contentSize.width - self.smallChooseScrollView.bounds.size.width;
//
//    CGPoint movePoint = CGPointMake(dValue, 0);
//    if (dValue < 0) {
//        movePoint = CGPointMake(0, 0);
//    }
//
//    if (dValue > maxScrollContent) {
//        movePoint = CGPointMake(maxScrollContent, 0);
//    }
//
//    [self.smallChooseScrollView setContentOffset:movePoint animated:YES];
    
}



- (void)setVcs:(NSMutableArray<UIViewController *> *)vcs {
    
    //
    _vcs = vcs;
    
    //
    [vcs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
    }];
    
    //
    
    //
    
}

@end
