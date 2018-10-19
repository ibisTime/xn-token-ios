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
#import "FilterView.h"
#import "DetailSugarView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+Extension.h"

@interface SendVC ()<RefreshDelegate>
@property (nonatomic, strong) FilterView *filterPicker;
@property (nonatomic , strong)DetailSugarView *headView;

@property (nonatomic , strong)SendTableView *tableView;
@property (nonatomic, strong) NSMutableArray <SendModel *>*send;
@property (nonatomic, strong) SendModel *model;

@end

@implementation SendVC


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


-(UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[SendTableView alloc]
                          initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                          style:UITableViewStyleGrouped];

        self.tableView.backgroundColor = kWhiteColor;
        self.tableView.sectionHeaderHeight = 22;
        self.tableView.refreshDelegate =self;
    }
    return _tableView;
}

- (FilterView *)filterPicker {
    
    if (!_filterPicker) {
        
        CoinWeakSelf;
        
//        NSArray * textArr = self.textArr;
                NSArray *textArr = @[[LangSwitcher switchLang:@"2018" key:nil],
                                     [LangSwitcher switchLang:@"2017" key:nil],
                                      [LangSwitcher switchLang:@"2016" key:nil],
                                     ];
        
        NSArray *typeArr = @[@"tt",
                             @"charge",
                             ];
        
        _filterPicker = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];

        
        _filterPicker.selectBlock = ^(NSInteger index) {
            
            [weakSelf pickerChoose:index];
//            weakSelf.year = textArr[index];
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

-(DetailSugarView *)headView
{
    if (!_headView) {
        _headView = [[DetailSugarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeight(260))];
        
    }
    return _headView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [LangSwitcher switchLang:@"红包详情" key:nil];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;

    CoinWeakSelf;
    self.headView.clickBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
//        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    self.headView.shareBlock  = ^{
       
        if ([weakSelf.model.receivedNum floatValue] == [weakSelf.model.totalCount floatValue]) {
            return ;
        }
        SendModel *model = weakSelf.model;
        RedEnvelopeShoreVC *share = [RedEnvelopeShoreVC new];
        share.code = model.code;
        share.state = @"100";
        share.content = model.greeting;
        [weakSelf.navigationController setNavigationBarHidden:NO animated:YES];
        [weakSelf.navigationController pushViewController:share animated:YES];
//        [weakSelf presentViewController:share animated:YES completion:nil];
    };
    if (self.isSend == YES) {
        NSURL *u = [NSURL URLWithString:[self.sen.sendUserPhoto convertImageUrl]];
        [self.headView.back sd_setImageWithURL:u placeholderImage:kImage(@"头像")];
    }else{
        NSURL *u = [NSURL URLWithString:[self.getModel.redPacketInfo[@"sendUserPhoto"] convertImageUrl]];
        [self.headView.back sd_setImageWithURL:u placeholderImage:kImage(@"头像")];
        
    }
    [self LoadData];
}



-(void)LoadData
{

    CoinWeakSelf;

    TLNetworking *helper = [[TLNetworking alloc] init];
    if (![TLUser user].isLogin) {
        return;
    }
    helper.code = @"623006";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.parameters[@"code"] = self.code;
    [helper postWithSuccess:^(id responseObject) {
        
       
        
        SendModel *model = [SendModel mj_objectWithKeyValues:responseObject[@"data"]];
        if ([model.isReceived isEqualToString:@"1"]) {
            self.headView.shareBtn.hidden = YES;

        }else{
            self.headView.shareBtn.hidden = NO;

            }
        if ([model.receivedNum isEqualToString:model.sendNum]) {
            self.headView.shareBtn.hidden = YES;

        }else{
            self.headView.shareBtn.hidden = NO;

        }
        self.headView.total.text = [NSString stringWithFormat:@"%@/%@",model.receivedNum,model.sendNum];
        if (model.receivedCount.length >5) {
              self.headView.alltotal.text = [NSString stringWithFormat:@"%.4f/%@",[model.receivedCount floatValue],model.totalCount];
        }else{
            self.headView.alltotal.text = [NSString stringWithFormat:@"%@/%@",model.receivedCount,model.totalCount];
        }
      
        self.model = model;
        self.tableView.send = model.receiverList;
        [self.tableView reloadData_tl];
    } failure:^(NSError *error) {
        
    }
     ];

   
}
-(void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
   
}



@end
