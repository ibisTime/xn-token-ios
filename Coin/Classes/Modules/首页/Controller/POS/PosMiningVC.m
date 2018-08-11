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
#import "StoreTableView.h"
#import "StoreModel.h"
#import "UIBarButtonItem+convience.h"
#import "TLMakeMoney.h"
#import "QuestionModel.h"
@interface PosMiningVC ()<RefreshDelegate>
//
@property (nonatomic, strong) TLPlaceholderView *placeholderView;
@property (nonatomic, strong) UILabel *titleLable;

@property (nonatomic, strong) UILabel *contentLab;

@property (nonatomic, strong) TLMakeMoney *tableView;

@end

@implementation PosMiningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [LangSwitcher switchLang:@"量化理财" key:nil];
    //敬请期待
    [self initPlaceHolderView];
    
    QuestionModel *m = [QuestionModel new];
    m.Description = @"杭州";
    m.reappear = @"THA蓄势待发";
    QuestionModel *m1 = [QuestionModel new];
    m1.Description = @"北京";
    m1.reappear = @"wanChina";
    self.tableView.questions = @[m,m1];
    [self.tableView reloadData];
    
//    [UIBarButtonItem addr]
    
//    self.tableView.
}

- (TLMakeMoney *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[TLMakeMoney alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        //        _tableView.placeHolderView = self.placeHolderView;
        _tableView.refreshDelegate = self;
        
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 15, 0, 15));
        }];
        
    }
    return _tableView;
}

#pragma mark - Init
- (void)initPlaceHolderView {
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
    
    
    
//    self.titleLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
//    [self.view addSubview:self.titleLable];
//    self.titleLable.numberOfLines = 0;
//    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@(kHeight(20)));
//        make.right.equalTo(@-10);
//        make.left.equalTo(@10);
//
//    }];
//    self.titleLable.text = @"THA Wallet为用户提供多种类型的优质理财产品，用户可以使用比特币、以太坊等数字货币购买理财产品而获得收益";
//    self.contentLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
//    [self.view addSubview:self.contentLab];
//    self.contentLab.numberOfLines = 0;
//    self.contentLab.text = @"THA Wallet provides users with a variety of quality management products, users can use Bitcoin, Ethernet and other digital currencies to buy money products and gain income.";
//    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.titleLable.mas_bottom).offset(20);
//        make.right.equalTo(@-10);
//        make.left.equalTo(@10);
//    }];
    
//    self.placeholderView = [TLPlaceholderView placeholderViewWithImage:nil text:[LangSwitcher switchLang:@"暂未开放, 敬请期待!" key:nil] textColor:kHexColor(@"#fe8472")];
    
//    [self.view addSubview:self.placeholderView];
//    self.placeholderView = [TLPlaceholderView placeholderViewWithImage:nil text:[LangSwitcher switchLang:@"敬请期待!" key:nil] textColor:kTextColor];
//    
//    [self.view addSubview:self.placeholderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
