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
        make.height.equalTo(@45);
    }];

    self.headerView = [[UIView alloc] init];
    self.headerView.layer.cornerRadius=5;
    self.headerView.layer.shadowOpacity = 0.22;// 阴影透明度
    self.headerView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    self.headerView.layer.shadowRadius=3;// 阴影扩散的范围控制
    self.headerView.layer.shadowOffset=CGSizeMake(1, 1);// 阴影的范围
    self.headerView.backgroundColor = kWhiteColor;
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(10);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@90);
    }];

    UIImageView *icImage = [[UIImageView alloc] init];
    icImage.contentMode = UIViewContentModeScaleToFill;
    [self.headerView addSubview:icImage];
    icImage.image = kImage(@"提背景");
    
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
    
    
    
    
    //金额
    UILabel *amountLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kAppCustomMainColor
                                                      font:20.0];
    
    [icImage addSubview:amountLbl];
    
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(icImage.mas_top).offset(20);
        make.centerX.equalTo(icImage.mas_centerX);

    }];
    
    
    
    NSString *onlyCountStr;
    NSString *moneyStr = @"";
    //
    if ([_currentModel.symbol isEqualToString:@"USDT"]) {
        onlyCountStr = [CoinUtil convertToRealCoin:_usdtModel.amount
                                              coin:self.currentModel.symbol];
        if ([@"1x6YnuBVeeE65dQRZztRWgUPwyBjHCA5g" isEqualToString:_usdtModel.sendingAddress]) {
            moneyStr = [NSString stringWithFormat:@"%@ %@", onlyCountStr, self.currentModel.symbol];
            textLbl.text = [LangSwitcher switchLang:@"转入" key:nil];
            self.title =  [LangSwitcher switchLang:@"转入" key:nil];
        }else
        {
            moneyStr = [NSString stringWithFormat:@"-%@ %@", onlyCountStr, self.currentModel.symbol];
            textLbl.text = [LangSwitcher switchLang:@"转出" key:nil];
            self.title =  [LangSwitcher switchLang:@"转出" key:nil];
        }
    }else
    {
        onlyCountStr = [CoinUtil convertToRealCoin:_bill.value coin:_currentModel.symbol];
        if ([_bill.direction isEqualToString:@"1"]) {
            moneyStr = [NSString stringWithFormat:@"+%@ %@", onlyCountStr, _currentModel.symbol];
            textLbl.text = [LangSwitcher switchLang:@"转入" key:nil];
            self.title =  [LangSwitcher switchLang:@"转入" key:nil];
        } else  {
            moneyStr = [NSString stringWithFormat:@"-%@ %@", onlyCountStr, _currentModel.symbol];
            textLbl.text = [LangSwitcher switchLang:@"转出" key:nil];
            self.title =  [LangSwitcher switchLang:@"转出" key:nil];
        }
    }
    amountLbl.text = moneyStr;
    
    //
    [amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(textLbl.mas_bottom).offset(10);
        make.centerX.equalTo(icImage.mas_centerX);
        
    }];
    
    [self.headerView layoutIfNeeded];
}



- (void)initTableView {
    
    self.tableView = [[LocalBillDetailTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.bill = self.bill;
    self.tableView.usdtModel = self.usdtModel;
    self.tableView.refreshDelegate = self;
    self.tableView.currentModel = self.currentModel;
    
    self.tableView.frame = CGRectMake(0, 110, SCREEN_WIDTH, SCREEN_HEIGHT - 110 - kNavigationBarHeight);
    [self.view addSubview:self.tableView];
}

-(void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row != 6) {
        return;
    }
    WalletLocalWebVC *webVC = [WalletLocalWebVC new];
    if ([self.currentModel.symbol isEqualToString:@"USDT"]) {
        webVC.urlString = self.usdtModel.txid;
    }else
    {
        webVC.urlString = self.bill.txHash;
    }
    
    webVC.currentModel = self.currentModel;
    [self.navigationController pushViewController:webVC animated:YES];
    
    
}


@end
