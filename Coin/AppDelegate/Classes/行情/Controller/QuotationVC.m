//
//  QuotationVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/12/7.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "QuotationVC.h"

#import "QuotationTableView.h"

#import "CoinQuotationModel.h"

@interface QuotationVC ()

@property (nonatomic, strong) QuotationTableView *tableView;

@property (nonatomic, strong) NSMutableArray <CoinQuotationModel *>*quotations;
//定时器
@property (nonatomic, strong) NSTimer *timer;
//
//@property (nonatomic, strong) TLPageDataHelper *helper;

@property (nonatomic, strong) UIView *footerHintView;

@end

@implementation QuotationVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //定时器刷起来
    [self startTimer];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self.timer invalidate];
    
    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"行情";
    
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    [self initTableView];
    
    [self tl_placeholderOperation];
    [self startTimer];
    
}

- (void)tl_placeholderOperation {
    
    //查询各个币种情况
    [self queryCoinQuotation:YES];
    
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[QuotationTableView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        
    }];
    
}

- (void)startTimer {
    
    //开启定时器,实时刷新
    self.timer = [NSTimer timerWithTimeInterval:30
                                         target:self
                                       selector:@selector(timeRefresh)
                                       userInfo:nil
                                        repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer
                              forMode:NSDefaultRunLoopMode];
    
}

- (void)timeRefresh {
    
    [self queryCoinQuotation:NO];
}

#pragma mark - Data
- (void)queryCoinQuotation:(BOOL)showProgress {
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"625293";
    http.isUploadToken = NO;
    if(showProgress) {
        http.showView = self.view;
    }
    [http postWithSuccess:^(id responseObject) {
        
        [self removePlaceholderView];
        self.quotations = [CoinQuotationModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        self.tableView.quotations = self.quotations;
        [self.tableView reloadData];
        self.tableView.tableFooterView = self.footerHintView;
        
    } failure:^(NSError *error) {
        
        [self addPlaceholderView];
        
    }];
    
    
}

#pragma mark- 底部提醒
- (UIView *)footerHintView {
    
    if (!_footerHintView) {
        
        _footerHintView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        UILabel *lbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:kBackgroundColor
                                          font:[UIFont systemFontOfSize:15]
                                     textColor:[UIColor textColor]];
        [_footerHintView addSubview:lbl];
        lbl.text = [LangSwitcher switchLang:@"更多行情，敬请期待..." key:nil];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    
    return _footerHintView;
    
}



@end
