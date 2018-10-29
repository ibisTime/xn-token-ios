//
//  TLBTCtableView.m
//  Coin
//
//  Created by shaojianfei on 2018/8/11.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBTCtableView.h"
#import "BillDetailCell.h"
#import "NSString+Date.h"
#import "NSString+Extension.h"
#import "CoinUtil.h"
#import "BTCDetailModel.h"
#import "CommentTableView.h"
@interface TLBTCtableView()<UITableViewDataSource, UITableViewDelegate>
{
    BTCDetailModel *cell;
}
@property (nonatomic ,strong) CommentTableView *tableView;

@property (nonatomic ,strong) CommentTableView *outTableView;

@end



@implementation TLBTCtableView

static NSString *identifierCell = @"BTCDetailModel";
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = kBackgroundColor;
        
        [self registerClass:[BTCDetailModel class] forCellReuseIdentifier:identifierCell];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
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
    
    NSString *dateStr = [_bill.transDatetime convertToDetailDate];
    
    NSString *toAdress = @"  ";
    NSString *formAdress = @"  ";
    NSString *charge = _bill.txFee;
    NSString *height = _bill.height;

    if ([_bill.height isEqualToString:@"-1"]) {
        
        if ([_bill.direction isEqualToString:@"1"]) {
            height =  [LangSwitcher switchLang:@"即将到账" key:nil];
        }else{
            
            height =  [LangSwitcher switchLang:@"同步打包中" key:nil];

        }
    }
    NSString *texthash = _bill.txHash;
    if (indexPath.row == 0) {
        [cell localInfoWithData:textArr index:indexPath.row];

        CGFloat h = _bill.vout.count *40;
        cell.titleLbl.frame = CGRectMake(15, 15, SCREEN_WIDTH - 30, 14);
        self.tableView = [[CommentTableView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, h) style:UITableViewStylePlain];
        self.tableView.address = self.address;
        [cell addSubview:self.tableView];
        self.tableView.owHeight = 40;
        self.tableView.utxis = _bill.vout;
        [self.tableView reloadData];
        [cell setNeedsLayout];
        
    }else if (indexPath.row == 1)
    {
        
        [cell localInfoWithData:textArr index:indexPath.row];
        
        CGFloat h = _bill.vin.count *40;
        cell.titleLbl.frame = CGRectMake(15, 15, SCREEN_WIDTH - 30, 14);
        self.outTableView = [[CommentTableView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth , h) style:UITableViewStylePlain];
        [cell addSubview:self.outTableView];
        self.outTableView.address = self.address;

        self.outTableView.owHeight = 40;
        self.outTableView.utxis = _bill.vin;
        [self.outTableView reloadData];
        [cell setNeedsLayout];

    }
    else{
        NSString *postAmount = [CoinUtil convertToRealCoin:_bill.txFee coin:_currentModel.symbol];
        
        
        NSArray *rightArr = @[toAdress, formAdress, postAmount, height,texthash,dateStr,@"  "];
        
        [cell localInfoWithData:textArr index:indexPath.row];
        [cell localInfoWithRightData:rightArr index:indexPath.row];
        cell.titleLbl.frame = CGRectMake(15, 18, 0, 14);
        [cell.titleLbl sizeToFit];
        cell.rightLabel.frame = CGRectMake(cell.titleLbl.xx + 10, 18, SCREEN_WIDTH - cell.titleLbl.xx - 25, 0);
        [cell.rightLabel sizeToFit];
    }
    

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
    
    if (indexPath.row == 0) {
        return _bill.vout.count*40+45;
    }else if (indexPath.row == 1)
    {
        
        return _bill.vin.count*40+45;

    }
    
    else{
        return cell.rightLabel.yy + 18;
    }
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
