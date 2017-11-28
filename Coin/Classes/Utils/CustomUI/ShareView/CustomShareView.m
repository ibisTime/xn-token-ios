//
//  CustomShareView.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/26.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import "CustomShareView.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

//客户端
#import "WXApi.h"

typedef NS_ENUM(NSInteger, ShareType) {
    
    ShareTypeWechatSession = 0,
    ShareTypeWechatTimeline,

};

@interface CustomShareView ()

@property (nonatomic , strong) NSMutableArray *shareBtnArray;

@property (nonatomic , strong) NSArray *shareArray;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) NSInteger secondCount;

@property (nonatomic, strong) UIView *btnView;

@end

@implementation CustomShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.shareBtnArray = [[NSMutableArray alloc]initWithCapacity:0];
        UIView *zhezhaoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        zhezhaoView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
        zhezhaoView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerAction:)];
        [zhezhaoView addGestureRecognizer:myTap];
        
        [self addSubview:zhezhaoView];
    }
    return self;
}

- (void)setShareAry:(NSArray *)shareAry delegate:(id)delegate {
    
    _delegate = delegate;
    _shareArray = shareAry;
    
    UIView *contentView = [[UIView alloc] init];
    
    contentView.backgroundColor = kWhiteColor;
    
    [self addSubview:contentView];

    _btnView = [[UIView alloc] init];
    
    _btnView.backgroundColor = kWhiteColor;
    
    [contentView addSubview:_btnView];
    [_btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(kHeight(160));
    }];
    
    //计算客户端的个数
    
    [self countAppNum];
    
    UIView *lineView = [[UIView alloc] init];
    
    lineView.backgroundColor = kLineColor;
    [contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.top.mas_equalTo(_btnView.mas_bottom).mas_equalTo(0);
        
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithTitle:@"取消" titleColor:kTextColor2 backgroundColor:kWhiteColor titleFont:14.0];
    
    [cancelBtn addTarget:self action:@selector(clickCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(lineView.mas_bottom).mas_equalTo(0);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(kHeight(160) + 1 + 50);
        make.bottom.mas_equalTo(0);
    }];
    
}

- (void)countAppNum {
    
    _count = 0;
    
    BOOL hadInstalledWeixin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]];
    BOOL hadInstalledQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
    BOOL hadInstalledWeibo = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]];
    BOOL hadInstalledWeibohd = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibohd://"]];
    
    //计算安装客户端的数量
    if (hadInstalledWeixin) {
        
        _count = 2;
    }
    
    _secondCount = 0;
    
    //判断是否安装微信
    if (hadInstalledWeixin) {
        
        _secondCount = 1;
        
        [self createButtonAndLabelWithShareType:ShareTypeWechatSession];
        
        _secondCount = 2;
        
        [self createButtonAndLabelWithShareType:ShareTypeWechatTimeline];
    }
    
    
}

- (void)createButtonAndLabelWithShareType:(ShareType)shareType {
    
    CGFloat index = _secondCount > 4 ? _secondCount - 4: _secondCount;
    
    NSInteger i = _count < 4 ? _count + 1: 5;
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.tag = 8000 + shareType;
    [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [shareButton setBackgroundImage:[UIImage imageNamed:_shareArray[shareType][@"image"]] forState:UIControlStateNormal];
    
    [_btnView addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(-10);
        make.width.height.mas_equalTo(kWidth(50));
        make.left.mas_equalTo(index*kScreenWidth/i - 20);
        
    }];
    
    UILabel *shareLabel = [[UILabel alloc] init];
    
    shareLabel.textColor = kBlackColor;
    shareLabel.font = Font(12.0);
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.text = _shareArray[shareType][@"title"];
    
    [_btnView addSubview:shareLabel];
    [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(shareButton.mas_bottom).mas_equalTo(10);
        make.width.mas_equalTo(kWidth(100));
        make.height.mas_lessThanOrEqualTo(30);
        make.centerX.mas_equalTo(shareButton.mas_centerX);
        
    }];
    
}

- (void)shareButtonClick:(UIButton*)btn
{
    
    if ([self.delegate respondsToSelector:@selector(customShareViewButtonAction:title:)]) {
        
        [self.delegate customShareViewButtonAction:self title:_shareArray[btn.tag-8000][@"title"]];
        
        [self tappedCancel];
        
        
    }
}

- (void)clickCancel:(UIButton *)sender {

    [self tappedCancel];

}

- (void)tapGestureRecognizerAction:(UITapGestureRecognizer *)sender {
    
    [self tappedCancel];
}

- (void)tappedCancel {
    
    if (self.cancleBlock) {
        self.cancleBlock();
    }
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//颜色生成图片方法
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context,
                                   
                                   color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
