//
//  TLRedintroduceVC.m
//  Coin
//
//  Created by shaojianfei on 2018/9/17.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLRedintroduceVC.h"
#import "RedIntroduceTB.h"
#import "RedModel.h"
#import "RedIntroduce.h"
#import "NewHtmlVC.h"
#import "H5DrtailVC.h"
@interface TLRedintroduceVC ()<RefreshDelegate>
@property (nonatomic, strong) NSMutableArray <RedModel *>*redModels;
@property (nonatomic, strong) RedIntroduceTB *tableView;

@property (nonatomic, strong) RedIntroduce *headView;

@end

@implementation TLRedintroduceVC

-(RedIntroduce *)headView
{
    if (!_headView) {
        _headView = [[RedIntroduce alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeight(190))];
        
    }
    return _headView;
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[RedIntroduceTB alloc]
                          initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 70)
                          style:UITableViewStyleGrouped];
        
        _tableView.backgroundColor = kWhiteColor;
        _tableView.sectionHeaderHeight = 22;
        
        _tableView.refreshDelegate = self;
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [LangSwitcher switchLang:@"Theia红包说明" key:nil];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
    
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)loadData {
    
    TLNetworking *net = [TLNetworking new];
    net.code = @"625413";
    net.parameters[@"code"] = @"dapp20180809001";
    [net postWithSuccess:^(id responseObject) {
        [self.headView.contentWeb loadHTMLString:responseObject[@"data"][@"dapp"][@"description"] baseURL:nil];
        self.redModels = [RedModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"helpList"]];
        self.tableView.redModels = self.redModels;
        [self.tableView reloadData];
        if (self.redModels.count > 0) {
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}


-(void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RedModel *model = self.redModels[indexPath.row];
     H5DrtailVC *detail = [[H5DrtailVC alloc] init];
    detail.h5 = model.answer;
//    [detail.contentWeb loadHTMLString:model.answer baseURL:nil];
//    detail.name = model.question;
    [self.navigationController pushViewController:detail animated:YES];
    
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
