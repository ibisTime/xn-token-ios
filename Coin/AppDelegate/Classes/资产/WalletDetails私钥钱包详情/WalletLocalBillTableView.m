//
//  WalletLocalBillTableView.m
//  Coin
//
//  Created by shaojianfei on 2018/6/15.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "WalletLocalBillTableView.h"
#import "CoinHeader.h"
#import "AppColorMacro.h"
#import "BillCell.h"
#import "LocalBillCell.h"
@interface  WalletLocalBillTableView()<UITableViewDelegate, UITableViewDataSource>


@end
static NSString *identifierCell = @"BillListCell";
static NSString *identifierLocalBillCell = @"LocalBillCell";


@implementation WalletLocalBillTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        self.backgroundColor = kBackgroundColor;
        
        [self registerClass:[BillCell class] forCellReuseIdentifier:identifierCell];
        [self registerClass:[LocalBillCell class] forCellReuseIdentifier:identifierLocalBillCell];

        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.bills.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LocalBillCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierLocalBillCell forIndexPath:indexPath];
    cell.currencyModel = self.billModel;
    cell.billModel = self.bills[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 76;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *contentView = [[UIView alloc] init];

    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:backView];

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, kScreenWidth - 35, 40)];
    [backView addSubview:lab];
    
    lab.textColor = kTextColor;
    lab.font = [UIFont systemFontOfSize:13];
    lab.text =[NSString stringWithFormat:@"%@",[LangSwitcher switchLang:@"交易记录" key:nil]];


    UIView *view = [UIView new];
    view.backgroundColor = kHexColor(@"276FFA ");
    view.frame = CGRectMake(15, 14, 5, 12);
    kViewRadius(view, 1);
    [backView addSubview:view];


    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 39, SCREEN_WIDTH - 30, 1)];
    lineView.backgroundColor = kLineColor;
    [backView addSubview:lineView];


//    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
//    lineView1.backgroundColor = kLineColor;
//    [backView addSubview:lineView1];

    return contentView;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}


@end
