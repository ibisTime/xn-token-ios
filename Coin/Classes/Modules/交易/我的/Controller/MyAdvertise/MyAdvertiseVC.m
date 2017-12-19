//
//  MyAdvertiseVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "MyAdvertiseVC.h"

#import "CoinHeader.h"

#import "SelectScrollView.h"

#import "MyAdvertiseListVC.h"

@interface MyAdvertiseVC ()

@property (nonatomic, strong) SelectScrollView *selectScrollView;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation MyAdvertiseVC

//
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [LangSwitcher switchLang:@"我发布的" key:nil];
    [self initSelectScrollView];
    [self addSubViewController];
    
}

#pragma mark - Init
- (void)initSelectScrollView {
    
    self.titles = @[
                    [LangSwitcher switchLang:@"待发布" key:nil],
                    [LangSwitcher switchLang:@"已发布" key:nil]
                    ];
    
    self.selectScrollView = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) itemTitles:self.titles];
    [self.view addSubview:self.selectScrollView];
    
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        MyAdvertiseListVC *childVC = [MyAdvertiseListVC new];
        
        switch (i) {
                
            case 0: {
                
                childVC.type = MyAdvertiseTypeDraft;

            }  break;
                
            case 1: {
                
                childVC.type = MyAdvertiseTypeDidPublish;
                
            }  break;
                
        }
        
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 45);
        
        [self addChildViewController:childVC];
        
        [_selectScrollView.scrollView addSubview:childVC.view];
        
    }
}

@end
