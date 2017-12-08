//
//  HomePageHeaderView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/12/7.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "HomePageHeaderView.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import <UIButton+WebCache.h>
#import "UILabel+Extension.h"
#import "NSString+Extension.h"
#import "UIButton+EnLargeEdge.h"
#import "TLUser.h"

@interface HomePageHeaderView ()

//头像
@property (nonatomic, strong) UIButton *photoBtn;
//昵称
@property (nonatomic, strong) UILabel *nameLbl;
//交易次数
@property (nonatomic, strong) UILabel *tradeNumLbl;

@end

@implementation HomePageHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //背景
        [self initBackgroundView];
        //内容
        [self initContentView];
        
    }
    return self;
}

#pragma mark - Init
- (void)initBackgroundView {
    
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"个人主页-背景")];
    
    [self addSubview:iconIV];
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@(kWidth(86 + kNavigationBarHeight)));
        
    }];
    
    self.bgIV = iconIV;
    
    //返回
    UIButton *backBtn = [UIButton buttonWithImageName:@"返回-白色"];
    
    [backBtn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    
    [backBtn setEnlargeEdgeWithTop:0 right:100 bottom:0 left:7];
    
    [self addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(kNavigationBarHeight - 44));
        make.left.equalTo(@7);
        make.width.equalTo(@10);
        make.height.equalTo(@44);
        
    }];
    
    //个人主页
    UILabel *titleLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:18.0];
    
    titleLbl.text = @"个人主页";
    
    titleLbl.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(@(kNavigationBarHeight - 44));
        make.height.equalTo(@44);
        
    }];
    
}

- (void)initContentView {
    
    UIView *whiteView = [[UIView alloc] init];
    
    whiteView.backgroundColor = kWhiteColor;
    
    [self addSubview:whiteView];
    
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(kWidth(14 + kNavigationBarHeight)));
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@(250));
        
    }];
    
    //头像
    CGFloat imgWidth = 66;
    
    self.photoBtn = [UIButton buttonWithTitle:@"" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:imgWidth/2.0 cornerRadius:imgWidth/2.0];
    
    self.photoBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [whiteView addSubview:self.photoBtn];
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(16));
        make.left.equalTo(@20);
        make.width.height.equalTo(@(imgWidth));
        
    }];
    
    //昵称
    self.nameLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:24.0];
    
    [whiteView addSubview:self.nameLbl];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@15);
        make.left.equalTo(self.photoBtn.mas_right).offset(15);
        
    }];
    
    //交易次数
    self.tradeNumLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    [whiteView addSubview:self.tradeNumLbl];
    [self.tradeNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.top.equalTo(self.nameLbl.mas_bottom).offset(10);
        
    }];
    
    //分割线
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kLineColor;
    
    [whiteView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.top.equalTo(self.photoBtn.mas_bottom).offset(16);
        make.height.equalTo(@0.5);
        
    }];
    
    //交易数据
    NSArray *textArr = @[@"交易次数", @"信任次数", @"好评率", @"历史交易"];
    
    CGFloat width = (kScreenWidth - 30)/(textArr.count*1.0);
    
    __block UILabel *lbl;
    
    [textArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:17.0];
        
        textLbl.tag = 1400 + idx;
        
        textLbl.numberOfLines = 0;
        
        textLbl.textAlignment = NSTextAlignmentCenter;
        
        [whiteView addSubview:textLbl];
        [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(idx*width));
            make.width.equalTo(@(width));
            make.height.equalTo(@50);
            make.top.equalTo(line.mas_bottom).offset(20);
            
        }];
        
        lbl = textLbl;
        
    }];
    
    //信任
    self.trustBtn = [UIButton buttonWithTitle:@"+ 信任" titleColor:kThemeColor backgroundColor:kClearColor titleFont:16.0 cornerRadius:2.5];
    
    self.trustBtn.layer.borderWidth = 0.5;
    self.trustBtn.layer.borderColor = kThemeColor.CGColor;
    
    [self.trustBtn addTarget:self action:@selector(trust:) forControlEvents:UIControlEventTouchUpInside];
    
    [whiteView addSubview:self.trustBtn];
    [self.trustBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(lbl.mas_bottom).offset(30);
        make.right.equalTo(self.mas_centerX).offset(-17.5);
        make.width.equalTo(@100);
        make.height.equalTo(@35);
        
    }];
    
    //黑名单
    self.blackListBtn = [UIButton buttonWithTitle:@"+ 黑名单" titleColor:kThemeColor backgroundColor:kClearColor titleFont:16.0 cornerRadius:2.5];
    
    self.blackListBtn.layer.borderWidth = 0.5;
    self.blackListBtn.layer.borderColor = kThemeColor.CGColor;
    
    [self.blackListBtn addTarget:self action:@selector(blackList:) forControlEvents:UIControlEventTouchUpInside];
    
    [whiteView addSubview:self.blackListBtn];
    [self.blackListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(lbl.mas_bottom).offset(30);
        make.left.equalTo(self.mas_centerX).offset(17.5);
        make.width.equalTo(@100);
        make.height.equalTo(@35);
        
    }];
    
}

