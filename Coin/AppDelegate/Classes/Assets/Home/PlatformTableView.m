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


//-(void)WhetherOrNotShown
//{
//    TLDataBase *dataBase = [TLDataBase sharedManager];
//    NSString *symbol;
//    NSString *address;
//    arr = [NSMutableArray array];
//    if ([dataBase.dataBase open]) {
//        NSString *sql = [NSString stringWithFormat:@"SELECT symbol,address from THALocal lo, THAUser th where lo.walletId = th.walletId  and th.userId = '%@' and lo.IsSelect = 1",[TLUser user].userId];
//        //        [sql appendString:[TLUser user].userId];
//        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
//        while ([set next])
//        {
//            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//
//            symbol = [set stringForColumn:@"symbol"];
//            address = [set stringForColumn:@"address"];
//
//            [dic setObject:symbol forKey:@"symbol"];
//            [arr addObject:dic];
//        }
//        [set close];
//    }
//    [dataBase.dataBase close];
//
//
//
//    if ([TLUser isBlankString:self.btcOldAddress] == NO) {
//        for (int i = 0; i < arr.count; i ++) {
//
//            if ([arr[i][@"symbol"] isEqualToString:@"BTC"]) {
//                NSDictionary *dic = @{@"address":self.btcOldAddress,
//                                      @"symbol":@"BTC"
//                                      };
//                [arr insertObject:dic atIndex:i];
//
//            }
//        }
//    }
//
//
//}

#pragma mark - UITableViewDataSource;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    [self WhetherOrNotShown];
//    if (self.isLocal == YES) {
////        if ([TLUser isBlankString:self.btcOldAddress] == NO) {
////            return arr.count + 1;
////        }else
////        {
////            return arr.count;
////        }
//        return platforms;
//    }
    return self.platforms.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
//    [self WhetherOrNotShown];
    AccountMoneyCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:platformCell1 forIndexPath:indexPath];
    
    
    if (self.isLocal == YES) {
//        [self WhetherOrNotShown];
//        for (int j = 0; j<self.platforms.count; j++) {
//            if ([arr[indexPath.row][@"address"] isEqualToString:self.platforms[j].address]) {
//
//                cell.platform = self.platforms[j];
//            }
//        }
        cell.platform = self.platforms[indexPath.row];
    }else
    {
        cell.platform1 = self.platforms[indexPath.row];
    }
    
    
    return cell;
    
}


//设置cell可编辑状态
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//定义编辑样式为删除样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

//设置返回存放侧滑按钮数组
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //这是iOS8以后的方法
    UITableViewRowAction *transferBtn = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:[LangSwitcher switchLang:@"转账" key:nil] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:setCurrencyModel:setTitle:)]) {
            if (self.isLocal == YES) {
                [self.refreshDelegate refreshTableView:self setCurrencyModel:self.platforms[indexPath.row] setTitle:@"转账"];
//                [self WhetherOrNotShown];
//                for (int j = 0; j<self.platforms.count; j++) {
//                    if ([arr[indexPath.row][@"symbol"] isEqualToString:self.platforms[j].symbol]) {
//                        [self.refreshDelegate refreshTableView:self setCurrencyModel:self.platforms[j] setTitle:@"转账"];
//                    }
//                }
            }else
            {
                [self.refreshDelegate refreshTableView:self setCurrencyModel:self.platforms[indexPath.row] setTitle:@"转账"];
            }
            
        }
    }];
    
    
    UITableViewRowAction *collectionBtn = [UITableViewRowAction  rowActionWithStyle:UITableViewRowActionStyleNormal title:[LangSwitcher switchLang:@"收款" key:nil] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:setCurrencyModel:setTitle:)]) {
            if (self.isLocal == YES) {
                [self.refreshDelegate refreshTableView:self setCurrencyModel:self.platforms[indexPath.row] setTitle:@"收款"];
//                [self WhetherOrNotShown];
//                for (int j = 0; j<self.platforms.count; j++) {
//                    if ([arr[indexPath.row][@"symbol"] isEqualToString:self.platforms[j].symbol]) {
//                        [self.refreshDelegate refreshTableView:self setCurrencyModel:self.platforms[j] setTitle:@"收款"];
//                    }
//                }
            }else
            {
                [self.refreshDelegate refreshTableView:self setCurrencyModel:self.platforms[indexPath.row] setTitle:@"收款"];
            }
            
        }
        
    }];
//    transferBtn.backgroundColor = [UIColor blueColor];
//
//    collectionBtn.backgroundColor = [UIColor orangeColor];
    return @[transferBtn,collectionBtn];
    
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectBlock(indexPath.row);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 73.5;
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
