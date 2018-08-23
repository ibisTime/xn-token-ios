//
//  LocalBillDetailVC.m
//  Coin
//
//  Created by shaojianfei on 2018/6/15.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "LocalBillDetailVC.h"
#import "BillDetailTableView.h"
#import "TLUIHeader.h"
#import "CoinUtil.h"
#import "LocalBillDetailTableView.h"
#import "WalletLocalWebVC.h"
@interface LocalBillDetailVC ()<RefreshDelegate>
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) LocalBillDetailTableView *tableView;

@end

@implementation LocalBillDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [LangSwitcher switchLang:@"交易详情" key:nil];
    self.view.backgroundColor = kWhiteColor;
    TLDataBase *dataBase = [TLDataBase sharedManager];
    NSString *type;
    
    if ([dataBase.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT type from THALocal where symbol = '%@'",self.currentModel.symbol];
        //        [sql appendString:[TLUser user].userId];
        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
        while ([set next])
        {
            type = [set stringForColumn:@"type"];
            
        }
        [set close];
    }
    [dataBase.dataBase close];
    self.currentModel.type = type;
    [self initTableView];
    //
    [self initHeaderView];
    
    
}

#pragma mark - Init
- (void)initHeaderView {
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    topView.backgroundColor = kHexColor(@"#0848DF");
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(kHeight(66)));
    }];
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = kWhiteColor;
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@(kHeight(90)));
    }];
    //    self.tableView.tableHeaderView = self.headerView;
    UIImageView *icImage = [[UIImageView alloc] init];
    icImage.contentMode = UIViewContentModeScaleToFill;
//    icImage.layer.cornerRadius = 25;
//    icImage.clipsToBounds = YES;
    [self.headerView addSubview:icImage];
    icImage.image = kImage(@"提背景");
//    if ([self.currentModel.symbol isEqualToString:@"ETH"]) {
//        icImage.image = kImage(@"eth");
//    }else if ([self.currentModel.symbol isEqualToString:@"WAN"])
//    {
//        icImage.image = kImage(@"wan");
//
//    }
    
    [icImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.headerView.mas_top);
        make.left.equalTo(self.headerView.mas_left);
        make.right.equalTo(self.headerView.mas_right);
        make.bottom.equalTo(self.headerView.mas_bottom);

    }];
    
    //账单类型
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:16.0];
    textLbl.textAlignment = NSTextAlignmentCenter;
    textLbl.numberOfLines = 0;
    [icImage addSubview:textLbl];
//    textLbl.text = _bill.bizNote;
    
    
    NSString *onlyCountStr = [CoinUtil convertToRealCoin:_bill.value coin:_currentModel.symbol];
    CGFloat money = [onlyCountStr doubleValue];
    NSString *moneyStr = @"";
    //
    if ([_bill.direction isEqualToString:@"1"]) {
        
        moneyStr = [NSString stringWithFormat:@"+%@ %@", onlyCountStr, _currentModel.symbol];
        
    } else  {
        
        moneyStr = [NSString stringWithFormat:@"-%@ %@", onlyCountStr, _currentModel.symbol];
        
    }
    
    
    //金额
    UILabel *amountLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kAppCustomMainColor
                                                      font:20.0];
    amountLbl.text = moneyStr;
    [icImage addSubview:amountLbl];
    
    //分割线
//    UIView *line = [[UIView alloc] init];
//    line.backgroundColor = kLineColor;
//    [self.headerView addSubview:line];
    
    
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(icImage.mas_top).offset(19);
        make.centerX.equalTo(icImage.mas_centerX);

    }];
    if ([_bill.direction isEqualToString:@"0"]) {
        textLbl.text = [LangSwitcher switchLang:@"转出" key:nil];
        
            self.title =  [LangSwitcher switchLang:@"转出" key:nil];
     } else
        {
           
            textLbl.text = [LangSwitcher switchLang:@"转入" key:nil];
            self.title =  [LangSwitcher switchLang:@"转入" key:nil];

    }
    //
    [amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(textLbl.mas_bottom).offset(10);
        make.centerX.equalTo(icImage.mas_centerX);
        
    }];
    
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(amountLbl.mas_bottom).offset(10);
//        make.left.right.equalTo(self.headerView);
//        make.height.mas_equalTo(0.5);
//
//    }];
    
    //    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.width.mas_equalTo(SCREEN_WIDTH);
    //    }];
    
    [self.headerView layoutIfNeeded];
   
//    self.tableView.tableHeaderView = self.headerView;
    
}

- (void)initTableView {
    
    self.tableView = [[LocalBillDetailTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.bill = self.bill;
    self.tableView.refreshDelegate = self;
    self.tableView.currentModel = self.currentModel;
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -130, 0);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(90, 0, -0, 0));
        
    }];
    
//     self.tableView.contentSize = [self.tableView sizeThatFits:CGSizeMake(CGRectGetWidth(self.tableView.bounds), CGFLOAT_MAX)];
//    [self.tableView sizeThatFits:CGSizeMake(CGRectGetWidth(self.tableView.bounds), CGFLOAT_MAX)];
}

-(void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row != 6) {
        return;
    }
    WalletLocalWebVC *webVC = [WalletLocalWebVC new];
    webVC.urlString = self.bill.txHash;
    webVC.currentModel = self.currentModel;
    [self.navigationController pushViewController:webVC animated:YES];
    
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
