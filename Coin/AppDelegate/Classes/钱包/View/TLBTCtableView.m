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
    
    BTCDetailModel *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    NSArray *textArr = @[
                         [LangSwitcher switchLang:@"收款地址" key:nil],
                         [LangSwitcher switchLang:@"转出地址" key:nil],
                         [LangSwitcher switchLang:@"手续费" key:nil],
                         [LangSwitcher switchLang:@"区块高度" key:nil],
                         [LangSwitcher switchLang:@"交易号" key:nil],
                         [LangSwitcher switchLang:@"交易时间" key:nil],
                         [LangSwitcher switchLang:@"" key:nil]
                         
                         ];
    
    NSString *dateStr = [_bill.transDatetime convertToDetailDate];
    
    NSString *toAdress = @"";
    NSString *formAdress = @"";
    NSString *charge = _bill.txFee;
    NSString *height = _bill.height;
    NSString *texthash = _bill.txHash;
    if (indexPath.row == 0) {
        [cell localInfoWithData:textArr index:indexPath.row];

        CGFloat h = _bill.vout.count *44;
        
        self.tableView = [[CommentTableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth -30, h) style:UITableViewStylePlain];
        self.tableView.address = self.address;
        [cell addSubview:self.tableView];
        self.tableView.owHeight = 44;
        self.tableView.utxis = _bill.vout;
        [self.tableView reloadData];
        [cell setNeedsLayout];
        
    }else if (indexPath.row == 1)
    {
        
        [cell localInfoWithData:textArr index:indexPath.row];
        
        CGFloat h = _bill.vin.count *44;
        
        self.outTableView = [[CommentTableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth -30, h) style:UITableViewStylePlain];
        [cell addSubview:self.outTableView];
        self.outTableView.address = self.address;

        self.outTableView.owHeight = 44;
        self.outTableView.utxis = _bill.vin;
        [self.outTableView reloadData];
        [cell setNeedsLayout];

    }
    else{
        NSString *postAmount = [CoinUtil convertToRealCoin:_bill.txFee coin:_currentModel.symbol];
        
        //    NSString *preAmount = [CoinUtil convertToRealCoin:_bill.preAmountString coin:_bill.currency];
        
        NSArray *rightArr = @[toAdress, formAdress, postAmount, height,texthash,dateStr,@"查看更多详情"];
        
        //    cell.titleLbl.text = textArr[indexPath.row];
        [cell localInfoWithData:textArr index:indexPath.row];
        //    cell.localInfo = textArr;
        //    [LangSwitcher switchLang:textArr[indexPath.row] key:nil];
        [cell localInfoWithRightData:rightArr index:indexPath.row];
    }
    
   
//    cell.rightLabel.text = rightArr[indexPath.row];
    //    [LangSwitcher switchLang:rightArr[indexPath.row] key:nil] ;
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
        return _bill.vout.count*44+70;
    }else if (indexPath.row == 1)
    {
        
        return _bill.vin.count*44+70;

    }
    
    else{
        return 70;
    }
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
