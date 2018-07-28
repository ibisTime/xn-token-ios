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
    
    self.backgroundColor = kBackgroundColor;
    
    UIImageView *bgIV = [[UIImageView alloc] init];
    
    bgIV.image = kImage(@"背景");
    bgIV.contentMode = UIViewContentModeScaleToFill;
    
    [self addSubview:bgIV];
    [bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(@0);
        make.height.equalTo(@((kHeight(156))));
        
    }];
    
    self.bgIV = bgIV;
    
    UILabel *titleLab  = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:18.0];
    [self.bgIV addSubview:titleLab];
    titleLab.text = [LangSwitcher switchLang:@"我的" key:nil];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgIV.mas_centerX);
        make.top.equalTo(self.bgIV.mas_top).offset(kStatusBarHeight+9);
    }];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = kWhiteColor;
    titleView.layer.cornerRadius = 4.0;
    titleView.clipsToBounds = YES;
    [self addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(self.mas_top).offset(kStatusBarHeight+44);
        make.right.equalTo(@-15);
        make.height.equalTo(@(kHeight(140)));
    }];
    CGFloat imgWidth = 66;

//    self.photoBtn = [UIButton buttonWithTitle:nil titleColor:kAppCustomMainColor backgroundColor:kWhiteColor titleFont:30 cornerRadius:imgWidth/2.0];
    self.photoBtn = [UIButton buttonWithImageName:@"头像" cornerRadius:imgWidth/2.0];
    [self.photoBtn setBackgroundImage:kImage(@"头像") forState:UIControlStateNormal];
    [self.photoBtn addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    self.photoBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [titleView addSubview:self.photoBtn];
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(imgWidth));
        make.height.equalTo(@64);

        make.right.equalTo(@(-20));
        make.top.equalTo(@(27));

    }];
    
    //昵称
    self.nameLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:30.0];
    self.nameLbl.userInteractionEnabled = YES;
    [titleView addSubview:self.nameLbl];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(titleView.mas_top).offset(25);
        make.left.equalTo(titleView.mas_left).offset(20);
        
    }];
    UIImageView *phone = [[UIImageView alloc] init];
    phone.image = kImage(@"手机");
    [titleView addSubview:phone];
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLbl.mas_left);
        make.top.equalTo(@(kHeight(75)));
        make.width.equalTo(@10);
        make.height.equalTo(@14);

    }];
    //手机号
    self.mobileLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#666666") font:14.0];
    
    [titleView addSubview:self.mobileLbl];
    [self.mobileLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(phone.mas_right).offset(5);
        make.top.equalTo(@(kHeight(75)));

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

