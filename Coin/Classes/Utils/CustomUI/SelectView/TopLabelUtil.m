//
//  TopLabelUtil.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/2/7.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "TopLabelUtil.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"
#import "UIControl+Block.h"
#import "NSString+CGSize.h"

#define BTN_LINE_WIDTH self.lineWidth
#define BTN_BASE_SCALE 0.2

#define UIColorFromRGB(rgbValue,alp) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alp]

#define ItemNums 2.0    //item的数量

@interface TopLabelUtil ()

@property(nonatomic,assign)CGFloat segmentHeight;

@property(nonatomic,assign)CGFloat segmentWidth;

@property(nonatomic,assign)CGFloat btnWidth;

@property(nonatomic,strong)NSMutableArray *btnArray;

@property(nonatomic,strong)UIScrollView *bgScrollView;

@property(nonatomic,strong)UIView *bottomLine;

@property(nonatomic,strong)UIButton *selectBtn;
//底部线条长度
@property (nonatomic, assign) CGFloat lineWidth;

@end

@implementation TopLabelUtil

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.segmentHeight  = frame.size.height;
        self.segmentWidth   = frame.size.width;
        self.titleFont      = [UIFont systemFontOfSize:15];
        self.btnArray       = [[NSMutableArray alloc]init];
        self.titleNormalColor   = [UIColor whiteColor];
        self.defaultSelectIndex = 1;
        
        [self addSubview:self.bgScrollView];
        [self registerKVOPaths];
        
        //检测滚动
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainViewScrollDidScroll:) name:@"MainViewScrollDidScroll" object:nil];
    }
    return self;
}
-(void)mainViewScrollDidScroll:(NSNotification *)noti
{
    UIButton *button = [self viewWithTag:[noti.object intValue]];
    if (button.tag == self.defaultSelectIndex)
    {
        return;
    }else
    {
        self.selectBtn.selected = NO;
        button.selected = YES;
        self.selectBtn  = button;
        self.defaultSelectIndex = button.tag;
    }
}

-(UIScrollView *)bgScrollView{
    if (!_bgScrollView){
        _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.segmentWidth, self.frame.size.height)];
        _bgScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _bgScrollView;
}
-(void)registerKVOPaths{
    for (NSString *keyPath in [self observeKeyPaths]) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}
-(NSArray *)observeKeyPaths{
    NSArray *pathArr = [NSArray arrayWithObjects:@"titleNormalColor",@"titleSelectColor",@"titleFont",@"defaultSelectIndex", @"lineType", nil];
    return pathArr;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    [self updateUIWithNewValueOfKeypath:keyPath];
}
-(void)updateUIWithNewValueOfKeypath:(NSString *)keyPath{
    if ([keyPath isEqualToString:@"titleNormalColor"]) {
        [self updateSegmentViewUI:^(UIButton *btn) {
            [btn setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
        }];
    }else if ([keyPath isEqualToString:@"titleSelectColor"]){
        [self updateSegmentViewUI:^(UIButton *btn) {
            [btn setTitleColor:self.titleSelectColor forState:UIControlStateSelected];
        }];
    }else if([keyPath isEqualToString:@"titleFont"]){
        [self updateSegmentViewUI:^(UIButton *btn) {
            btn.titleLabel.font = self.titleFont;
        }];
    }else if([keyPath isEqualToString:@"defaultSelectIndex"]){
        [self updateSegmentViewUI:^(UIButton *btn) {
            if (btn.tag == self.defaultSelectIndex) {
                btn.selected = YES;
            }else{
                btn.selected = NO;
            }
        }];
    } else if ([keyPath isEqualToString:@"lineType"]) {
        
//        self.bottomLine.width = self.lineWidth;
    }
    
    [self setNeedsLayout];//标记需要刷新
    [self layoutIfNeeded];//刷新界面
}
-(void)updateSegmentViewUI:(void(^)(UIButton *btn))complete{
    for (UIButton *btn in self.btnArray) {
        [btn setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.titleSelectColor forState:UIControlStateSelected];
        btn.titleLabel.font = self.titleFont;
        if (complete) {
            complete(btn);
        }
    }
}

#pragma mark - Setting
-(void)setTitleArray:(NSArray *)titleArray{
    if (!titleArray) {
        return;
    }

    _titleArray = titleArray;
    
    CGFloat lineW = [NSString getWidthWithString:self.titleArray[0] font:self.titleFont.lineHeight];
    
    self.lineWidth = _lineType == LineTypeTitleLength ? lineW: 80;
    
    self.bottomLine = [[UIView alloc]initWithFrame:CGRectMake(self.segmentWidth/4.0-BTN_LINE_WIDTH/2.0+(self.defaultSelectIndex-1)*(BTN_LINE_WIDTH+self.segmentWidth/2.0), self.segmentHeight-4, BTN_LINE_WIDTH, 2)];
    self.bottomLine.backgroundColor = [UIColor redColor];
    [self.bgScrollView addSubview:self.bottomLine];
    
    self.bgScrollView.contentSize = CGSizeMake(BTN_LINE_WIDTH*_titleArray.count, self.segmentHeight);
    
    for (int i = 0; i<_titleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.segmentWidth/4.0-BTN_LINE_WIDTH/2.0+self.segmentWidth/2.0*i, 0, BTN_LINE_WIDTH, self.segmentHeight-2);
        btn.tag = i+1000;
        [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:_titleNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnIndexClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.titleLabel.font = self.titleFont;
        [self.bgScrollView addSubview:btn];
        
        [self.btnArray addObject:btn];
        if (self.defaultSelectIndex - 1 == i) {
            self.selectBtn  = btn;
            btn.selected    = YES;
//            btn.transform   = CGAffineTransformMakeScale(1*BTN_BASE_SCALE+1, 1*BTN_BASE_SCALE+1);
        }
    }
}

- (void)setLineType:(LineType)lineType {
    
    _lineType = lineType;
    
}

//segment 点击按钮事件
-(void)btnIndexClick:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    [self selectSortBarWithIndex:btn.tag - 1000];
    
}


