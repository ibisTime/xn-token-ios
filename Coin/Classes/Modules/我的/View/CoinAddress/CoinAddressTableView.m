//
//  CoinAddressTableView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/28.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CoinAddressTableView.h"

#import "CoinAddressCell.h"

#import "TLNetworking.h"
#import "TLAlert.h"

@interface CoinAddressTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation CoinAddressTableView

static NSString *identifierCell = @"CoinAddressCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        self.backgroundColor = kBackgroundColor;
        
        [self registerClass:[CoinAddressCell class] forCellReuseIdentifier:identifierCell];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.addressArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CoinAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.addressModel = self.addressArr[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
    
//    CoinAddressCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//
//    [cell setEditing:YES animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

#pragma mark 编辑模式

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

- (NSArray<UITableViewRowAction*> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *actionArr = @[].mutableCopy;
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [TLAlert alertWithTitle:@"" msg:@"你真的要删除地址？" confirmMsg:@"确定" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
            
        } confirm:^(UIAlertAction *action) {
            
            [self deleteArticleWithIndex:indexPath.row];
            
        }];
        
    }];
    
    deleteAction.backgroundColor = [UIColor themeColor];
    
    [actionArr addObject:deleteAction];
    
    return actionArr;
}

- (void)deleteArticleWithIndex:(NSInteger)index {
    
    CoinAddressModel *address = self.addressArr[index];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625202";
    
    http.parameters[@"code"] = address.code;
    
    [http postWithSuccess:^(id responseObject) {
        
        [self.addressArr removeObjectAtIndex:index];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [TLAlert alertWithSucces:@"删除成功"];

        if (self.addressArr.count == 0) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self reloadData_tl];
                
            });
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

@end
