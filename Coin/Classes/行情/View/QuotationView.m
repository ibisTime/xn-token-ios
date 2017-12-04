//
//  QuotationView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "QuotationView.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import <CDCommon/UIScrollView+TLAdd.h>
#import "UIButton+EnLargeEdge.h"
#import "NSNumber+Extension.h"
#import "NSString+Extension.h"

@interface QuotationView ()

//虚拟币
@property (nonatomic, strong) UIView *coinView;
//系统公告
@property (nonatomic, strong) UIView *systemNoticeView;
//新手指导
@property (nonatomic, strong) UIView *guideView;

@property (nonatomic, strong) UIButton *headBtn;

@end

@implementation QuotationView

- (instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        
        [self initScrollView];
        //轮播图
        [self initBannerView];
        //虚拟币价格
        [self initCoinView];
        //系统公告
        [self initSystemView];
        //新手指导
        [self initGuideView];
        
        
    }
    return self;
}

#pragma mark - Init

- (void)initScrollView {
    
    self.backgroundColor = kBackgroundColor;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    [self adjustsContentInsets];
}

- (void)initBannerView {
    
    CoinWeakSelf;
    
    //顶部轮播
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeight(175))];
    
    bannerView.selected = ^(NSInteger index) {
        
        if (weakSelf.quotationBlock) {
            
            weakSelf.quotationBlock(QuotationEventTypeHTML, index);
        }
        
    };
        
    [self addSubview:bannerView];
    
    self.bannerView = bannerView;
}

- (void)initCoinView {
    
    self.coinView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bannerView.yy, kScreenWidth, 90)];
    
    [self addSubview:self.coinView];
    
    NSArray *textArr = @[@"以太币价格", @"比特币价格"];
    
    [textArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat viewW = kScreenWidth/2.0;
        
        UIView *view = [[UIView alloc] init];
        
        view.backgroundColor = kWhiteColor;
    
        view.tag = 1390 + idx;
        
        [self.coinView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(idx*viewW);
            make.top.equalTo(self.bannerView.mas_bottom);
            make.width.equalTo(@(viewW));
            make.height.equalTo(@(90));
            
        }];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coinDetail:)];
        
        [view addGestureRecognizer:tapGR];
        
        //虚拟币名称
        UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:13.0];
        
        textLbl.text = textArr[idx];
        
        [view addSubview:textLbl];
        [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(view.mas_centerX);
            make.top.equalTo(view.mas_top).offset(13);

        }];
        
        //价格
        UILabel *priceLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kClearColor font:16.0];
        
        priceLbl.tag = 1400 + idx;
        
        [view addSubview:priceLbl];
        [priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(textLbl.mas_bottom).offset(10);
            make.centerX.equalTo(view.mas_centerX);
            
        }];
        
        //涨跌数量
        UILabel *diffPriceLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kClearColor font:11.0];
        
        diffPriceLbl.tag = 1410 + idx;
        
        diffPriceLbl.textAlignment = NSTextAlignmentCenter;
        
        [view addSubview:diffPriceLbl];
        [diffPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(view.mas_left);
            make.width.equalTo(@(viewW/2.0));
            make.top.equalTo(priceLbl.mas_bottom).offset(10);
            
        }];
        
        //涨跌幅度
        UILabel *diffPreLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kClearColor font:11.0];
        
        diffPreLbl.tag = 1420 + idx;
        
        diffPreLbl.textAlignment = NSTextAlignmentCenter;
        
        [view addSubview:diffPreLbl];
        [diffPreLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(diffPriceLbl.mas_right);
            make.width.equalTo(@(viewW/2.0));
            make.top.equalTo(priceLbl.mas_bottom).offset(10);
            
        }];
        
    }];

    //竖线
    UIView *vline = [[UIView alloc] init];
    
    vline.backgroundColor = kLineColor;
    
    [self.coinView addSubview:vline];
    [vline mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(@0);
        make.width.equalTo(@0.5);
        make.height.equalTo(@50);
        
    }];

    //横线
    UIView *hline = [[UIView alloc] init];
    
    hline.backgroundColor = kLineColor;
    
    [self.coinView addSubview:hline];
    [hline mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
}

