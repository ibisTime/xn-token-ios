//
//  GoodMallVC.m
//  Coin
//
//  Created by 蔡卓越 on 2018/3/29.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "GoodMallVC.h"
//V
#import "TLPlaceholderView.h"

@interface GoodMallVC ()
//
@property (nonatomic, strong) TLPlaceholderView *placeholderView;

@end

@implementation GoodMallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [LangSwitcher switchLang:@"THA星球" key:nil];
    //敬请期待
    [self initPlaceHolderView];
}

#pragma mark - Init
- (void)initPlaceHolderView {
    
    self.placeholderView = [TLPlaceholderView placeholderViewWithImage:nil text:[LangSwitcher switchLang:@"暂未开放, 敬请期待!" key:nil] textColor:kHexColor(@"#fe8472")];
    
    [self.view addSubview:self.placeholderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
