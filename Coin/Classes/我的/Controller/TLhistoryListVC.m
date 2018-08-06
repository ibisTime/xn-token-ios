//
//  TLhistoryListVC.m
//  Coin
//
//  Created by shaojianfei on 2018/8/4.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLhistoryListVC.h"
#import "QuestionListTableView.h"
#import "QuestionModel.h"
#import "QiestionDetailVC.h"
#import "TLPlaceholderView.h"
@interface TLhistoryListVC ()<RefreshDelegate>

@property (nonatomic ,strong) QuestionListTableView *tableView;
@property (nonatomic,strong) NSArray <QuestionModel *>*questions;

//@property (nonatomic, strong) UIView *placeHolderView;

@property (nonatomic, strong) UIView *placeHolderView;

@end

@implementation TLhistoryListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [LangSwitcher switchLang:@"历史反馈" key:nil];
    [self initTopView];
    
    [self loadList];
    // Do any additional setup after loading the view.
}
- (void)initTopView
{
    self.view.backgroundColor = kBackgroundColor;
    UIView *top = [[UIView alloc] init];
    [self.view addSubview:top];
    top.backgroundColor = kHexColor(@"#0848DF");
    
    [top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(kHeight(66)));
    }];
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(15, kHeight(150), kScreenWidth-30,  40)];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    textLbl.text = [LangSwitcher switchLang:@"暂无历史反馈" key:nil];
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.placeHolderView.mas_top).offset(150);
        make.centerX.equalTo(self.placeHolderView.mas_centerX);
        
    }];
    self.tableView = [[QuestionListTableView alloc]
                      initWithFrame:CGRectMake(15, 0, kScreenWidth-30, kSuperViewHeight-20)
                      style:UITableViewStyleGrouped];
    
    self.tableView.placeHolderView = self.placeHolderView;
    self.tableView.backgroundColor = kWhiteColor;
    self.tableView.refreshDelegate = self;
    
    self.tableView.sectionHeaderHeight = 22;
    [self.view addSubview:self.tableView];
    
    
}

- (void)loadList
{
    CoinWeakSelf;
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    if (![TLUser user].isLogin) {
        return;
    }
    helper.code = @"805107";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.parameters[@"start"] = @"1";
    helper.parameters[@"limit"] = @"10";

   
    helper.tableView = self.tableView;
    [helper modelClass:[QuestionModel class]];
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            if (objs.count == 0) {
                [weakSelf.tableView addSubview:weakSelf.placeHolderView];
                [weakSelf addPlaceholderView];

            }
            weakSelf.questions = objs;
            weakSelf.tableView.questions = objs;
            [weakSelf.tableView reloadData];
            NSLog(@"%@",objs);
            
        } failure:^(NSError *error) {
            
            [weakSelf addPlaceholderView];

        }];
        
        
        
    }];
    [self.tableView beginRefreshing];
    [self.tableView addLoadMoreAction:^{
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
        } failure:^(NSError *error) {
            
        }];
    }];
   
    
    
    
}


-(void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    QiestionDetailVC *d = [QiestionDetailVC new];
    d.code = self.questions[indexPath.row].code;
    [self.navigationController pushViewController:d animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)viewWillDisappear:(BOOL)animated{
//    
//    　　if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        
//        　　}
//    [super viewWillDisappear:animated];
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
