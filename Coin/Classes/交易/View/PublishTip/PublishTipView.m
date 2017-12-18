//
//  PublishTipView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "PublishTipView.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"
#import "PublishButton.h"

@interface PublishTipView ()

@property (nonatomic, strong) UIView *whiteBg;
//蒙版
@property (nonatomic, strong) UIVisualEffectView *effectView;
//取消
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSUInteger upIndex;

@property (nonatomic, assign) NSUInteger downIndex;

@end

@implementation PublishTipView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray*)titles {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _titles = titles;
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = CGRectMake(0, 0, self.width, self.height);
        [self addSubview:effectView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [effectView addGestureRecognizer:tap];
        
        
        _effectView = effectView;
        _effectView.alpha = 0.001;
        
        //取消
        UIButton *cancelBtn = [UIButton buttonWithImageName:@"叉"];
        
        [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(@0);
            make.bottom.equalTo(self.mas_bottom).offset(kHeight(-30));
            
        }];
        
        self.cancelBtn = cancelBtn;
        NSArray *imgName = @[@"发布卖出",@"发布购买"];
        for (NSInteger i = 0; i < titles.count; i++) {
            
            CGFloat w = 110;
            
            CGFloat x = (kScreenWidth/2.0 - w + i*kScreenWidth)/2.0;
            
            CGFloat y = kScreenHeight - kHeight(112) - w;
            
            PublishButton *btn = [PublishButton buttonWithType:UIButtonTypeCustom];
            
            [btn setImage:titles[i] forState:UIControlStateNormal];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            
            btn.frame = CGRectMake(x, y, w, w);
            
            btn.tag = 1000+i;

            [btn setTitleColor:kTextColor forState:UIControlStateNormal];
            
            btn.titleLabel.font = Font(15.0);
            
            btn.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
            
            [btn setImage:kImage(imgName[i]) forState:UIControlStateNormal];
            //取消高亮
            btn.showsTouchWhenHighlighted = NO;
            
            [btn addTarget:self action:@selector(buttonOnClicked:) forControlEvents:UIControlEventTouchUpInside];

            [self addSubview:btn];
            
        }
        
    }
    return self;
}

#pragma mark - Setting
- (void)setTitleColor:(UIColor*)color index:(NSInteger)index {
    
    UIButton *btn = [_whiteBg viewWithTag:1000+index];
    
    [btn setTitleColor:color forState:UIControlStateNormal];
}

#pragma mark - Events

- (void)buttonOnClicked:(UIButton*)btn {
    
    [self hide];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (_publishBlock) {
            
            _publishBlock(btn.tag - 1000);
        }
    });
    
}

- (void)clickCancel {
    
    [self hide];
}

- (void)tapAction {
    
    [self hide];
}


- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _effectView.alpha = 1;
        
        _cancelBtn.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
    
    //定时器控制每个按钮弹出的时间
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(popupBtn) userInfo:nil repeats:YES];
    
}

- (void)popupBtn {
    
    if (_upIndex == self.titles.count) {
        
        [self.timer invalidate];
        
        _upIndex = 0;
        
        return;
    }
    
    UIButton *btn = [self viewWithTag:1000 + _upIndex];
    
    [self setUpOneBtnAnim:btn];
    
    _upIndex++;

}

//设置按钮从第一个开始向上滑动显示
- (void)setUpOneBtnAnim:(UIButton *)btn
{
    
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        btn.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished){
        
        //获取当前显示的菜单控件的索引
        _downIndex = self.titles.count - 1;
    }];
    
}

- (void)hide {
    
    self.userInteractionEnabled = NO;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(returnUp) userInfo:nil repeats:YES];

    [UIView animateWithDuration:0.8 animations:^{
        
        _effectView.alpha = 0.001;
        
        _cancelBtn.alpha = 0.001;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];

    }];
    
}

//设置按钮从后往前下落
- (void)returnUp {
    
    if (_downIndex == -1) {
        
        [self.timer invalidate];
        
//        self.timer = nil;
        self.userInteractionEnabled = YES;
        
        return;
    }
    
    UIButton *btn = [self viewWithTag:1000 + _downIndex];

    [self setDownOneBtnAnim:btn];
    
    _downIndex--;

}

//按钮下滑
- (void)setDownOneBtnAnim:(UIButton *)btn
{
    
    [UIView animateWithDuration:0.15 animations:^{
        
        btn.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

@end
