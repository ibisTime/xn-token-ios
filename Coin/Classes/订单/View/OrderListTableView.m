//
//  OrderListTableView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "OrderListTableView.h"

#import "OrderListCell.h"
#import "TLAlert.h"

#import "TLNetworking.h"

@interface OrderListTableView ()<UITableViewDelegate, UITableViewDataSource>


@end

@implementation OrderListTableView

static NSString *identifierCell = @"OrderListCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        self.backgroundColor = kBackgroundColor;
        
        [self registerClass:[OrderListCell class] forCellReuseIdentifier:identifierCell];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    
    cell.order = self.orders[indexPath.row];
    
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

#pragma mark 编辑模式

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderModel *order = self.orders[indexPath.row];
    
    if ([order.status isEqualToString:@"-1"]) {
        
        return UITableViewCellEditingStyleDelete;

    }
    return UITableViewCellEditingStyleNone;
}

- (NSArray<UITableViewRowAction*> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *actionArr = @[].mutableCopy;
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
//        [TLAlert alertWithTitle:@"" msg:@"你真的要删除din？" confirmMsg:@"确定" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
//
//        } confirm:^(UIAlertAction *action) {
//
//        }];
        
        [self deleteArticleWithIndex:indexPath.row];
        
    }];
    
    deleteAction.backgroundColor = [UIColor themeColor];
    
    [actionArr addObject:deleteAction];
    
    return actionArr;
}

- (void)deleteArticleWithIndex:(NSInteger)index {
    
    OrderModel *order = self.orders[index];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625249";
    http.showView = self;
    http.parameters[@"code"] = order.code;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];

        OrderModel *order = self.orders[index];

        NSString *userId = order.isBuy ? order.sellUserInfo.userId: order.buyUserInfo.userId;

        //获取会话列表
        TIMConversation *timConversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:userId];
        
        IMAConversation *imaConversation = [[IMAConversation alloc] initWith:timConversation];
        
        [[IMAPlatform sharedInstance].conversationMgr deleteConversation:imaConversation needUIRefresh:NO];
        //删除数据源中的数据
        [self.orders removeObjectAtIndex:index];
        
        [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [TLAlert alertWithSucces:@"删除成功"];
        
        if (self.orders.count == 0) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self reloadData_tl];
                
            });
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

@end
