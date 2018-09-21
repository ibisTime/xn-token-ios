//
//  StoreDetailHeaderView.m
//  OGC
//
//  Created by 蔡卓越 on 2018/3/14.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "StoreDetailHeaderView.h"
//Marco
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Category
#import "NSString+CGSize.h"
#import "NSString+Extension.h"
#import "UILabel+Extension.h"
//V
#import "TLBannerView.h"

@interface StoreDetailHeaderView()
//轮播图
@property (nonatomic,strong) TLBannerView *bannerView;
//内容
@property (nonatomic, strong) UIView *contentView;
//店铺名称
@property (nonatomic, strong) UILabel *nameLbl;
//广告语
@property (nonatomic, strong) UILabel *sloganLbl;
//电话
@property (nonatomic, strong) UILabel *mobileLbl;
//地址
@property (nonatomic, strong) UILabel *addressLbl;
//line
@property (nonatomic, strong) UIView *line;

@end

@implementation StoreDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (TLBannerView *)bannerView {
    
    if (!_bannerView) {
        
        _bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kCarouselHeight)];
        
        [self addSubview:_bannerView];
    }
    return _bannerView;
}

- (void)initSubviews {
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bannerView.yy, kScreenWidth, 100 + 15)];
    
    self.contentView.backgroundColor = kWhiteColor;
    
    [self addSubview:self.contentView];
    //店铺名称
    self.nameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor
                                                font:15.0];
    self.nameLbl.numberOfLines = 0;
    
    [self.contentView addSubview:self.nameLbl];
    //广告语
    self.sloganLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor2
                                                font:13.0];
    self.sloganLbl.numberOfLines = 0;

    [self.contentView addSubview:self.sloganLbl];
    //bottomLine
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kLineColor;
    
    [self.contentView addSubview:line];
    self.line = line;
    //电话
    self.mobileLbl = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:kTextColor
                                                  font:13.0];
    [self.contentView addSubview:self.mobileLbl];
    //地址
    self.addressLbl = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:kTextColor
                                                  font:13.0];
    
    self.addressLbl.numberOfLines = 0;

    [self.contentView addSubview:self.addressLbl];
}

- (void)setSubviewLayout {
    
    CGFloat leftMargin = 15;
    
    //店铺名称
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(@(leftMargin));
        make.right.equalTo(@(-leftMargin));
        make.top.equalTo(@(leftMargin));
    }];
    //广告语
    [self.sloganLbl mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.nameLbl.mas_left);
        make.right.equalTo(@(-leftMargin));
        make.top.equalTo(self.nameLbl.mas_bottom).offset(10);
    }];
    //line
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(@0);
        make.top.equalTo(self.sloganLbl.mas_bottom).offset(15);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@0.5);
    }];
    //电话
    [self.mobileLbl mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.nameLbl.mas_left);
        make.top.equalTo(self.line.mas_bottom).offset(15);
    }];
    //地址
    [self.addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.nameLbl.mas_left);
        make.right.equalTo(@(-leftMargin));
        make.top.equalTo(self.mobileLbl.mas_bottom).offset(10);
    }];
}

#pragma mark - Setting
- (void)setStore:(StoreModel *)store {
    
    _store = store;
    
    self.bannerView.imgUrls = self.store.pics;
    self.nameLbl.text = [LangSwitcher switchLang:store.name key:nil];
    self.sloganLbl.text = [LangSwitcher switchLang:store.slogan key:nil];
    self.mobileLbl.text = [LangSwitcher switchLang:store.bookMobile key:nil];
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@", store.province, store.city, store.area, store.address];
    
    self.addressLbl.text = [LangSwitcher switchLang:address key:nil];
    //布局
    [self setSubviewLayout];
    //
    [self layoutIfNeeded];
    
    self.contentView.frame = CGRectMake(0, self.bannerView.yy, kScreenWidth, self.addressLbl.yy + 15);
    self.frame = CGRectMake(0, 0, kScreenWidth, self.contentView.yy);
    
}

@end
