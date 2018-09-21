//
//  LocalBillDetailTableView.m
//  Coin
//
//  Created by shaojianfei on 2018/6/15.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "LocalBillDetailTableView.h"
#import "BillDetailCell.h"
#import "NSString+Date.h"
#import "NSString+Extension.h"
#import "CoinUtil.h"

@interface LocalBillDetailTableView()<UITableViewDataSource, UITableViewDelegate>

@end
@implementation LocalBillDetailTableView
static NSString *identifierCell = @"BillDetailCell";
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = kBackgroundColor;
        
        [self registerClass:[BillDetailCell class] forCellReuseIdentifier:identifierCell];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 7;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BillDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    NSArray *textArr = @[
                         [LangSwitcher switchLang:@"收款地址" key:nil],
                         [LangSwitcher switchLang:@"转出地址" key:nil],
                         [LangSwitcher switchLang:@"手续费" key:nil],
                         [LangSwitcher switchLang:@"区块高度" key:nil],
                         [LangSwitcher switchLang:@"交易号" key:nil],
                         [LangSwitcher switchLang:@"交易时间" key:nil],
                         [LangSwitcher switchLang:@"查看更多详情" key:nil]

                         ];
    NSString *dateStr;
    NSString *toAdress;
    NSString *formAdress;
    NSString *charge;
    NSString *height;
    NSString *texthash;
    NSString *postAmount;
    if ([_bill.tokenSymbol isEqualToString:@"LXT"]) {
        dateStr = [_bill.createDatetime convertToDetailDate];
        toAdress = _bill.to;
        formAdress = _bill.from;
        charge = _bill.cumulativeGasUsed;
        height = _bill.blockNumber;
        texthash = _bill.Hashs;
        CoinModel *co = [CoinUtil getCoinModel:_currentModel.symbol];
        postAmount  = [CoinUtil convertToRealCoin:_bill.txFee coin:co.symbol];
        
    }else{
        dateStr = [_bill.transDatetime convertToDetailDate];
        toAdress = _bill.to;
        formAdress = _bill.from;
        charge = _bill.txFee;
        height = _bill.height;
        texthash = _bill.txHash;
        postAmount  = [CoinUtil convertToRealCoin:_bill.txFee coin:_currentModel.symbol];
    }
    NSArray *rightArr = @[toAdress, formAdress, postAmount, height,texthash,dateStr,@""];
    
    cell.titleLbl.text = textArr[indexPath.row];
    cell.rightLabel.text = rightArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 6;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

@end
