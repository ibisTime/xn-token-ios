//
//  RecodeDetailVC.m
//  Coin
//
//  Created by shaojianfei on 2018/8/18.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "RecodeDetailVC.h"
#import "RecodeDetailView.h"
@interface RecodeDetailVC ()

@property (nonatomic , strong) RecodeDetailView *recodeView;

@end

@implementation RecodeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTop];
    RecodeDetailView *titleView = [[RecodeDetailView alloc] init];
    titleView.backgroundColor = kWhiteColor;
    self.recodeView = titleView;
    titleView.model = self.moneyModel;
    [self.view addSubview:titleView];
    titleView.layer.borderWidth = 0.5;
    titleView.layer.borderColor = [UIColor colorWithRed:62/255.0 green:58/255.0 blue:57/255.0 alpha:0.16].CGColor;
    titleView.layer.cornerRadius = 4;
    titleView.clipsToBounds = YES;
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@(kHeight(563)));
        
    }];
    
    
}

- (void)initTop {
    self.view.backgroundColor = kWhiteColor;
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    topView.backgroundColor = kHexColor(@"#0848DF");
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(kHeight(66)));
    }];
    
   
    
}


@end
