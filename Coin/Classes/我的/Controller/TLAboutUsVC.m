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

@interface TLAboutUsVC ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *versionLbl;

@property (nonatomic, strong) UILabel *lastVersionLbl;
@property (nonatomic, strong) UILabel *banQuanLbl;

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
    
    
    self.iconImageView.image = [UIImage imageNamed:@"icon"];
    self.nameLbl.text = [LangSwitcher switchLang:@"OGC钱包" key:nil];
    self.versionLbl.text = [NSString stringWithFormat:@"v%@",[NSString appVersionString]];
    //
    NSString *at = @"@";
    self.banQuanLbl.text = [NSString stringWithFormat:@"www.orangecoin.io\n%@%@OGC版权所有",at,[self currentYear]];
    
    
    
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
                                      font:[UIFont systemFontOfSize:16]
                                 textColor:[UIColor textColor]];
    [self.bgView addSubview:self.nameLbl];
    
    //
    self.versionLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor whiteColor]
                                         font:[UIFont systemFontOfSize:12]
                                    textColor:[UIColor textColor2]];
    [self.bgView addSubview:self.versionLbl];
    
    //
    self.banQuanLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor whiteColor]
                                         font:[UIFont systemFontOfSize:12]
                                    textColor:[UIColor textColor2]];
    [self.bgView addSubview:self.banQuanLbl];
    self.banQuanLbl.numberOfLines = 0;
    
}

- (void)addLayout {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bgView.mas_top).offset(40);
        make.width.height.mas_equalTo(75);
        make.centerX.equalTo(self.bgView.mas_centerX);
        
    }];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.iconImageView.mas_bottom).offset(20);
        make.centerX.equalTo(self.bgView);
        
    }];
    
    [self.versionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameLbl.mas_bottom).offset(10);
        make.centerX.equalTo(self.bgView);
        
    }];
    
    [self.banQuanLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-30);
        make.centerX.equalTo(self.bgView);
        
    }];
    
    
}


@end
