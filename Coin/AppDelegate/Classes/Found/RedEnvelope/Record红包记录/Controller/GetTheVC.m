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
@property (nonatomic, strong) FilterView *filterPicker1;
@property (nonatomic, strong) FilterView *filterPicker2;
@property (nonatomic , strong)MysugarView *headView;

@property (nonatomic, strong) NSMutableArray *textArr;

@property (nonatomic, copy) NSString *year;

@property (nonatomic, assign) BOOL isClose;

@property (nonatomic, strong)UIButton *chooseButton;

@end

@implementation GetTheVC

-(UIButton *)chooseButton
{
    if (!_chooseButton) {
        _chooseButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        _chooseButton.frame = CGRectMake(0, 0, 44, 44);
        [_chooseButton setImage:kImage(@"topbar_more") forState:(UIControlStateNormal)];
        [_chooseButton addTarget:self action:@selector(buttonMethod) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _chooseButton;
}

-(void)buttonMethod
{
    if (self.isRecevied == YES) {
        [self.filterPicker1 show];
    }else
    {
        [self.filterPicker2 show];
    }
}

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
        _filterPicker = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _filterPicker.selectBlock = ^(NSInteger index) {
            
            [weakSelf pickerChoose:index];
            weakSelf.year = textArr[index];
            [weakSelf.headView.tameBtn setTitle:[NSString stringWithFormat:@"%@%@",textArr[index],[LangSwitcher switchLang:@"年" key:nil]] forState:UIControlStateNormal];
        };
        
        _filterPicker.tagNames = textArr;
    }
    return _filterPicker;
}

- (FilterView *)filterPicker1 {
    
    if (!_filterPicker1) {
        
        CoinWeakSelf;
        NSArray * textArr;
        textArr = @[[LangSwitcher switchLang:@"我发出的" key:nil]];
//        NSArray * textArr = self.textArr;
        _filterPicker1 = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _filterPicker1.selectBlock = ^(NSInteger index) {
            weakSelf.isRecevied = NO;
            weakSelf.tableView.isRecvied = weakSelf.isRecevied;
            if (weakSelf.tableView.sends.count > 0) {
                weakSelf.tableView.sends = weakSelf.sends;
            }else
            {
                [weakSelf LoadSendData];
            }
            weakSelf.tableView.isClose = weakSelf.isClose;
            if (weakSelf.isClose == YES) {
                weakSelf.headView.count.text = @"***";
            }else{
                weakSelf.headView.count.text = [NSString stringWithFormat:@"%ld",weakSelf.sends.count];
            }
            [weakSelf.tableView reloadData];
            
            
//            weakSelf.filterPicker1.tagNames = textArr;
            
        };
        
        _filterPicker1.tagNames = textArr;
    }
    return _filterPicker1;
}

- (FilterView *)filterPicker2 {
    
    if (!_filterPicker2) {
        
        CoinWeakSelf;
        NSArray * textArr;
        textArr = @[[LangSwitcher switchLang:@"我收到的" key:nil]];
        //        NSArray * textArr = self.textArr;
        _filterPicker2 = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _filterPicker2.selectBlock = ^(NSInteger index) {
            weakSelf.isRecevied = YES;
            weakSelf.tableView.isRecvied = weakSelf.isRecevied;
            if (weakSelf.tableView.getthe.count > 0) {
                weakSelf.tableView.getthe = weakSelf.getthe;
            }else
            {
                [weakSelf LoadData];
            }
            weakSelf.tableView.isClose = weakSelf.isClose;
            if (weakSelf.isClose == YES) {
                weakSelf.headView.count.text = @"***";
            }else{
                weakSelf.headView.count.text = [NSString stringWithFormat:@"%ld",weakSelf.getthe.count];
            }
            [weakSelf.tableView reloadData];
            
        };
        
        _filterPicker2.tagNames = textArr;
    }
    return _filterPicker2;
}

- (void)pickerChoose:(NSInteger)index
{
    [self.tableView beginRefreshing];
}

-(MysugarView *)headView
{
    if (!_headView) {
        _headView = [[MysugarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 190)];
//        _headView.
    }
    return _headView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UILabel *label = [[UILabel alloc]init];
    label.text = [LangSwitcher switchLang:@"红包记录" key:nil];
    label.textColor = kTextBlack;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    self.navigationItem.titleView = label;
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:self.chooseButton]];

    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
    self.isClose = NO;
    self.isRecevied = NO;
    self.tableView.isRecvied = self.isRecevied;
    CoinWeakSelf;
    self.headView.clickBlock = ^{
        [weakSelf.filterPicker show];
    };
    self.headView.closeBlock = ^{
        weakSelf.isClose = !weakSelf.isClose;
        weakSelf.tableView.isClose = weakSelf.isClose;
        
        if (weakSelf.isRecevied == YES) {
            if (weakSelf.isClose == YES) {
                weakSelf.headView.count.text = @"***";
            }else{
                weakSelf.headView.count.text = [NSString stringWithFormat:@"%ld",weakSelf.getthe.count];
            }
        }
        else
        {
            if (weakSelf.isClose == YES) {
                weakSelf.headView.count.text = @"***";
            }else{
                weakSelf.headView.count.text = [NSString stringWithFormat:@"%ld",weakSelf.sends.count];
            }
        }
        
        
        
        [weakSelf.tableView reloadData];
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

            weakSelf.sends = shouldDisplayCoins;
            weakSelf.tableView.sends = shouldDisplayCoins;

            weakSelf.headView.total.text = [LangSwitcher switchLang:@"共发出红包" key:nil];
            weakSelf.tableView.isClose = weakSelf.isClose;
            //
            if (self.isClose == YES) {

                weakSelf.headView.count.text = [NSString stringWithFormat:@"***"];
                

            }else{
                

                weakSelf.headView.count.text = [NSString stringWithFormat:@"%ld",shouldDisplayCoins.count];
            }
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = kHexColor(@"#F5F5F8");
    self.navigationItem.backBarButtonItem = item;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}

//如果仅设置当前页导航透明，需加入下面方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = kHexColor(@"#0848DF");
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}



@end
