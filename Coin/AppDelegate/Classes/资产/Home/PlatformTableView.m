//
//  PlatformTableView.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PlatformTableView.h"
//V
#import "PlatformCell.h"
#import "AccountMoneyCellTableViewCell.h"
@interface PlatformTableView()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *arr;
}
@end

@implementation PlatformTableView

static NSString *platformAllCell = @"PlatformAllCell";
static NSString *platformPriceCell = @"PlatformPriceCell";
static NSString *platformCell = @"PlatformCell";
static NSString *platformCell1 = @"AccountMoneyCellTableViewCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[PlatformCell class] forCellReuseIdentifier:platformCell];
        [self registerClass:[AccountMoneyCellTableViewCell class] forCellReuseIdentifier:platformCell1];

    }
    
    return self;
}


-(void)WhetherOrNotShown
{
    TLDataBase *dataBase = [TLDataBase sharedManager];
    NSString *symbol;
    NSString *address;
    arr = [NSMutableArray array];
    if ([dataBase.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT symbol,address from THALocal lo, THAUser th where lo.walletId = th.walletId  and th.userId = '%@' and lo.IsSelect = 1",[TLUser user].userId];
        //        [sql appendString:[TLUser user].userId];
        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
        while ([set next])
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            symbol = [set stringForColumn:@"symbol"];
            address = [set stringForColumn:@"address"];
            
            [dic setObject:symbol forKey:@"symbol"];
            [arr addObject:dic];
        }
        [set close];
    }
    [dataBase.dataBase close];
}

#pragma mark - UITableViewDataSource;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self WhetherOrNotShown];
    if (self.isLocal == YES) {
        return arr.count;
    }
    return self.platforms.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    [self WhetherOrNotShown];
    AccountMoneyCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:platformCell1 forIndexPath:indexPath];
    
    
    if (self.isLocal == YES) {
        [self WhetherOrNotShown];
        for (int j = 0; j<self.platforms.count; j++) {
            if ([arr[indexPath.row][@"symbol"] isEqualToString:self.platforms[j].symbol]) {
                cell.platform = self.platforms[j];
            }
        }
    }else
    {
        cell.platform1 = self.platforms[indexPath.row];
    }
    return cell;
//    if (self.platforms.count > 0) {
//
//
//
//    }
    
    
//    if (self.isLocal == YES) {
//
//
//    }else
//    {
//        PlatformCell *cell = [tableView dequeueReusableCellWithIdentifier:platformCell forIndexPath:indexPath];
//        cell.platform = self.platforms[indexPath.row];
//        return cell;
//    }
//
//    return nil;
    
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectBlock(indexPath.row);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

@end
