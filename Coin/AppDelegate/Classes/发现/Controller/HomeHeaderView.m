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
#import <SDWebImage/UIImageView+WebCache.h>

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
            
            weakSelf.headerBlock(HomeEventsTypeBanner, index,nil);
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
    
    
    
    self.applicationView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bannerView.yy, kScreenWidth, kHeight(self.findModels.count *110))];
    self.applicationView.backgroundColor = kWhiteColor;
    [self addSubview:self.applicationView];
    
    UIImageView *iconIV = [[UIImageView alloc] init];
    
    iconIV.backgroundColor = kAppCustomMainColor;

    [self.applicationView addSubview:iconIV];

    
    //商业应用
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextBlack
                                                    font:16.0];
    textLbl.text = [LangSwitcher switchLang:@"推荐应用" key:nil];
    [self.applicationView addSubview:textLbl];
    textLbl.frame = CGRectMake(0, 0, SCREEN_WIDTH - 30, 50);
//    if (kDevice_Is_iPhoneX) {
//        [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.equalTo(@0);
//
//            make.top.equalTo(@5);
//        }];
//    }else{
//        [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.equalTo(@0);
//
//            make.top.equalTo(@5);
//        }];
//
//    }

    
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
    
//    NSArray *textArr = @[@"发红包",
//                         @"首创玩法",
//                         @"量化理财",
//                         @"余币宝"];
    
    [self.findModels enumerateObjectsUsingBlock:^(HomeFindModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {

        NSLog(@"==========%ld",idx);

        UIButton *btn = [UIButton buttonWithTitle:nil
                                            titleColor:kWhiteColor
                                       backgroundColor:kClearColor
                                             titleFont:15.0];
        self.tempBtn = btn;

        UIImageView *imageView= [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [btn addSubview:imageView];

        [btn setBackgroundColor: kHexColor(@"#EFF5FE") forState:UIControlStateNormal];
        btn.layer.cornerRadius=5;
        btn.layer.shadowOpacity = 0.22;// 阴影透明度
        btn.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
        btn.layer.shadowRadius=3;// 阴影扩散的范围控制
        btn.layer.shadowOffset = CGSizeMake(1, 1);// 阴影的范围
        btn.contentMode = UIViewContentModeScaleAspectFit;
        btn.tag = 1500 + idx;
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];


        UILabel *textLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:16];
        [btn addSubview:textLab];
        textLab.text = [LangSwitcher switchLang:obj.name key:nil];
//        UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickButton:)];
//        [contentView addGestureRecognizer:ta]

        UILabel *introfucec = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:12];
        [btn addSubview:introfucec];
//        introfucec.numberOfLines = 0;
        introfucec.text = [LangSwitcher switchLang:obj.slogan key:nil];
        
        [self.applicationView addSubview:btn];

        btn.frame = CGRectMake(0, 50 + idx%100 * 110, SCREEN_WIDTH - 30, 100);

//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            if (idx == 0) {
//                if (kDevice_Is_iPhoneX) {
//                    make.top.equalTo(@(kHeight(idx * 90) +40));
//
//                }else{
//                make.top.equalTo(@(kHeight(idx * 90) +30));
//                }
//            }else if (idx == 1)
//            {
//
//                make.top.equalTo(@(kHeight(130)));
//
//
//            }
//            else if (idx == 2)
//            {
//
//                make.top.equalTo(@(kHeight(230)));
//
//
//            }
//            else if (idx == 3)
//            {
//
//                make.top.equalTo(@(kHeight(330)));
//
//
//            }
//            else if (idx == 4)
//            {
//
//                make.top.equalTo(@(kHeight(430)));
//
//
//            }
//            make.width.equalTo(@(kScreenWidth-15));
//            make.height.equalTo(@(kHeight(90)));
//        }];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btn.mas_top).offset(22.5);
            make.left.equalTo(btn.mas_left).offset(20);
            make.width.equalTo(@55);
            make.height.equalTo(@58);

        }];
        introfucec.frame = CGRectMake(90, 0, SCREEN_WIDTH - 135, 0);
        introfucec.numberOfLines = 3;
        [introfucec sizeToFit];
        textLab.frame = CGRectMake(90, (100 - introfucec.frame.size.height - 8 - 10)/2, SCREEN_WIDTH - 135, 16);
        introfucec.frame = CGRectMake(90, textLab.yy + 5, SCREEN_WIDTH - 135, introfucec.frame.size.height);

        NSString *url = [self.findModels[idx].icon convertImageUrl];
        [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
        
        
//        [btn setTitleBottom];
    }];
    
}

#pragma mark - Events
- (void)lookFlowList:(UITapGestureRecognizer *)tapGR {
    
    if (_headerBlock) {
        
        _headerBlock(HomeEventsTypeStatistics, 0,nil);
    }
}

- (void)clickButton:(UIButton *)sender {
    
    NSInteger index = sender.tag - 1500;
    
    if (_headerBlock) {
        
        _headerBlock(index+2, 0,self.findModels[index]);
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


-(void)setFindModels:(NSArray<HomeFindModel *> *)findModels
{
    _findModels = findModels;
    
    [self initApplicationView];

    
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
