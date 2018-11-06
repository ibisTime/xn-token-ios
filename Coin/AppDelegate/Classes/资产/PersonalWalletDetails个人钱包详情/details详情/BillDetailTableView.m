//
//  BillDetailTableView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "BillDetailTableView.h"

#import "BillDetailCell.h"

@interface BillDetailTableView ()<UITableViewDataSource, UITableViewDelegate>
{
    BillDetailCell *cell;
}
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
    
    return 5;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    NSArray *textArr = @[
                         [LangSwitcher switchLang:@"变动前金额" key:nil],
                          [LangSwitcher switchLang:@"变动后金额" key:nil],
                          [LangSwitcher switchLang:@"变动时间" key:nil],
                          [LangSwitcher switchLang:@"明细状态" key:nil],
                          [LangSwitcher switchLang:@"明细摘要" key:nil],
                         ];
    
    NSString *dateStr = [_bill.createDatetime convertToDetailDate];
    
    NSString *postAmount = [CoinUtil convertToRealCoin:_bill.postAmountString coin:_bill.currency];
    
    NSString *preAmount = [CoinUtil convertToRealCoin:_bill.preAmountString coin:_bill.currency];
    NSString *getBizName;
    if ([TLUser isBlankString:_bill.getBizName] == YES) {
        getBizName = _bill.bizNote;
    }else
    {
        getBizName = _bill.getBizName;
    }
    NSArray *rightArr = @[preAmount, postAmount, dateStr, _bill.getStatusName, getBizName];
    
    cell.titleLbl.text = [NSString stringWithFormat:@"%@",textArr[indexPath.row]];
//    [LangSwitcher switchLang:textArr[indexPath.row] key:nil];
    
    cell.rightLabel.text = rightArr[indexPath.row];
//    [LangSwitcher switchLang:rightArr[indexPath.row] key:nil] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLbl.frame = CGRectMake(15, 18, 0, 14);
    [cell.titleLbl sizeToFit];
    cell.rightLabel.frame = CGRectMake(cell.titleLbl.xx + 10, 18, SCREEN_WIDTH - cell.titleLbl.xx - 25, 0);
    [cell.rightLabel sizeToFit];
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return cell.rightLabel.yy + 18;
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
