//
//  HomeHeaderView.m
//  OGC
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "HomeHeaderView.h"

//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Category
#import "UIButton+EnLargeEdge.h"
//V
#import "TLBannerView.h"

@interface HomeHeaderView()

//轮播图
@property (nonatomic,strong) TLBannerView *bannerView;
//统计
@property (nonatomic, strong) UIView *statisticsView;
//数据
@property (nonatomic, strong) UILabel *dataLbl;

@end

@implementation HomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //轮播图
        [self initBannerView];
        //统计
        [self initStatisticsView];
    }
    return self;
}

#pragma mark - Init
- (void)initBannerView {
    
    CoinWeakSelf;
    
    //顶部轮播
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(185))];
    
    bannerView.selected = ^(NSInteger index) {
        
        if (weakSelf.headerBlock) {
            
            weakSelf.headerBlock(HomeEventsTypeBanner, index);
        }
    };
    
    [self addSubview:bannerView];
    
    self.bannerView = bannerView;
}

- (void)initStatisticsView {
    
    CGFloat h = 100;
    
    self.statisticsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bannerView.yy, kScreenWidth, h)];
    
    self.statisticsView.backgroundColor = kWhiteColor;
    
    [self addSubview:self.statisticsView];
    
    //右箭头
    CGFloat arrowW = 6;
    CGFloat arrowH = 10;
    CGFloat rightMargin = 10;
    
    UIImageView *arrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
    
    [self.statisticsView addSubview:arrowIV];
    [arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(arrowW));
        make.height.equalTo(@(arrowH));
        make.centerY.equalTo(@0);
        make.right.equalTo(@(-rightMargin));
    }];
    
    //空投统计
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:15.0];
    textLbl.text = @"空投统计";
    [self.statisticsView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@10);
    }];
    //比例
    CGFloat lineW = kWidth(150);
    CGFloat scaleH = 7;
    
    UIView *scaleBgView = [[UIView alloc] init];
    
    scaleBgView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    
    [self.statisticsView addSubview:scaleBgView];
    [scaleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(textLbl.mas_bottom).offset(10);
        make.left.equalTo(textLbl.mas_left);
        make.right.equalTo(arrowIV.mas_left).offset(-10);
        make.height.equalTo(@(scaleH));
    }];
    
    UIView *scaleView = [[UIView alloc] init];
    
    scaleView.tag = 1300;
    scaleView.backgroundColor = kAppCustomMainColor;
    scaleView.layer.cornerRadius = scaleH/2.0;
    
    [scaleBgView addSubview:scaleView];
    //数据
    self.dataLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor
                                                font:13.0];
    
    [self.statisticsView addSubview:self.dataLbl];
    [self.dataLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(textLbl.mas_left);
        make.bottom.equalTo(@(-20));
    }];
    
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self.statisticsView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@10);
    }];
    
    scaleView.frame = CGRectMake(0, 0, lineW/2.0, scaleH);
    
    self.dataLbl.text = [NSString stringWithFormat:@"总量: %@   已投: %@   占比: %@", @"2000W", @"1000W", @"50%"];
}

@end
