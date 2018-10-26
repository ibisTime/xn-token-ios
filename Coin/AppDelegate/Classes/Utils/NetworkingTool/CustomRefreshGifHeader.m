//
//  CustomRefreshGifHeader.m
//  RedScarf
//
//  Created by CPZX008 on 16/11/23.
//  Copyright © 2016年 xboker. All rights reserved.
//

#import "CustomRefreshGifHeader.h"

#define WIDTH   [UIScreen mainScreen].bounds.size.width


@interface CustomRefreshGifHeader()

//一直左滑动的动画图片
@property (nonatomic, strong) UIView *bgView;
//顶部的图片
@property (nonatomic, strong) UIImageView *topImage;
//自定义的刷新提示状态
@property (nonatomic, strong) UILabel *customStatusLable;
//跑动的ImageV
@property (nonatomic, strong) UIImageView *customImageV;
//重写父类
@property (strong, nonatomic) NSMutableDictionary *stateImages;
//重写父类
@property (strong, nonatomic) NSMutableDictionary *stateDurations;




@end

@implementation CustomRefreshGifHeader

#pragma mark - 懒加载


- (UIImageView *)topImage {
    if (!_topImage) {
        [self addSubview:_topImage =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"顶部图片"]]];
        _topImage.frame = CGRectMake(0, -360, WIDTH, 360);
        _topImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _topImage;
}

- (UIView *)bgView {
    if (!_bgView) {
        [self addSubview:_bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH * 2, 60)]];
        for (int i = 0; i < 2; i ++) {
            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refreshbg"]];
            image.frame = CGRectMake(WIDTH * i, 0, WIDTH, 60);
            image.contentMode = UIViewContentModeScaleAspectFill;
            [_bgView addSubview:image];
        }
    }
    return _bgView;
}

- (UIImageView *)customImageV {
    if (!_customImageV ) {
        [self addSubview:_customImageV = [[UIImageView alloc] init]];
    }
    return _customImageV;
}




- (NSMutableDictionary *)stateImages {
    if (!_stateImages) {
        self.stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

- (NSMutableDictionary *)stateDurations {
    if (!_stateDurations) {
        self.stateDurations = [NSMutableDictionary dictionary];
    }
    return _stateDurations;
}



#pragma mark - 公共方法
//重写动画实现
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state {
    if (images == nil) return;
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration);
    
    /* 根据图片设置控件的高度 */
    UIImage *image = [images firstObject];
    if (image.size.height > self.mj_h) {
        self.mj_h = image.size.height;
    }
}

- (void)setImages:(NSArray *)images forState:(MJRefreshState)state {
    [self setImages:images duration:images.count * 0.1 forState:state];
}

#pragma mark - 实现父类的方法
//初始化操作
- (void)prepare {
    [super prepare];
    self.labelLeftInset = 20;
    [self bgView];
    [self topImage];
    self.lastUpdatedTimeLabel.hidden = YES;
    self.gifView.hidden = YES;
    self.stateLabel.hidden = YES;
    [self bringSubviewToFront:self.customStatusLable];
    [self bringSubviewToFront:self.customImageV];
}


///重写MJ百分比
- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    //如果拖动的百分比大于1则显示为1
    if (self.scrollView.dragging) {
        if (pullingPercent >= 1) {
            pullingPercent = 0.9999;
        }
    }
    
    self.customImageV.frame = CGRectMake(WIDTH * 0.2  * pullingPercent ,  60 * (1 - pullingPercent), 60 * pullingPercent, 60 * pullingPercent);
    if (self.bgView.layer.animationKeys.count == 0) {
        [self.bgView.layer addAnimation:[self creatAnimation] forKey:@"animation"];
    }
    
    NSArray *images = self.stateImages[@(MJRefreshStateIdle)];
    if (self.state != MJRefreshStateIdle || images.count == 0) return;
    [self.customImageV stopAnimating];
    NSUInteger index =  images.count * pullingPercent;
    if (index >= images.count) index = images.count - 1;
    self.customImageV.image = images[index];
    [self layoutSubviews];
}



//新的动画图片frame不在根据placeSubviews调整, 而是在拖动百分比中设置
- (void)placeSubviews {
    [super placeSubviews];
}

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState
#pragma mark    无论是状态还是百分比发生变化, 均检测一次是否有动画; 若没有,添加
    if (self.bgView.layer.animationKeys.count == 0) {
        [self.bgView.layer addAnimation:[self creatAnimation] forKey:@"animation"];
    }
    //自定义位置的提示刷新状态始终跟父类的保持一致
    self.customStatusLable.text = self.stateLabel.text;
    if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing) {
        NSArray *images = self.stateImages[@(state)];
        if (images.count == 0) return;
        
        [self.customImageV stopAnimating];
        if (images.count == 1) { // 单张图片
            self.customImageV.image = [images lastObject];
        } else { // 多张图片
            self.customImageV.animationImages = images;
            self.customImageV.animationDuration = [self.stateDurations[@(state)] doubleValue];
            [self.customImageV startAnimating];
        }
    } else if (state == MJRefreshStateIdle) {
        [self.customImageV stopAnimating];
    }
    
    
}

//主要效果就是实现当刷新状态消失时仍然能够保持动画完成.
- (void)endRefreshing {
    __weak CustomRefreshGifHeader *weakSelf = self;
    [UIView animateWithDuration:1.3f animations:^{
        weakSelf.customImageV.frame = CGRectMake(WIDTH + 10, 60 * 0.00001, 60 * 0.9999, 60 * 0.9999);
    } completion:^(BOOL finished) {
        //向右跑动的动画当跑出屏幕后就置位zero
        weakSelf.customImageV.frame = CGRectZero;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.state = MJRefreshStateIdle;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.bgView.layer removeAllAnimations];
            });
        });
    }];
}



#pragma mark    Animation

- (CABasicAnimation *)creatAnimation {
    self.bgView.layer.anchorPoint = CGPointMake(0, 0);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(-WIDTH, 0)];
    animation.repeatCount = MAXFLOAT;
    animation.duration = 20;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeBackwards;
    return animation;
}



//- (UILabel *)customStatusLable {
//    if (!_customStatusLable) {
//        [self addSubview:_customStatusLable  = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, WIDTH, 20)]];
//        _customStatusLable.font = [UIFont systemFontOfSize:10];
//        _customStatusLable.textAlignment = NSTextAlignmentCenter;
//        _customStatusLable.textColor = [UIColor darkGrayColor];
//    }
//    return _customStatusLable;
//}




- (void)dealloc {
    NSLog(@"%@------------dealloc", self.class);
}




@end
