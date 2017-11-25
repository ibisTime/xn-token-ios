//
//  OrderCommentView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "OrderCommentView.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

@interface OrderCommentView ()

//背景
@property (nonatomic, strong) UIView *bgView;
//按钮数组
@property (nonatomic, strong) NSMutableArray <UIButton *>*btnArr;

@end

@implementation OrderCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.btnArr = [NSMutableArray array];
    
    self.alpha = 0;
    
    self.backgroundColor = [UIColor colorWithUIColor:kBlackColor alpha:0.6];
    
    self.bgView = [[UIView alloc] init];
    
    self.bgView.backgroundColor = kWhiteColor;
    
    self.bgView.layer.cornerRadius = 10;
    self.bgView.clipsToBounds = YES;
    
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.top.equalTo(@(kHeight(105)));
        make.center.equalTo(@0);
        make.height.equalTo(@235);
        make.width.equalTo(@(kWidth(307)));
        
    }];
    //交易评价
    UILabel *commentLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:16.0];
    
    commentLbl.text = @"交易评价";
    
    [self.bgView addSubview:commentLbl];
    [commentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@18);
        make.centerX.equalTo(@0);
        
    }];
    
    //text
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14.0];
    
    textLbl.text = @"交易有何印象? 快来评价吧";
    
    [self.bgView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(commentLbl.mas_bottom).offset(23);
        make.centerX.equalTo(@0);
        
    }];
    
    //评价按钮
    NSArray *textArr = @[@"好评", @"差评"];
    
    NSArray *imgArr = @[@"好评灰", @"差评灰"];
    
    NSArray *selectImgArr = @[@"好评红", @"差评红"];

    __block UIButton *lastBtn;
    
    [textArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *btn = [UIButton buttonWithTitle:textArr[idx] titleColor:kTextColor4 backgroundColor:kClearColor titleFont:12.0];
        
        btn.selected = idx == 0 ? YES: NO;
        
        [btn setTitleColor:kThemeColor forState:UIControlStateSelected];
        
        [btn setImage:kImage(imgArr[idx]) forState:UIControlStateNormal];
        
        [btn setImage:kImage(selectImgArr[idx]) forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(clickComment:) forControlEvents:UIControlEventTouchUpInside];
        
        lastBtn = btn;
        
        [self.btnArr addObject:btn];

        [self.bgView addSubview:btn];
        
        CGFloat btnW = 100;
        
        CGFloat leftMargin = (kWidth(307) - 2*btnW)/3.0;
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(textLbl.mas_bottom).offset(34);
            make.width.equalTo(@(btnW));
            make.height.equalTo(@55);
            make.left.equalTo(@(leftMargin + idx*(btnW+leftMargin)));
            
        }];
        
        CGFloat offset = 24;
        
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.frame.size.width, - btn.imageView.frame.size.height-offset/2, 0);
    
        btn.imageEdgeInsets = UIEdgeInsetsMake(-btn.titleLabel.intrinsicContentSize.height - offset/2, 0, 0, -btn.titleLabel.intrinsicContentSize.width);
        
    }];
    
    //提交
    UIButton *commitBtn = [UIButton buttonWithTitle:@"提交" titleColor:kThemeColor backgroundColor:kClearColor titleFont:16.0];
    
    [commitBtn addTarget:self action:@selector(clickCommit) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgView addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(lastBtn.mas_bottom).offset(15);
        make.width.equalTo(@100);
        make.height.equalTo(@44);
        
    }];
    
}

#pragma mark - Events

- (void)clickComment:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    [self.btnArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj == sender) {
            
            obj.selected = YES;
            
        } else {
            
            obj.selected = NO;
        }
    }];
}

- (void)clickCommit {
    
    __block NSString *result = @"";
    
    [self.btnArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0 && obj.selected) {
            
            result = @"2";
            
        } else if (idx == 1 && obj.selected) {
            
            result = @"0";
        }
        
    }];
    
    if (self.commentBlock) {
        
        self.commentBlock(result);
    }
}

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
    
}

@end
