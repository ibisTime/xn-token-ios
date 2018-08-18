//
//  TLMyRecordVC.m
//  Coin
//
//  Created by shaojianfei on 2018/8/18.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLMyRecordVC.h"
#import "TLMyRecodeTB.h"
#import "TLtakeMoneyModel.h"
#import "RecodeDetailVC.h"
@interface TLMyRecordVC ()<RefreshDelegate>

@property (nonatomic ,strong) TLMyRecodeTB *tableView;
@property (nonatomic,strong) NSArray <TLtakeMoneyModel *>*Moneys;

@end

@implementation TLMyRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initPliceHodel];
    TLtakeMoneyModel *m = [TLtakeMoneyModel new];
    m.name = @"币币赢第一期";
    m.symbol = @"BTC";
    m.expectYield = @"0.07";
    m.minAmount = @"100";
    m.limitAmount = @"500";
    m.limitDays = @"360";
    m.avilAmount = @"1000";
    
    TLtakeMoneyModel *m1 = [TLtakeMoneyModel new];
    m1.name = @"币币赢第二期";
    m1.symbol = @"BTC";
    m1.expectYield = @"0.12";
    m1.minAmount = @"1000";
    m1.limitAmount = @"5000";
    
    m1.limitDays = @"129";
    m1.avilAmount = @"10000";
    self.tableView.Moneys = @[m,m1];
    self.Moneys = self.tableView.Moneys;
    [self.tableView reloadData];
    
    
    // Do any additional setup after loading the view.
}

- (TLMyRecodeTB *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[TLMyRecodeTB alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        //        _tableView.placeHolderView = self.placeHolderView;
        _tableView.refreshDelegate = self;
        _tableView.backgroundColor = kWhiteColor;
        
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 15, 0, 15));
        }];
        
    }
    return _tableView;
}

- (void)initPliceHodel {
    self.view.backgroundColor = kWhiteColor;
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    topView.backgroundColor = kHexColor(@"#0848DF");
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(kHeight(66)));
    }];
}

-(void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RecodeDetailVC *vc = [RecodeDetailVC new];
    vc.moneyModel = self.Moneys[indexPath.section];
    vc.title = [LangSwitcher switchLang:@"我的理财" key:nil];
    [self.navigationController pushViewController:vc animated:YES];
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
