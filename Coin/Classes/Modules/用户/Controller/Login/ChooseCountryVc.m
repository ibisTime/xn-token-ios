//
//  ChooseCountryVc.m
//  Coin
//
//  Created by shaojianfei on 2018/7/1.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "ChooseCountryVc.h"
#import "TLNetworking.h"
@interface ChooseCountryVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray <CountryModel *>*countrys;
@property (nonatomic,strong) UITableView *tableView;


@end

@implementation ChooseCountryVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    UIButton *cancelBtn = [UIButton buttonWithImageName:@"cancel"];
    self.cancelBtn = cancelBtn;
    [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(kStatusBarHeight+20));
        make.left.equalTo(@5);
        make.width.equalTo(@50);
        make.height.equalTo(@25);
        
        
    }];
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    view.backgroundColor = kLineColor;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cancelBtn.mas_bottom).offset(10);
        make.left.equalTo(@5);
        make.right.equalTo(@-5);
        make.height.equalTo(@2);
        
        
    }];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, kStatusBarHeight+70, kScreenWidth-30, kScreenHeight - kStatusBarHeight -kTabBarHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    /** 去掉分割线 */
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    tableView.backgroundColor = kBackgroundColor;
    [self.view addSubview:tableView];
    [self loadData];
    UILabel *titleLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kBlackColor font:15];
    [self.view addSubview:titleLab];
    titleLab.text = [LangSwitcher switchLang:@"选择国家" key:nil];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kStatusBarHeight+20));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    self.title = [LangSwitcher switchLang:@"选择国家" key:nil];
    // Do any additional setup after loading the view.
}

- (void)loadData
{
    
   
    TLNetworking *net = [TLNetworking new];
    net.showView = self.view;
    net.code = @"801120";
    net.isLocal = YES;
    net.ISparametArray = YES;
    net.parameters[@"status"] = @"1";
    [net postWithSuccess:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        self.countrys = [CountryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.tableView reloadData];
//        NSString *str = [NSString stringWithFormat:@"%@", responseObject[@"data"]];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"RealNameAuthResult" object:str];
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
    
}
- (void)clickCancel
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.countrys.count;
    
}
static NSString *IdCell = @"country";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:IdCell];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdCell forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IdCell];
    }
     cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.textLabel.text = [NSString stringWithFormat:@"%@    +%@",self.countrys[indexPath.row].chineseName,[self.countrys[indexPath.row].interCode substringFromIndex:2]];
    cell.detailTextLabel.text = self.countrys[indexPath.row].interCode;
    cell.backgroundColor = kClearColor;
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = kLineColor;
    [cell addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cell.mas_bottom).offset(0);
        make.left.equalTo(@5);
        make.right.equalTo(@-5);
        make.height.equalTo(@1);

    }];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.selectCountry) {
        self.selectCountry(self.countrys[indexPath.row]);
    }
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
