//
//  TLOrderCategoryVC.m
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "OrderListVC.h"
#import "TLTableView.h"
#import "TLUIHeader.h"
#import "TLPageDataHelper.h"
#import "TLPlaceholderView.h"
#import "TLUser.h"
#import "TLNetworking.h"
#import "OrderListCell.h"
#import "TLAlert.h"
#import <MJRefresh/MJRefresh.h>
#import "WaitingOrderVC.h"
#import "OrderDetailVC.h"


@interface OrderListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *orderTableView;
@property (nonatomic,assign) BOOL isFirst;

@end

@implementation OrderListVC

- (void)refresh {
    
    [self.orderTableView beginRefreshing];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    if (self.isFirst) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.orderTableView beginRefreshing];
            self.isFirst = NO;
            
        });
        
    }
    
}


- (void)reloadData {
    
    [self.orderTableView reloadData_tl];
}



- (void)viewDidLayoutSubviews {
    
    self.orderTableView.frame = self.view.bounds;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirst = YES;
    
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    TLTableView *tableView = [TLTableView
                              tableViewWithFrame:CGRectZero
                              delegate:self
                              dataSource:self];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor whiteColor];
    
    
    
    self.orderTableView = tableView;
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImgAndText:@"暂无订单"];
    
    //--//
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"625250";
    helper.start = 1;
    helper.limit = 20;
    helper.parameters[@"tradeCoin"] = @"ETH";
    helper.parameters[@"statusList"] = self.statusList;
    helper.parameters[@"tradeCurrency"] = @"CNY";
    helper.parameters[@"belongUser"] = [TLUser user].userId;
    helper.tableView = self.orderTableView;
    [helper modelClass:[OrderModel class]];
    
    //-----//
    __weak typeof(self) weakSelf = self;
    [self.orderTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            [weakSelf removePlaceholderView];
            weakSelf.orderGroups = objs;
            [weakSelf.orderTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            [weakSelf addPlaceholderView];
            
        }];
        
    }];
    
    [self.orderTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.orderGroups = objs;
            [weakSelf.orderTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.orderTableView endRefreshingWithNoMoreData_tl];
    
    
}


- (void)tl_placeholderOperation {
    
    [self.orderTableView beginRefreshing];
    
}


#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //
    OrderModel *order = self.orderGroups[indexPath.row];
    
//    NSString *friendUserId = order.isBuy ? order.sellUserInfo.userId: order.buyUserInfo.userId;
    NSString *friendPhoto = order.isBuy ? order.sellUserInfo.photo: order.buyUserInfo.photo;
    NSString *friendNickName = order.isBuy ? order.sellUserInfo.nickname: order.buyUserInfo.nickname;
    
    IMAGroup *currentIMGroup = nil;
    //2. 获取对应的group
    currentIMGroup = [[IMAGroup alloc] initWith:order.code];

    
    //我
    ChatUserProfile *userInfo = [ChatUserProfile sharedUser];
    userInfo.minePhoto = [TLUser user].photo;
    userInfo.mineNickName = [TLUser user].nickname;
    userInfo.friendPhoto = [friendPhoto convertImageUrl];
    userInfo.friendNickName = friendNickName;
  
    if ([order.status isEqualToString:@"-1"]) {
        // 传入user
        WaitingOrderVC *chatVC = [[WaitingOrderVC alloc] initWith:currentIMGroup];
        chatVC.userInfo = userInfo;
        chatVC.order = order;
        [self.navigationController pushViewController:chatVC animated:YES];
        return ;
    }
    
    //
    OrderDetailVC *chatVC = [[OrderDetailVC alloc] initWith:currentIMGroup];
    chatVC.userInfo = userInfo;
    chatVC.order = order;
    [self.navigationController pushViewController:chatVC animated:YES];
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [OrderListCell defaultCellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.orderGroups.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhOrderGoodsCellId = @"OrderListCell";
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:zhOrderGoodsCellId];
    if (!cell) {
        
        cell = [[OrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhOrderGoodsCellId];
        
    }
    
    cell.order = self.orderGroups[indexPath.row];
    
    return cell;
    
}


#pragma mark 编辑模式

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderModel *order = self.orderGroups[indexPath.row];
    
    if ([order.status isEqualToString:@"-1"]) {
        
        return UITableViewCellEditingStyleDelete;
        
    }
    return UITableViewCellEditingStyleNone;
}

- (NSArray<UITableViewRowAction*> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *actionArr = @[].mutableCopy;
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        
        [self deleteArticleWithIndex:indexPath.row];
        
    }];
    
    deleteAction.backgroundColor = [UIColor themeColor];
    
    [actionArr addObject:deleteAction];
    
    return actionArr;
}

- (void)deleteArticleWithIndex:(NSInteger)index {
    
    OrderModel *order = self.orderGroups[index];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625249";
    http.showView = self.view;
    http.parameters[@"code"] = order.code;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        
        OrderModel *order = self.orderGroups[index];
        NSString *userId = order.isBuy ? order.sellUserInfo.userId: order.buyUserInfo.userId;
        
        //获取会话列表
        TIMConversation *timConversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:userId];
        
        IMAConversation *imaConversation = [[IMAConversation alloc] initWith:timConversation];
        
        [[IMAPlatform sharedInstance].conversationMgr deleteConversation:imaConversation needUIRefresh:NO];
        //删除数据源中的数据
        [self.orderGroups removeObjectAtIndex:index];
        
        [self.orderTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [TLAlert alertWithSucces:@"删除成功"];
        
        if (self.orderGroups.count == 0) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.orderTableView reloadData_tl];
                
            });
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}


@end

