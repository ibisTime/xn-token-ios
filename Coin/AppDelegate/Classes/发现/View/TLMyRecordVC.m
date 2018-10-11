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
#import "CurrencyModel.h"
#import "TLPlaceholderView.h"
@interface TLMyRecordVC ()<RefreshDelegate>

@property (nonatomic ,strong) TLMyRecodeTB *tableView;
@property (nonatomic,strong) NSArray <TLtakeMoneyModel *>*Moneys;
@property (nonatomic ,strong) UIView *placeHolderView;


@end

@implementation TLMyRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getMyCurrencyList];
    
    
    // Do any additional setup after loading the view.
}

- (TLMyRecodeTB *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[TLMyRecodeTB alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        //        _tableView.placeHolderView = self.placeHolderView;
        _tableView.refreshDelegate = self;
        _tableView.backgroundColor = kWhiteColor;
        self.tableView.defaultNoDataImage = kImage(@"暂无订单");
        _tableView.defaultNoDataText = [LangSwitcher switchLang:@"暂无明细" key:nil];
        [self.view addSubview:_tableView];
//        [self initPliceHodel];
//        self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, kScreenWidth,  40)];

//        UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
//
//        textLbl.text = [LangSwitcher switchLang:@"暂无明细" key:nil];
//        textLbl.textAlignment = NSTextAlignmentCenter;
//
//        [self.placeHolderView addSubview:textLbl];
//        [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.top.equalTo(self.placeHolderView.mas_top).offset(150);
//            make.centerX.equalTo(self.placeHolderView.mas_centerX);
//
//        }];
//        [self.view addSubview:self.placeHolderView];
//        self.placeHolderView.hidden = YES;
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
- (void)getMyCurrencyList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"625526";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.isCurrency = YES;
    helper.tableView = self.tableView;
    [helper modelClass:[TLtakeMoneyModel class]];
    [self.tableView addRefreshAction:^{
        
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            if (objs.count == 0) {
                weakSelf.placeHolderView.hidden = NO;
                return ;
            }
            weakSelf.placeHolderView.hidden = YES;

            NSMutableArray *mod = [NSMutableArray array];
            for (int i = 0; i < objs.count; i++) {
                TLtakeMoneyModel *model =objs[i];
                TLtakeMoneyModel *m = [TLtakeMoneyModel mj_objectWithKeyValues:model.productInfo];
                model.produceModel = m;
                
                [mod addObject:model];

            }
            //去除没有的币种
            
            
            weakSelf.Moneys = mod;
            weakSelf.tableView.Moneys = mod;
            [weakSelf.tableView reloadData];
            
        } failure:^(NSError *error) {
            weakSelf.placeHolderView.hidden = NO;

            
        }];
        
        
        
    }];
    
    [self.tableView beginRefreshing];
    
    [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
        
        if (weakSelf.tl_placeholderView.superview != nil) {
            
            [weakSelf removePlaceholderView];
        }
        NSMutableArray *mod = [NSMutableArray array];
        for (int i = 0; i < objs.count; i++) {
            TLtakeMoneyModel *model =objs[i];
            TLtakeMoneyModel *m = [TLtakeMoneyModel mj_objectWithKeyValues:model.productInfo];
            model.produceModel = m;
            
            [mod addObject:model];
            
        }
        //去除没有的币种
        
        
        weakSelf.Moneys = mod;
        weakSelf.tableView.Moneys = mod;
        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
        [weakSelf addPlaceholderView];
        
    }];
    
    
}

-(void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RecodeDetailVC *vc = [RecodeDetailVC new];
    vc.moneyModel = self.Moneys[indexPath.row];
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
