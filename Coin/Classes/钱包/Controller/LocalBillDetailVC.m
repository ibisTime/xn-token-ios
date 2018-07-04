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
    
    [self initTableView];
    //
    [self initHeaderView];
    
}

#pragma mark - Init
- (void)initHeaderView {
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    self.headerView.backgroundColor = kWhiteColor;
    //    self.tableView.tableHeaderView = self.headerView;
    UIImageView *icImage = [[UIImageView alloc] init];
    icImage.contentMode = UIViewContentModeScaleToFill;
    icImage.layer.cornerRadius = 25;
    icImage.clipsToBounds = YES;
    [self.headerView addSubview:icImage];
//    if ([self.currentModel.symbol isEqualToString:@"ETH"]) {
//        icImage.image = kImage(@"eth");
//    }else if ([self.currentModel.symbol isEqualToString:@"WAN"])
//    {
//        icImage.image = kImage(@"wan");
//
//    }
    
    [icImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@25);
        make.left.equalTo(@15);
        make.width.height.equalTo(@50);
    }];
    
    //账单类型
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:16.0];
    textLbl.textAlignment = NSTextAlignmentCenter;
    textLbl.numberOfLines = 0;
    [self.headerView addSubview:textLbl];
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
    [self.headerView addSubview:amountLbl];
    
    //分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kLineColor;
    [self.headerView addSubview:line];
    
    
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(self.headerView.mas_top).offset(15);
        //        make.centerX.equalTo(self.headerView.mas_centerX);
        make.left.equalTo(icImage.mas_right).offset(15);

    }];
    if ([_bill.direction isEqualToString:@"0"]) {
        textLbl.text = [LangSwitcher switchLang:@"转出" key:nil];
          icImage.image = kImage(@"提现");
            
            
     } else
        {
           
            icImage.image  = kImage(@"充值");
            textLbl.text = [LangSwitcher switchLang:@"转入" key:nil];

    }
    //
    [amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(textLbl.mas_bottom).offset(10);
        make.left.equalTo(icImage.mas_right).offset(15);
        
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(amountLbl.mas_bottom).offset(10);
        make.left.right.equalTo(self.headerView);
        make.height.mas_equalTo(0.5);
        
    }];
    
    //    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.width.mas_equalTo(SCREEN_WIDTH);
    //    }];
    
    [self.headerView layoutIfNeeded];
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, line.bottom);
    self.tableView.tableHeaderView = self.headerView;
    
}

- (void)initTableView {
    
    self.tableView = [[LocalBillDetailTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) style:UITableViewStylePlain];
    self.tableView.bill = self.bill;
    self.tableView.refreshDelegate = self;
    self.tableView.currentModel = self.currentModel;
    [self.view addSubview:self.tableView];
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
