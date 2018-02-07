//
//  MyAdvertiseVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "MyAdvertiseVC.h"

#import "CoinHeader.h"
#import "CoinService.h"
#import "SelectScrollView.h"
#import "CoinChangeView.h"
#import "MyAdvertiseListVC.h"
#import "FilterView.h"

@interface MyAdvertiseVC ()

@property (nonatomic, strong) SelectScrollView *selectScrollView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) FilterView *filterPicker;


@property (nonatomic, strong) MyAdvertiseListVC *unPublishVC;
@property (nonatomic, strong) MyAdvertiseListVC *publishedVC;
@property (nonatomic, strong) CoinChangeView *topTitleView;


@end

@implementation MyAdvertiseVC

//
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CoinChangeView *topTitleView = [[CoinChangeView alloc] initWithFrame:CGRectMake(0, 0, 140, 40)];
    topTitleView.title = [self titleWithCoin:[CoinService shareService].currentCoin];
    self.navigationItem.titleView = topTitleView;
    self.topTitleView = topTitleView;
    [self initSelectScrollView];
    [self addSubViewController];
    
     [topTitleView addTarget:self
                        action:@selector(changeCoin)
              forControlEvents:UIControlEventTouchUpInside];
    
}

- (NSString *)titleWithCoin:(NSString *)currentCoin {
    
    return [NSString stringWithFormat:@"我的广告（%@）",currentCoin];
    
}

- (void)changeCoin {
    
    [self.filterPicker show];
    
}

#pragma mark- 币种切换事件
- (FilterView *)filterPicker {
    
    if (!_filterPicker) {
        
        CoinWeakSelf;
        
        NSArray *textArr = [CoinUtil shouldDisplayCoinArray];
        
        //        NSArray *typeArr = @[@"", @"charge", @"withdraw", @"buy", @"sell"];
        
        _filterPicker = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _filterPicker.title = @"请选择货币类型";
        _filterPicker.tagNames = textArr;
        _filterPicker.selectBlock2 = ^(NSInteger index,NSString *tagName) {
            
           //进行界面刷新
            weakSelf.topTitleView.title = [weakSelf titleWithCoin:tagName];
            weakSelf.unPublishVC.coin = tagName;
            weakSelf.publishedVC.coin = tagName;
            [weakSelf.unPublishVC refresh];
            [weakSelf.publishedVC refresh];
       
        };
        
    }
    
    return _filterPicker;
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
                
                self.unPublishVC = childVC;
                childVC.type = MyAdvertiseTypeDraft;

            }  break;
                
            case 1: {
                
                self.publishedVC = childVC;
                childVC.type = MyAdvertiseTypeDidPublish;
                
            }  break;
                
        }
        
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 45);
        
        [self addChildViewController:childVC];
        [_selectScrollView.scrollView addSubview:childVC.view];
        
    }
}

@end
