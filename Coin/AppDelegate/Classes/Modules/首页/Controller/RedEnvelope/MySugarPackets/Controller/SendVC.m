//
//  SendVC.m
//  Coin
//
//  Created by QinBao Zheng on 2018/7/2.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "SendVC.h"
#import "SendTableView.h"
#import "SendModel.h"
#import "RedEnvelopeVC.h"
#import "RedEnvelopeShoreVC.h"
@interface SendVC ()<RefreshDelegate>
@property (nonatomic , strong)SendTableView *tableView;
@property (nonatomic, strong) NSMutableArray <SendModel *>*send;

@end

@implementation SendVC

-(UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[SendTableView alloc]
                          initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 70)
                          style:UITableViewStyleGrouped];

        self.tableView.backgroundColor = kWhiteColor;
        self.tableView.sectionHeaderHeight = 22;
        self.tableView.refreshDelegate =self;
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self LoadData];
}



-(void)LoadData
{

    CoinWeakSelf;

    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    if (![TLUser user].isLogin) {
        return;
    }
    helper.code = @"623005";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.isList = NO;
    helper.isCurrency = YES;
    helper.tableView = self.tableView;
    [helper modelClass:[SendModel class]];

    [self.tableView addRefreshAction:^{

        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {

            //去除没有的币种
            NSLog(@" ==== %@",objs);

            NSMutableArray <SendModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
            [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

                SendModel *getModel = (SendModel *)obj;
                [shouldDisplayCoins addObject:getModel];

            }];

            //
            weakSelf.send = shouldDisplayCoins;
            weakSelf.tableView.send = shouldDisplayCoins;
            [weakSelf.tableView reloadData_tl];

        } failure:^(NSError *error) {


        }];


    }];

    [self.tableView addLoadMoreAction:^{
        helper.parameters[@"userId"] = [TLUser user].userId;
        helper.parameters[@"token"] = [TLUser user].token;
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            NSLog(@" ==== %@",objs);
            //去除没有的币种


            NSMutableArray <SendModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
            [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

                SendModel *send = (SendModel *)obj;
                //                if ([[CoinUtil shouldDisplayCoinArray] indexOfObject:currencyModel.currency ] != NSNotFound ) {

                [shouldDisplayCoins addObject:send];
                //                }

            }];

            //
            weakSelf.send = shouldDisplayCoins;
            weakSelf.tableView.send = shouldDisplayCoins;
            [weakSelf.tableView reloadData_tl];

        } failure:^(NSError *error) {


        }];

    }];

    [self.tableView beginRefreshing];
}
-(void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SendModel *model = self.send[indexPath.row];
    RedEnvelopeShoreVC *share = [RedEnvelopeShoreVC new];
    share.code = model.code;
    share.content = model.greeting;
    [self presentViewController:share animated:YES completion:nil];
   
}



@end
