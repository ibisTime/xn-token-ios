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
#import "UIColor+theme.h"
//Category
#import "UIButton+EnLargeEdge.h"
#import "NSString+Extension.h"
#import "CoinUtil.h"
//V
#import "TLBannerView.h"

@interface HomeHeaderView()

//轮播图
@property (nonatomic,strong) TLBannerView *bannerView;
//统计
@property (nonatomic, strong) UIView *statisticsView;
//数据
@property (nonatomic, strong) UILabel *dataLbl;
//应用
@property (nonatomic, strong) UIView *applicationView;

@property (nonatomic, strong) UIButton *tempBtn;

@end

@implementation HomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        //轮播图
        [self initBannerView];
        //统计
//        [self initStatisticsView];
        //应用
        [self initApplicationView];
    }
    return self;
}

#pragma mark - Init
- (void)initBannerView {
    
    CoinWeakSelf;
    
    //顶部轮播
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth-30, kHeight(138))];
    bannerView.layer.cornerRadius = 5;
    bannerView.clipsToBounds = YES;
    
    bannerView.selected = ^(NSInteger index) {
        
        if (weakSelf.headerBlock) {
            
            weakSelf.headerBlock(HomeEventsTypeBanner, index);
        }
    };
    
    [self addSubview:bannerView];
    
    self.bannerView = bannerView;
}

- (void)initStatisticsView {
    
    CGFloat h = 160;
    
    self.statisticsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bannerView.yy, kScreenWidth, h)];
    
    self.statisticsView.backgroundColor = kWhiteColor;
    
    [self addSubview:self.statisticsView];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookFlowList:)];
    
    [self.statisticsView addGestureRecognizer:tapGR];
    
    UIImageView *lineiV = [[UIImageView alloc] init];
    
    lineiV.backgroundColor = kAppCustomMainColor;
    
    [self.statisticsView addSubview:lineiV];
    [lineiV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@14);
        make.width.equalTo(@3);
        make.height.equalTo(@11);
    }];
    
    //官方服务
    UILabel *serviceTextLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                      textColor:kHexColor(@"#474747")
                                                    font:15.0];
    serviceTextLbl.text = [LangSwitcher switchLang:@"官方服务" key:nil];
    [self.statisticsView addSubview:serviceTextLbl];
    [serviceTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(lineiV.mas_right).offset(10);
        make.centerY.equalTo(lineiV.mas_centerY);
    }];
    
    //topLine
    UIView *topLine = [[UIView alloc] init];
    
    topLine.backgroundColor = kLineColor;
    
    [self.statisticsView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.top.equalTo(@40);
        make.height.equalTo(@0.5);
    }];
    
//    UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"分发统计")];
//    
//    [self.statisticsView addSubview:iconIV];
//    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(@15);
//        make.top.equalTo(@15);
//    }];
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
                                               textColor:kHexColor(@"#474747")
                                                    font:15.0];
    textLbl.text = [LangSwitcher switchLang:@"空投统计" key:nil];
    
    [self.statisticsView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(topLine.mas_bottom).offset(15);
    }];
    //比例
    CGFloat scaleH = 7;
    
    UIView *scaleBgView = [[UIView alloc] init];
    
    scaleBgView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    scaleBgView.tag = 1301;
    scaleBgView.layer.cornerRadius = scaleH/2.0;
    scaleBgView.clipsToBounds = YES;
    
    [self.statisticsView addSubview:scaleBgView];
    [scaleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(textLbl.mas_bottom).offset(20);
        make.left.equalTo(textLbl.mas_left);
        make.right.equalTo(arrowIV.mas_right);
        make.height.equalTo(@(scaleH));
    }];
    
    UIView *scaleView = [[UIView alloc] init];
    
    scaleView.tag = 1300;
    scaleView.backgroundColor = kAppCustomMainColor;
    scaleView.layer.cornerRadius = scaleH/2.0;
    scaleView.clipsToBounds = YES;
    
    [scaleBgView addSubview:scaleView];
    //数据
    self.dataLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:[UIColor colorWithHexString:@"#7a7a7a"]
                                                font:13.0];
    
    self.dataLbl.numberOfLines = 0;
    
    [self.statisticsView addSubview:self.dataLbl];
    [self.dataLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(textLbl.mas_left);
        make.top.equalTo(scaleBgView.mas_bottom).offset(15);
    }];
    
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
    
    [self.statisticsView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@10);
    }];
    
}

- (void)initApplicationView {
    
    self.applicationView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bannerView.yy, kScreenWidth, kHeight(500))];
    self.applicationView.backgroundColor = kWhiteColor;
    [self addSubview:self.applicationView];
    
    UIImageView *iconIV = [[UIImageView alloc] init];
    
    iconIV.backgroundColor = kAppCustomMainColor;

    [self.applicationView addSubview:iconIV];
//    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(@15);
//        make.top.equalTo(@14);
//        make.width.equalTo(@3);
//        make.height.equalTo(@11);
//    }];
    
    //商业应用
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextBlack
                                                    font:16.0];
    textLbl.text = [LangSwitcher switchLang:@"推荐应用" key:nil];
    [self.applicationView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@15);
    }];
    
    //topLine
