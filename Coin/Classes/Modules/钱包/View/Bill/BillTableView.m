//
//  BillTableView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "BillTableView.h"
#import "CoinHeader.h"
#import "AppColorMacro.h"
#import "BillCell.h"

@interface BillTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation BillTableView

static NSString *identifierCell = @"BillListCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        self.backgroundColor = kBackgroundColor;
        
        [self registerClass:[BillCell class] forCellReuseIdentifier:identifierCell];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.bills.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BillCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.billModel = self.bills[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.bills[indexPath.row].dHeightValue + 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, kScreenWidth, 22)];
    lab.textColor = kTextColor;
    lab.font = [UIFont systemFontOfSize:12];
    
    lab.text = @"    交易记录";
    return lab;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}
@end