#pragma mark - Setting
- (void)setAdvertise:(AdvertiseModel *)advertise {
    
    _advertise = advertise;
    
    TradeUserInfo *userInfo = advertise.user;
    
    //头像
    if (userInfo.photo) {
        
        [self.photoBtn setTitle:@"" forState:UIControlStateNormal];
        
        [self.photoBtn sd_setImageWithURL:[NSURL URLWithString:[userInfo.photo convertImageUrl]] forState:UIControlStateNormal];
        
    } else {
        
        NSString *nickName = userInfo.nickname;
        
        NSString *title = [nickName substringToIndex:1];
        
        [self.photoBtn setTitle:title forState:UIControlStateNormal];
        
    }
    
    self.nameLbl.text = userInfo.nickname;


}

- (void)setRelation:(UserRelationModel *)relation {
    
    _relation = relation;
    
    NSArray *textArr = @[@"交易次数", @"信任次数", @"好评率", @"历史交易"];
    
    NSArray *numArr = @[[NSString stringWithFormat:@"%ld", relation.jiaoYiCount], [NSString stringWithFormat:@"%ld", relation.beiXinRenCount], relation.goodCommentRate, relation.tradeAmount];
    
    [textArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel *lbl = [self viewWithTag:1400+idx];
        
        [lbl labelWithString:[NSString stringWithFormat:@"%@\n%@", numArr[idx], obj] title:obj font:Font(12.0) color:kTextColor2 lineSpace:5];
        
        lbl.textAlignment = NSTextAlignmentCenter;
        
    }];
    
    NSString *betweenTradeTimes = [NSString stringWithFormat:@"和Ta交易过%@次", relation.betweenTradeTimes];
    
    [self.tradeNumLbl labelWithString:betweenTradeTimes title:relation.betweenTradeTimes font:Font(14.0) color:kThemeColor];
    //是否信任
    self.isTrust = [relation.isTrust integerValue] == 0 ? NO: YES;
    //是否黑名单
    self.isBlack = [relation.isAddBlackList integerValue] == 0 ? NO: YES;
    
}

- (void)setIsTrust:(BOOL)isTrust {
    
    _isTrust = isTrust;
    
    NSString *title = isTrust ? @"取消信任": @"+ 信任";
    
    [self.trustBtn setTitle:title forState:UIControlStateNormal];

}

- (void)setIsBlack:(BOOL)isBlack {
    
    _isBlack = isBlack;
    
    NSString *title = isBlack ? @"取消黑名单": @"+ 黑名单";
    
    [self.blackListBtn setTitle:title forState:UIControlStateNormal];

}

- (void)setUserId:(NSString *)userId {
    
    _userId = userId;
    
    self.trustBtn.hidden = [self.advertise.userId isEqualToString:userId] ? YES: NO;
    
    self.blackListBtn.hidden = [self.advertise.userId isEqualToString:userId] ? YES: NO;

}

#pragma mark - Events
- (void)trust:(UIButton *)sender {
    
    HomePageType type = self.isTrust == NO ? HomePageTypeTrust: HomePageTypeCancelTrust;

    if (self.pageBlock) {
        
        self.pageBlock(type);
    }
}

- (void)blackList:(UIButton *)sender {
    
    HomePageType type = self.isBlack == NO ? HomePageTypeBlackList: HomePageTypeCancelBlackList;

    if (self.pageBlock) {
        
        self.pageBlock(type);
    }
}

- (void)clickBack {
    
    if (self.pageBlock) {
        
        self.pageBlock(HomePageTypeBack);
    }
}

@end