- (void)initSystemView {
    
    self.systemNoticeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.coinView.yy, kScreenWidth, 50)];
    
    self.systemNoticeView.backgroundColor = kWhiteColor;
    
    [self addSubview:self.systemNoticeView];
    
    //icon
    UIImageView *iconIV= [[UIImageView alloc] initWithImage:kImage(@"系统公告")];
    
    [self.systemNoticeView addSubview:iconIV];
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(self.systemNoticeView.mas_centerY);
        make.width.equalTo(@59);
        
    }];
    //右箭头
    UIImageView *rightArrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
    
    [self.systemNoticeView addSubview:rightArrowIV];
    [rightArrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.systemNoticeView.mas_right).offset(-15);
        make.width.equalTo(@6.5);
        make.centerY.equalTo(self.systemNoticeView.mas_centerY);
        
    }];
    
    //内容
    UIButton *contentBtn = [UIButton buttonWithTitle:@"" titleColor:kTextColor backgroundColor:kClearColor titleFont:14.0];
    
    [contentBtn addTarget:self action:@selector(clickSystemNotice) forControlEvents:UIControlEventTouchUpInside];
    
    [self.systemNoticeView addSubview:contentBtn];
    [contentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconIV.mas_right).offset(12);
        make.height.equalTo(@50);
        make.right.equalTo(rightArrowIV.mas_left).offset(-12);
        make.top.equalTo(@0);
        
    }];
    
    [contentBtn setTitleLeft];
    
    self.headBtn = contentBtn;
    
}

- (void)initGuideView {
    
    UIView *guideView = [[UIView alloc] initWithFrame:CGRectMake(0, self.systemNoticeView.yy + 10, kScreenWidth, 200)];
    
    guideView.backgroundColor = kWhiteColor;
    
    [self addSubview:guideView];
    
    self.guideView = guideView;
    
    //新手指导
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    textLbl.text = @"新手指导";
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [guideView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(guideView.mas_centerX);
        make.top.equalTo(@(10));
        
    }];
    
    //左边
    UIImageView *leftIconIV = [[UIImageView alloc] initWithImage:kImage(@"左")];
    
    [guideView addSubview:leftIconIV];
    [leftIconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(textLbl.mas_left).offset(-10);
        make.centerY.equalTo(textLbl.mas_centerY);
        
    }];
    
    //右边
    UIImageView *rightIconIV = [[UIImageView alloc] initWithImage:kImage(@"右")];
    
    [guideView addSubview:rightIconIV];
    [rightIconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(textLbl.mas_right).offset(10);
        make.centerY.equalTo(textLbl.mas_centerY);
    }];
    
}

#pragma mark - Setting
- (void)setNotices:(NSMutableArray<NoticeModel *> *)notices {
    
    _notices = notices;
    
    if (_notices.count > 0) {
        
        NoticeModel *notice = _notices[0];
        
        [self.headBtn setTitle:notice.smsTitle forState:UIControlStateNormal];
        
    } else {
        //预见未来的自己, 我要上精选！
        [self.headBtn setTitle:@"" forState:UIControlStateNormal];
        
    }
    
    [self.headBtn setTitleLeft];
    
}

- (void)setGuides:(NSMutableArray<GuideModel *> *)guides {
    
    _guides = guides;
    
    NSInteger count = guides.count;

    CGFloat h = kWidth(100);
    
    CGFloat w = (kScreenWidth - 40)/2.0;
    
    CGFloat guideH = 40 + (h + 10)*(count+1)/2 + 15;
    
    self.guideView.frame = CGRectMake(0, self.systemNoticeView.yy + 10, kScreenWidth, guideH);
    
    [guides enumerateObjectsUsingBlock:^(GuideModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *btn = [UIButton buttonWithTitle:@"" titleColor:kWhiteColor backgroundColor:kClearColor titleFont:15.0];
        
        btn.tag = 1300 + idx;
        
        [btn addTarget:self action:@selector(lookDetail:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn sd_setImageWithURL:[NSURL URLWithString:[obj.advPic convertImageUrl]] forState:UIControlStateNormal placeholderImage:kImage(@"如何注册")];
        [self.guideView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(15 + (w+10)*(idx%2)));
            make.width.equalTo(@(w));
            make.height.equalTo(@(h));
            make.top.equalTo(self.guideView.mas_top).offset(50 + (h+10)*(idx/2));
        }];
    }];

    self.contentSize = CGSizeMake(kScreenWidth, self.guideView.yy + 15);
}

#pragma mark - Events

- (void)clickSystemNotice {
    
    if (_quotationBlock) {
        
        _quotationBlock(QuotationEventTypeNotice, 0);
    }
    
}

- (void)lookDetail:(UIButton *)sender {
    
    NSInteger index = sender.tag - 1300;

    if (_quotationBlock) {
        
        _quotationBlock(QuotationEventTypeGuideDetail, index);
    }
}

- (void)coinDetail:(UITapGestureRecognizer *)tapGR {
    
    NSInteger index = tapGR.view.tag - 1390;
    
    if (_quotationBlock) {
        
        _quotationBlock(QuotationEventTypeCoinDetail, index);
    }
}

@end
