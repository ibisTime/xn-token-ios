//
//  MineHeaderView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "MineHeaderView.h"
#import "CoinHeader.h"

@interface MineHeaderView()

//背景
@property (nonatomic, strong) UIImageView *bgIV;

@end

@implementation MineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //
        [self initSubvies];
        //购买跟出售
        //        [self initBuyAndSell];
    }
    return self;
}

#pragma mark - Init
- (void)initSubvies {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgIV = [[UIImageView alloc] init];
    
    bgIV.image = kImage(@"我的-背景");
    bgIV.contentMode = UIViewContentModeScaleToFill;
    
    [self addSubview:bgIV];
    [bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(@0);
        make.height.equalTo(@(160 + kStatusBarHeight));
        
    }];
    
    self.bgIV = bgIV;
    
    CGFloat imgWidth = 68;
    
    self.photoBtn = [UIButton buttonWithTitle:@"" titleColor:kAppCustomMainColor backgroundColor:kWhiteColor titleFont:30 cornerRadius:imgWidth/2.0];
    
    [self.photoBtn addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    self.photoBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:self.photoBtn];
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.equalTo(@(imgWidth));
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(@(30));
        
    }];
    
    //昵称
    self.nameLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:15.0];
    
    [self addSubview:self.nameLbl];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.photoBtn.mas_top).offset(10);
        make.left.equalTo(self.photoBtn.mas_right).offset(15);
        
    }];
    
    //手机号
    self.mobileLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:15.0];
    
    [self addSubview:self.mobileLbl];
    [self.mobileLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.bottom.equalTo(self.photoBtn.mas_bottom).offset(-10);
        
    }];
    
    //用户等级
    self.levelBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"代理人" key:nil]
                                   titleColor:kWhiteColor
                              backgroundColor:kClearColor
                                    titleFont:10.0
                                 cornerRadius:1.5];
    
    self.levelBtn.layer.borderWidth = 0.5;
    self.levelBtn.layer.borderColor = kWhiteColor.CGColor;
    [self.levelBtn setImage:kImage(@"代理人") forState:UIControlStateNormal];
    [self.levelBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
    [self.levelBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -4, 0, 0)];
    [self addSubview:self.levelBtn];
    
    [self.levelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_right).offset(5);
        make.centerY.equalTo(self.nameLbl.mas_centerY);
        make.height.equalTo(@15);
        make.width.equalTo(@53);
        
    }];
    
    self.levelBtn.hidden = YES;
    
    //交易、好评跟信任
    //    self.dataLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:12.0];
    //
    //    [self addSubview:self.dataLbl];
    //    [self.dataLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.centerX.equalTo(self.photoBtn.mas_centerX);
    //        make.top.equalTo(self.nameLbl.mas_bottom).offset(15);
    //
    //    }];
}

- (void)initBuyAndSell {
    
    NSArray *textArr = @[[LangSwitcher switchLang:@"我要购买" key:nil],
                         [LangSwitcher switchLang:@"我要出售" key:nil]];
    
    NSArray *imgArr = @[@"我要购买", @"我要出售"];
    
    CGFloat btnW = kScreenWidth/2.0;
    
    __block UIButton *lastBtn;
    
    [textArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *btn = [UIButton buttonWithTitle:textArr[idx] titleColor:kTextColor backgroundColor:kWhiteColor titleFont:13.0];
        
        [btn setImage:kImage(imgArr[idx]) forState:UIControlStateNormal];
        
        btn.tag = 1100 + idx;
        
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.bgIV.mas_bottom);
            make.left.equalTo(@(idx*btnW));
            make.width.equalTo(@(btnW));
            make.height.equalTo(@55);
            
        }];
        
        
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -30)];
        
        lastBtn = btn;
        
    }];
    
    UIView *lineView = [[UIView alloc] init];
    
    lineView.backgroundColor = kLineColor;
    
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.height.equalTo(@24);
        make.width.equalTo(@0.5);
        make.centerY.equalTo(lastBtn.mas_centerY);
        
    }];
    
}

#pragma mark - Events
- (void)clickButton:(UIButton *)sender {
    
    NSInteger index = sender.tag - 1100;
    
    MineHeaderSeletedType type = index == 0 ? MineHeaderSeletedTypeBuy: MineHeaderSeletedTypeSell;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:)]) {
        
        [self.delegate didSelectedWithType:type];
        
    }
    
}

- (void)selectPhoto:(UITapGestureRecognizer *)tapGR {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:)]) {
        
        [self.delegate didSelectedWithType:MineHeaderSeletedTypePhoto];
    }
    
}

@end

