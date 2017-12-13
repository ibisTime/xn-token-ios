//
//  SearchVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "SearchVC.h"

#import "CoinHeader.h"

#import "SelectScrollView.h"

#import "SearchUserVC.h"
#import "SearchAdvertiseVC.h"

@interface SearchVC ()

@property (nonatomic, strong) SelectScrollView *selectScrollView;

@property (nonatomic, strong) NSArray *titles;

@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"搜索";
    
    [self initSelectScrollView];
    
    [self addSubViewController];
}

#pragma mark - Init
- (void)initSelectScrollView {
    
    self.titles = @[
                    [LangSwitcher switchLang:@"搜广告" key:nil],
                    [LangSwitcher switchLang:@"搜用户" key:nil]
                    ];
    
    self.selectScrollView = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) itemTitles:self.titles];
    
    [self.view addSubview:self.selectScrollView];
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        if (i == 0) {
            
            SearchAdvertiseVC *childVC = [SearchAdvertiseVC new];
            
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 45);
            
            [self addChildViewController:childVC];
            
            [_selectScrollView.scrollView addSubview:childVC.view];
            
        } else {
            
            SearchUserVC *childVC = [SearchUserVC new];
            
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 45);
            
            [self addChildViewController:childVC];
            
            [_selectScrollView.scrollView addSubview:childVC.view];
        }
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
