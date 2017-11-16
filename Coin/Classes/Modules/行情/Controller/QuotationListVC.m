//
//  QuotationListVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "QuotationListVC.h"

#import "QuotationListTableView.h"

@interface QuotationListVC ()

@property (nonatomic, strong) QuotationListTableView *tableView;

@end

@implementation QuotationListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTableView];
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[QuotationListTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    
    [self.view addSubview:self.tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
