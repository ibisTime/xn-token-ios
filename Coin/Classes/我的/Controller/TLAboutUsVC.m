//
//  TLAboutUsVC.m
//  Coin
//
//  Created by  tianlei on 2018/1/18.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TLAboutUsVC.h"
#import "UIColor+theme.h"
#import "NSString+Extension.h"
#import "AppColorMacro.h"
@interface TLAboutUsVC ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *versionLbl;
@property (nonatomic, strong) UILabel *versionLbl2;
@property (nonatomic, strong) UILabel *versionLbl3;

@property (nonatomic, strong) UILabel *lastVersionLbl;
@property (nonatomic, strong) UILabel *banQuanLbl;
@property (nonatomic, strong) UIView *phoneView;
@property (nonatomic, strong) UILabel *phoneNumber;

@end

@implementation TLAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [LangSwitcher switchLang:@"关于我们" key:nil];
    
    [self setUpUI];
    [self addLayout];
    [self data];
    
}

//
- (void)data {
    
    
    self.iconImageView.image = [UIImage imageNamed:@"icon圆角"];
    self.nameLbl.text = @"THA";
    self.versionLbl.text = [LangSwitcher switchLang:[NSString stringWithFormat:@"V%@",[NSString appVersionString]] key:nil];
//    self.versionLbl.text = [LangSwitcher switchLang:@"钱包是一款全新的数字货币钱包" key:nil];
//    self.versionLbl2.text = [LangSwitcher switchLang:@"为你提高安全丶便捷的一站式管理方案" key:nil];
//    self.versionLbl3.text = [LangSwitcher switchLang:@"服务时间:  9:00 - 18:00 " key:nil];
//    self.banQuanLbl.text = [LangSwitcher switchLang:@"联系电话" key:nil];
//    self.phoneNumber.text = [LangSwitcher switchLang:@"0571-8765650" key:nil];
//
//    //
//    NSString *at = @"@";
    
    
    
}

- (NSString *)currentYear {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy";
    return [formatter stringFromDate:[NSDate new]];
    
}

//
- (void)setUpUI {
    
    //
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    //
    self.iconImageView = [[UIImageView alloc] init];
    [self.bgView  addSubview:self.iconImageView];
    self.iconImageView.layer.cornerRadius = 10;
    self.iconImageView.layer.masksToBounds = YES;
    
    //
    self.nameLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentCenter
                           backgroundColor:[UIColor whiteColor]
                                      font:[UIFont systemFontOfSize:15]
                                 textColor:[UIColor textColor]];
    [self.bgView addSubview:self.nameLbl];
    
    //
    self.versionLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor whiteColor]
                                         font:[UIFont systemFontOfSize:15]
                                    textColor:kTextColor];
    [self.bgView addSubview:self.versionLbl];
    
    self.versionLbl2 = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor whiteColor]
                                         font:[UIFont systemFontOfSize:12]
                                    textColor:kHexColor(@"#808080")];
    [self.bgView addSubview:self.versionLbl2];
    
    self.versionLbl3 = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor whiteColor]
                                          font:[UIFont systemFontOfSize:12]
                                     textColor:kHexColor(@"#808080")];
    [self.bgView addSubview:self.versionLbl3];
    
    //
    self.phoneView = [[UIView alloc] init];
    self.phoneView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.phoneView];
    
    self.banQuanLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentRight
                              backgroundColor:[UIColor whiteColor]
                                         font:[UIFont systemFontOfSize:15]
                                    textColor:kHexColor(@"#333333")];
    [self.phoneView addSubview:self.banQuanLbl];
    
    
    self.phoneNumber = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentLeft
                              backgroundColor:[UIColor whiteColor]
                                         font:[UIFont systemFontOfSize:12]
                                    textColor:kHexColor(@"#999999")];
    [self.phoneView addSubview:self.phoneNumber];
    self.banQuanLbl.numberOfLines = 0;
    
}

- (void)addLayout {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bgView.mas_top).offset(157.5);
        make.width.height.mas_equalTo(75);
        make.centerX.equalTo(self.bgView.mas_centerX);
        
    }];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.iconImageView.mas_bottom).offset(20);
        make.centerX.equalTo(self.bgView);
        
    }];
    
    [self.versionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameLbl.mas_bottom).offset(12.5);
        make.centerX.equalTo(self.bgView);
        
    }];
    [self.versionLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.versionLbl.mas_bottom).offset(6);
        make.centerX.equalTo(self.bgView);
        
    }];
    [self.versionLbl3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.versionLbl2.mas_bottom).offset(17);
        make.centerX.equalTo(self.bgView);
        
    }];
    
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.versionLbl3.mas_bottom).offset(40);
        make.height.equalTo(@50);
        make.width.equalTo(@(kScreenWidth));
        make.centerX.equalTo(self.bgView);
        
    }];
    [self.banQuanLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.phoneView.mas_left).offset(15);
        make.centerY.equalTo(self.phoneView);
        
    }];
    [self.phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.phoneView.mas_right).offset(-15);
        make.centerY.equalTo(self.phoneView);
        
    }];
    
    
}


@end
