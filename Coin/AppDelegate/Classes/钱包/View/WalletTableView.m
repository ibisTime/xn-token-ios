//
//  WalletTableView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "WalletTableView.h"
#import "CoinHeader.h"
#import "WalletCell.h"

@interface WalletTableView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation WalletTableView

static NSString *identifierCell = @"WalletCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[WalletCell class] forCellReuseIdentifier:identifierCell];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.currencys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WalletCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.currency = self.currencys[indexPath.section];
    
    cell.tag = 1200 + 100*indexPath.section;
    
    cell.rechargeBtn.tag = cell.tag + 0;
    
    [cell.rechargeBtn addTarget:self action:@selector(clickRecharge:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.withdrawalsBtn.tag = cell.tag + 1;

    [cell.withdrawalsBtn addTarget:self action:@selector(clickWithdrawals:) forControlEvents:UIControlEventTouchUpInside];

    cell.billBtn.tag = cell.tag + 2;

    [cell.billBtn addTarget:self action:@selector(clickBill:) forControlEvents:UIControlEventTouchUpInside];

    cell.freezingAmountBtn.tag = cell.tag + 3;
    
    [cell.freezingAmountBtn addTarget:self action:@selector(clickFrozen:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

#pragma mark - Events
- (void)clickRecharge:(UIButton *)sender {
    
    NSInteger index = (sender.tag - 1200)/100;
    
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:button:selectRowAtIndex:)]) {
        
        [self.refreshDelegate refreshTableViewButtonClick:self button:sender selectRowAtIndex:index];
    }
}

- (void)clickWithdrawals:(UIButton *)sender {
    
    NSInteger index = (sender.tag - 1200)/100;

    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:button:selectRowAtIndex:)]) {
        
        [self.refreshDelegate refreshTableViewButtonClick:self button:sender selectRowAtIndex:index];
    }
}

- (void)clickBill:(UIButton *)sender {
    
    NSInteger index = (sender.tag - 1200)/100;

    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:button:selectRowAtIndex:)]) {
        
        [self.refreshDelegate refreshTableViewButtonClick:self button:sender selectRowAtIndex:index];
    }
}

- (void)clickFrozen:(UIButton *)sender {
    
    NSInteger index = (sender.tag - 1200)/100;
    
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:button:selectRowAtIndex:)]) {
        
        [self.refreshDelegate refreshTableViewButtonClick:self button:sender selectRowAtIndex:index];
    }
}
@end
