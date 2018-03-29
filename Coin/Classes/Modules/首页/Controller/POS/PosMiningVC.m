//
//  PosMiningVC.m
//  Coin
//
//  Created by 蔡卓越 on 2018/3/29.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "PosMiningVC.h"
//V
#import "TLPlaceholderView.h"

@interface PosMiningVC ()
//
@property (nonatomic, strong) TLPlaceholderView *placeholderView;

@end

@implementation PosMiningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [LangSwitcher switchLang:@"POS挖矿" key:nil];
    //敬请期待
    [self initPlaceHolderView];
}

#pragma mark - Init
- (void)initPlaceHolderView {
    
    self.placeholderView = [TLPlaceholderView placeholderViewWithImage:@"挖矿敬请期待" text:[LangSwitcher switchLang:@"暂未开放, 敬请期待!" key:nil] textColor:kHexColor(@"#ffb115")];
    
    [self.view addSubview:self.placeholderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
