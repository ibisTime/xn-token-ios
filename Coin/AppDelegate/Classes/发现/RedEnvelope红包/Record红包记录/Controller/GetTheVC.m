//
//  GetTheVC.m
//  Coin
//
//  Created by QinBao Zheng on 2018/7/2.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "GetTheVC.h"
#import "GetTheTableView.h"
#import "GetTheModel.h"
#import "RedEnvelopeVC.h"
#import "MysugarView.h"
#import "FilterView.h"
#import "SendModel.h"
#import "SendVC.h"
@interface GetTheVC ()<RefreshDelegate>
@property (nonatomic , strong)GetTheTableView *tableView;


@property (nonatomic, strong) NSMutableArray <GetTheModel *>*getthe;

@property (nonatomic, strong) NSMutableArray <SendModel *>*sends;
@property (nonatomic, strong) FilterView *filterPicker;
@property (nonatomic , strong)MysugarView *headView;

@property (nonatomic, strong) NSMutableArray *textArr;

@property (nonatomic, copy) NSString *year;

@property (nonatomic, assign) BOOL isClose;

@end

@implementation GetTheVC

-(UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[GetTheTableView alloc]
                          initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)
                          style:UITableViewStyleGrouped];

        self.tableView.backgroundColor = kWhiteColor;
        self.tableView.sectionHeaderHeight = 22;

        self.tableView.refreshDelegate = self;

    }
    return _tableView;
}
- (FilterView *)filterPicker {
    
    if (!_filterPicker) {
        
        CoinWeakSelf;
        
       NSArray * textArr = self.textArr;
//        NSArray *textArr = @[[LangSwitcher switchLang:@"2018" key:nil],
//                             [LangSwitcher switchLang:@"2017" key:nil],
//                              [LangSwitcher switchLang:@"2016" key:nil],
//                             ];
        
        NSArray *typeArr = @[@"tt",
                             @"charge",
                             ];
        
        _filterPicker = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        //        _filterPicker.title =  [LangSwitcher switchLang: @"请选择交易类型" key:nil];
       
        _filterPicker.selectBlock = ^(NSInteger index) {
            
            [weakSelf pickerChoose:index];
            weakSelf.year = textArr[index];
            [weakSelf.headView.tameBtn setTitle:[NSString stringWithFormat:@"%@%@",textArr[index],[LangSwitcher switchLang:@"年" key:nil]] forState:UIControlStateNormal];
            //            [weakSelf.tableView beginRefreshing];
        };
        
        _filterPicker.tagNames = textArr;
        
    }
    
    return _filterPicker;
}

- (void)pickerChoose:(NSInteger)index
{
    [self.tableView beginRefreshing];
}

-(MysugarView *)headView
{
    if (!_headView) {
        _headView = [[MysugarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeight(190))];
        
    }
    return _headView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.tableView.isRecvied = self.isRecevied;
    CoinWeakSelf;
    self.headView.clickBlock = ^{
        [weakSelf.filterPicker show];
    };
    self.headView.closeBlock = ^(BOOL isClose) {
        weakSelf.isClose = isClose;
        if (weakSelf.isRecevied ) {
            [weakSelf LoadData];

        }else{
            [weakSelf LoadSendData];

        }

    };
    [self loadYear];
  
}

- (void)loadYear
{
    TLNetworking *http = [TLNetworking new];
    http.code = @"623008";
    [http postWithSuccess:^(id responseObject) {
        self.year = self.textArr[0];
        self.textArr = responseObject[@"data"];
        self.tableView.tableHeaderView = self.headView;
        if (self.isRecevied == YES) {
            [self LoadData];

        }else{
            [self LoadSendData];

            }

    } failure:^(NSError *error) {
        
    }];
    
}

-(void)LoadSendData
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
            if (self.isClose == YES) {
                weakSelf.headView.total.text = [LangSwitcher switchLang:@"共发出红包" key:nil];
                weakSelf.headView.count.text = [NSString stringWithFormat:@"***"];
                
                weakSelf.sends = shouldDisplayCoins;
                weakSelf.tableView.isClose = weakSelf.isClose;

                weakSelf.tableView.sends = shouldDisplayCoins;
                [weakSelf.tableView reloadData_tl];
            }else{
                
                weakSelf.headView.total.text = [LangSwitcher switchLang:@"共发出红包" key:nil];
                weakSelf.headView.count.text = [NSString stringWithFormat:@"%ld",shouldDisplayCoins.count];
                
                weakSelf.sends = shouldDisplayCoins;
                weakSelf.tableView.isClose = weakSelf.isClose;

                weakSelf.tableView.sends = shouldDisplayCoins;
                [weakSelf.tableView reloadData_tl];
            }
           
            
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
            
            weakSelf.headView.total.text = [LangSwitcher switchLang:@"共发出红包" key:nil];
            weakSelf.headView.count.text = [NSString stringWithFormat:@"%ld",shouldDisplayCoins.count];
            weakSelf.sends = shouldDisplayCoins;
            
            weakSelf.tableView.sends = shouldDisplayCoins;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.tableView beginRefreshing];
}

-(void)LoadData
{

    CoinWeakSelf;

    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    if (![TLUser user].isLogin) {
        return;
    }
    helper.code = @"623007";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.parameters[@"year"] = self.year;

    helper.isList = NO;
    helper.isCurrency = YES;
    helper.tableView = self.tableView;
    [helper modelClass:[GetTheModel class]];

    [self.tableView addRefreshAction:^{

        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {

            //去除没有的币种
            NSLog(@" ==== %@",objs);

            NSMutableArray <GetTheModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
            [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

                GetTheModel *getModel = (GetTheModel *)obj;
                [shouldDisplayCoins addObject:getModel];

            }];
            weakSelf.tableView.isClose = weakSelf.isClose;

            //
            weakSelf.getthe = shouldDisplayCoins;
            if (weakSelf.isClose == YES) {
               
                weakSelf.headView.count.text = @"***";

            }else{
                
                weakSelf.headView.count.text = [NSString stringWithFormat:@"%ld",weakSelf.getthe.count];

            }
            weakSelf.tableView.getthe = shouldDisplayCoins;
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


            NSMutableArray <GetTheModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
            [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

                GetTheModel *gettheModel = (GetTheModel *)obj;
                //                if ([[CoinUtil shouldDisplayCoinArray] indexOfObject:currencyModel.currency ] != NSNotFound ) {

                [shouldDisplayCoins addObject:gettheModel];
                //                }

            }];
            weakSelf.tableView.isClose = weakSelf.isClose;

            //
            weakSelf.getthe = shouldDisplayCoins;

            weakSelf.tableView.getthe = shouldDisplayCoins;
            [weakSelf.tableView reloadData_tl];

        } failure:^(NSError *error) {


        }];

    }];

    [self.tableView beginRefreshing];
}

-(void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    SendVC *send = [[SendVC alloc] init];
    if (self.isRecevied == YES) {
        
        send.code = self.getthe[indexPath.row].redPacketInfo[@"code"];
        send.getModel = self.getthe[indexPath.row];
    }else{
        send.code = self.sends[indexPath.row].code;
        send.sen = self.sends[indexPath.row];
        send.isSend = YES;
    }
    [self.navigationController pushViewController:send animated:YES];
//    [self presentViewController:send animated:YES completion:nil];

//    [self.navigationController pushViewController:send animated:YES];
    
}



@end
