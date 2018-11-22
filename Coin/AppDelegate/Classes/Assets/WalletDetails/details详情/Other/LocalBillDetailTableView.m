//
//  LocalBillDetailTableView.m
//  Coin
//
//  Created by shaojianfei on 2018/6/15.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "LocalBillDetailTableView.h"
#import "BillDetailCell.h"


@interface LocalBillDetailTableView()<UITableViewDataSource, UITableViewDelegate>
{
    BillDetailCell *cell;
}
@end
@implementation LocalBillDetailTableView
static NSString *identifierCell = @"BillDetailCell";
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style])
    {
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = kBackgroundColor;
        [self registerClass:[BillDetailCell class] forCellReuseIdentifier:identifierCell];
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
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
    if ([_currentModel.symbol isEqualToString:@"USDT"]) {
        dateStr = [self UTCchangeDate:_usdtModel.blockTime];
        if ([_usdtModel.typeInt isEqualToString:@"0"]) {
            toAdress = _usdtModel.referenceAddress;
        }else
        {
            toAdress = _usdtModel.sendingAddress;
        }
        formAdress = _usdtModel.sendingAddress;
        charge = [CoinUtil convertToRealCoin:_usdtModel.fee coin:self.currentModel.symbol];;
        if ([TLUser isBlankString:self.usdtModel.block] == YES) {
            if ([self.currentModel.address isEqualToString:self.usdtModel.sendingAddress]) {
                height = [LangSwitcher switchLang:@"同步打包中" key:nil];
            }else
            {
                height = [LangSwitcher switchLang:@"即将到账" key:nil];
            }
            
        }else
        {
            height = self.usdtModel.block;
        }
        texthash = _usdtModel.txid;
        CoinModel *co = [CoinUtil getCoinModel:_currentModel.symbol];
        postAmount  = [CoinUtil convertToRealCoin:_usdtModel.fee coin:co.symbol];
        
    }else if ([_bill.tokenSymbol isEqualToString:@"LXT"]) {
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
    
    
    
    
    NSArray *rightArr = @[[TLUser convertNull:toAdress], [TLUser convertNull:formAdress], [TLUser convertNull:postAmount], [TLUser convertNull:height],[TLUser convertNull:texthash],[TLUser convertNull:dateStr],@"  "];

    cell.titleLbl.text = [NSString stringWithFormat:@"%@",textArr[indexPath.row]];

    cell.rightLabel.text = rightArr[indexPath.row];
    cell.titleLbl.frame = CGRectMake(15, 18, 0, 14);
    [cell.titleLbl sizeToFit];
    cell.rightLabel.frame = CGRectMake(cell.titleLbl.xx + 10, 18, SCREEN_WIDTH - cell.titleLbl.xx - 25, 0);
    [cell.rightLabel sizeToFit];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(NSString *)UTCchangeDate:(NSString *)utc{
    
    NSTimeInterval time = [utc doubleValue];
    
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *staartstr=[dateformatter stringFromDate:date];
    
    return staartstr;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.rightLabel.yy + 18 < 50) {
        return 50;
    }
    return cell.rightLabel.yy + 18;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

@end
