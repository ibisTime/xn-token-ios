//
//  BillDetailTableView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "BillDetailTableView.h"

#import "BillDetailCell.h"
#import "NSString+Date.h"
#import "NSNumber+Extension.h"

@interface BillDetailTableView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation BillDetailTableView

static NSString *identifierCell = @"BillDetailCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[BillDetailCell class] forCellReuseIdentifier:identifierCell];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BillDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    
    NSArray *textArr = @[@"账单余额", @"账单时间", @"账单类型"];
    
    NSString *dateStr = [_bill.createDatetime convertToDetailDate];
    
    NSString *postAmount = [_bill.postAmount convertToSimpleRealCoin];
    
    NSArray *rightArr = @[postAmount, dateStr, _bill.getBizName];
    
    cell.titleLbl.text = textArr[indexPath.row];
    
    cell.rightLabel.text = rightArr[indexPath.row];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

@end