//    UIView *topLine = [[UIView alloc] init];
//
//    topLine.backgroundColor = kLineColor;
//
//    [self.applicationView addSubview:topLine];
//    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.right.equalTo(@0);
//        make.top.equalTo(@40);
//        make.height.equalTo(@0.5);
//    }];
    
    NSArray *textArr = @[@"发红包",
                         @"首创玩法",
                         @"量化理财",
                         @"余币宝"];
    
    [textArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"==========%ld",idx);
        CGFloat width = (kScreenWidth-60)/3;
        
//        UIView *contentView = [UIView new];
//        contentView.backgroundColor = kHexColor(@"#EFF5FE");
        UIButton *btn = [UIButton buttonWithTitle:nil
                                            titleColor:kWhiteColor
                                       backgroundColor:kClearColor
                                             titleFont:15.0];
        self.tempBtn = btn;

        UIImageView *imageView= [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [btn addSubview:imageView];
//        [btn setImage:kImage(obj) forState:UIControlStateNormal];
//        [btn setBackgroundImage:kImage(obj) forState:UIControlStateNormal];
        [btn setBackgroundColor: kHexColor(@"#EFF5FE") forState:UIControlStateNormal];
        btn.contentMode = UIViewContentModeScaleAspectFit;
        btn.tag = 1500 + idx;
//        btn.backgroundColor = [UIColor redColor];
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *textLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:18];
        [btn addSubview:textLab];
        textLab.text = [LangSwitcher switchLang:obj key:nil];
//        UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickButton:)];
//        [contentView addGestureRecognizer:ta]
        UILabel *introfucec = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:12];
        [btn addSubview:introfucec];
        introfucec.numberOfLines = 0;
        introfucec.text = [LangSwitcher switchLang:obj key:nil];
        
        [self.applicationView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (idx == 0) {
                make.top.equalTo(@(idx * 90 +40));

            }else if (idx == 1)
            {
                
                make.top.equalTo(@(kHeight(130)));

                
            }
            else if (idx == 2)
            {
                
                make.top.equalTo(@(kHeight(220)));

                
            }
            else if (idx == 3)
            {
                
                make.top.equalTo(@(kHeight(310)));

                
            }
            make.width.equalTo(@(kScreenWidth-30));
            make.height.equalTo(@90);
        }];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btn.mas_top).offset(20);
            make.left.equalTo(btn.mas_left).offset(38);
            make.width.equalTo(@55);
            make.height.equalTo(@58);

        }];
        [textLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_top).offset(10);
            make.width.equalTo(@200);
            make.left.equalTo(imageView.mas_right).offset(28);
        }];
        
        [introfucec mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(textLab.mas_bottom).offset(6);
            
            make.left.equalTo(textLab.mas_left);
           
        }];
        if (idx == 0) {
            
            imageView.image = kImage(@"红包-1");
            introfucec.text = [LangSwitcher switchLang:@"将数字货币塞入其中,发给好友" key:nil];
        }else if (idx == 1)
        {
            imageView.image = kImage(@"THA矿山");
            introfucec.text = [LangSwitcher switchLang:@"将数字货币塞入其中,发给好友" key:nil];

        }else if (idx == 2)
        {
            imageView.image = kImage(@"量化理财");
            introfucec.text = [LangSwitcher switchLang:@"活期理财产品,存取方便,年化率" key:nil];

            
        }else if (idx == 3)
        {
            
            imageView.image = kImage(@"余币包");
            introfucec.text = [LangSwitcher switchLang:@"玩法" key:nil];

        }
        
//        [btn setTitleBottom];
    }];
    
}

#pragma mark - Events
- (void)lookFlowList:(UITapGestureRecognizer *)tapGR {
    
    if (_headerBlock) {
        
        _headerBlock(HomeEventsTypeStatistics, 0);
    }
}

- (void)clickButton:(UIButton *)sender {
    
    NSInteger index = sender.tag - 1500;
    
    if (_headerBlock) {
        
        _headerBlock(index+2, 0);
    }
}

#pragma mark - Setting
- (void)setBanners:(NSMutableArray<BannerModel *> *)banners {
    
    _banners = banners;
    
    NSMutableArray *imgUrls = [NSMutableArray array];
    
    [banners enumerateObjectsUsingBlock:^(BannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.pic) {
            
            [imgUrls addObject:obj.pic];
        }
    }];
    self.bannerView.imgUrls = imgUrls;
    
}

- (void)setCountInfo:(CountInfoModel *)countInfo {
    
    _countInfo = countInfo;
    
    UIView *scaleBgView = [self viewWithTag:1301];

    NSString *initialBalance = [CoinUtil convertToRealCoin:countInfo.totalCount coin:kOGC];
    
    NSString *useBalance = [CoinUtil convertToRealCoin:countInfo.useCount coin:kOGC];

    CGFloat scaleH = 7;
    CGFloat lineW = 0;
    if ([initialBalance doubleValue] != 0) {
        lineW = [useBalance doubleValue]/[initialBalance doubleValue]*scaleBgView.width;
    }
    
    
//    CGFloat lineW = [useBalance doubleValue]/[initialBalance doubleValue]*SCREEN_WIDTH - 30;
    
    UIView *scaleView = [self viewWithTag:1300];
    
    scaleView.frame = CGRectMake(0, 0, lineW, scaleH);

//    CGFloat rate = [countInfo.useRate doubleValue]*100;
    
    NSString *data = [NSString stringWithFormat:@"总量: %@   已投: %@   占比: %@%%", initialBalance, useBalance, countInfo.useRate];
    
    self.dataLbl.text = [LangSwitcher switchLang:data key:nil];;

}

@end