/**
 0左，右
 */
- (void)selectSortBarWithIndex:(NSInteger)index {
    
    UIButton *btn = [self viewWithTag:1000 + index];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(segment:didSelectIndex:)]) {
        [self.delegate segment:self didSelectIndex:index+1];
    }
    
    if (btn.tag == self.defaultSelectIndex) {
        return;
    }else{
        self.selectBtn.selected = NO;
        btn.selected    = YES;
        self.selectBtn  = btn;
        self.defaultSelectIndex = btn.tag;
    }
}

//滑动了，根据偏移的量还改变字体颜色
-(void)dyDidScrollChangeTheTitleColorWithContentOfSet:(CGFloat)width{
    NSInteger leftIndex = width/kScreenWidth -1;
    if (leftIndex < 0) {
        leftIndex = 0;
    }
    NSInteger rightIndex    = leftIndex + 1;
    
    //获取左边按钮
    UIButton *leftBtn   = self.btnArray[leftIndex];
    UIButton *rightBtn;
    NSInteger count =  self.btnArray.count;
    if (rightIndex < count) {
        rightBtn = self.btnArray[rightIndex];
    }
    
    //计算右边按钮的偏移比 相对比
    CGFloat rightScale  = width/kScreenWidth;
    rightScale          = rightScale-leftIndex;
    
    //左边按钮的偏移比
    CGFloat leftScale   = 1-rightScale;
    
    //按钮发生相对应的形变
//    leftBtn.transform   = CGAffineTransformMakeScale(leftScale*BTN_BASE_SCALE+1, leftScale*BTN_BASE_SCALE+1);
//    rightBtn.transform  = CGAffineTransformMakeScale(rightScale*BTN_BASE_SCALE+1, rightScale*BTN_BASE_SCALE+1);
    
    //按钮文字颜色渐变
    CGFloat normalRed,normalGreen,normalBlue,normalAlpha;
    CGFloat selectRed,selectGreen,selectBlue,selectAlpha;
    
    //获取正常设置颜色
    [self.titleNormalColor getRed:&normalRed green:&normalGreen blue:&normalBlue alpha:&normalAlpha];
    [self.titleSelectColor getRed:&selectRed green:&selectGreen blue:&selectBlue alpha:&selectAlpha];
    
    //选中和未选中的色差
    CGFloat redDif      = selectRed - normalRed;
    CGFloat greenDif    = selectGreen - normalGreen;
    CGFloat blueDif     = selectBlue - normalBlue;
    CGFloat alphaDif    = selectAlpha - normalAlpha;
    
    leftBtn.titleLabel.textColor = [UIColor colorWithRed:leftScale * redDif + normalRed green:leftScale * greenDif + normalGreen blue:leftScale * blueDif + normalBlue alpha:leftScale * alphaDif+normalAlpha];
    rightBtn.titleLabel.textColor = [UIColor colorWithRed:rightScale * redDif + normalRed green:rightScale * greenDif + normalGreen blue:rightScale * blueDif + normalBlue alpha:rightScale * alphaDif+normalAlpha];
    
    //底部线的偏移
    CGRect frame    = self.bottomLine.frame;
    CGFloat lineDif = rightBtn.frame.origin.x-leftBtn.frame.origin.x;
    
    frame.origin.x  = rightScale*lineDif+leftBtn.frame.origin.x;
    CGFloat widthDif = rightBtn.frame.size.width-leftBtn.frame.size.width;
    if (widthDif != 0) {
        CGFloat leftSelectBgWidth = leftBtn.frame.size.width;
        frame.size.width = rightScale*widthDif + leftSelectBgWidth;
    }
    self.bottomLine.frame = frame;
}

-(void)dealloc{
    for (NSString *keyPath in [self observeKeyPaths]) {
        [self removeObserver:self forKeyPath:keyPath];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - 消息小红点
- (void)showBadgeOnItemIndex:(int)index{
    
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    CGFloat badgeW = 8;
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = badgeW/2.0;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index +0.7) / ItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.2 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, badgeW, badgeW);
    [self addSubview:badgeView];
    
}

- (void)hideBadgeOnItemIndex:(int)index{
    
    //移除小红点
    [self removeBadgeOnItemIndex:index];
    
}

- (void)removeBadgeOnItemIndex:(int)index{
    
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        
        if (subView.tag == 888+index) {
            
            [subView removeFromSuperview];
            
        }
    }
}

@end
