//
//  SearchCountriesVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/14.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "SearchCountriesVC.h"
#import "ContactModel.h"
#import "ContactTableViewCell.h"
#import "ContactDataHelper.h"//根据拼音A~Z~#进行排序的tool
#import "TheInitialVC.h"
@interface SearchCountriesVC ()<UITableViewDelegate,UITableViewDataSource,
UISearchBarDelegate,UISearchDisplayDelegate>
{
    NSArray *_rowArr;//row arr
    NSArray *_sectionArr;//section arr
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *serverDataArr;//数据源
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) UISearchBar *searchBar;//搜索框
@property (nonatomic,strong) UISearchDisplayController *searchDisplayController;//搜索VC


@end

@implementation SearchCountriesVC{
    NSMutableArray *_searchResultArr;//搜索结果Arr
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = item;
    //    self.navigationController.navigationBar.shadowImage = [UIImage new];
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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(kScreenWidth/2-60, 0, 120, 50)];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.backgroundColor = [UIColor clearColor];
    titleText.textColor=kTextColor;
    [titleText setFont:[UIFont systemFontOfSize:17.0]];
    [titleText setText:[LangSwitcher switchLang:@"选择国家和地区" key:nil]];
    self.navigationItem.titleView=titleText;
    
    [self loadData];
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
        self.serverDataArr = responseObject[@"data"];
//        self.countrys = [CountryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        //        NSString *str = [NSString stringWithFormat:@"%@", responseObject[@"data"]];
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"RealNameAuthResult" object:str];
        
        self.dataArr=[NSMutableArray array];
        for (NSDictionary *subDic in self.serverDataArr) {
            ContactModel *model=[[ContactModel alloc]initWithDic:subDic];
            [self.dataArr addObject:model];
        }
        
        _rowArr=[ContactDataHelper getFriendListDataBy:self.dataArr];
        _sectionArr=[ContactDataHelper getFriendListSectionBy:[_rowArr mutableCopy]];
        
        [self.view addSubview:self.tableView];
        
        _searchDisplayController=[[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
        [_searchDisplayController setDelegate:self];
        [_searchDisplayController setSearchResultsDataSource:self];
        [_searchDisplayController setSearchResultsDelegate:self];
        
        _searchResultArr=[NSMutableArray array];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        
    }];
}

-(UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        _searchBar.backgroundColor = [UIColor whiteColor];
        [_searchBar setPlaceholder:[LangSwitcher switchLang:@"搜索" key:nil]];
        [_searchBar setDelegate:self];
        [[[[_searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
        [_searchBar setBackgroundColor:[UIColor whiteColor]];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 43, SCREEN_WIDTH - 30, 1)];
        lineView.backgroundColor = kLineColor;
        [_searchBar addSubview:lineView];
    }
    return _searchBar;
}




- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.3 animations:^{
        //        self.navigationController.navigationBarHidden = YES;
        //        _searchBar.frame = CGRectMake(0, 20, kScreenWidth, 44);
        _searchBar.showsCancelButton = YES;
        
        for (id obj in [searchBar subviews]) {
            if ([obj isKindOfClass:[UIView class]]) {
                for (id obj2 in [obj subviews]) {
                    if ([obj2 isKindOfClass:[UIButton class]]) {
                        UIButton *btn = (UIButton *)obj2;
                        [btn setTitle:[LangSwitcher switchLang:@"取消" key:nil] forState:UIControlStateNormal];
                        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                         btn.titleLabel.font = FONT(16);
                    }
                }
            }
        }
        
    }];
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.0, 0.0, kScreenWidth, kScreenHeight-kNavigationBarHeight) style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
        [_tableView setSectionIndexColor:[UIColor darkGrayColor]];
        [_tableView setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]];
        _tableView.tableHeaderView=self.searchBar;
        //cell无数据时，不显示间隔线
        UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView setTableFooterView:v];
    }
    return _tableView;
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //section
    if (tableView==_searchDisplayController.searchResultsTableView) {
        return 1;
    }else{
        return _rowArr.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //row
    if (tableView==_searchDisplayController.searchResultsTableView) {
        return _searchResultArr.count;
    }else{
        return [_rowArr[section] count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [UILabel labelWithFrame:CGRectMake(12, 5, SCREEN_WIDTH - 24, 30) textAligment:(NSTextAlignmentLeft) backgroundColor:RGB(247, 247, 247) font:FONT(14) textColor:kHexColor(@"#acacac")];
    [label setText:[NSString stringWithFormat:@"      %@",_sectionArr[section+1]]];
    kViewRadius(label, 5);
    [view addSubview:label];
    
    return view;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView!=_searchDisplayController.searchResultsTableView) {
        return _sectionArr;
    }else{
        return nil;
    }
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index-1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==_searchDisplayController.searchResultsTableView) {
        return 0;
    }else{
        return 40;
    }
}

#pragma mark - UITableView dataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIde=@"cellIde";
    ContactTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell=[[ContactTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (tableView==_searchDisplayController.searchResultsTableView){
        [cell.nameLabel setText:[NSString stringWithFormat:@"%@ (+%@)",[LangSwitcher switchLang:[_searchResultArr[indexPath.row] valueForKey:@"chineseName"] key:nil],[[_searchResultArr[indexPath.row] valueForKey:@"interCode"] substringFromIndex:2]]];

    }else{
        ContactModel *model=_rowArr[indexPath.section][indexPath.row];
//        [cell.headImageView setImage:[UIImage imageNamed:model.chineseName]];
        [cell.nameLabel setText:[NSString stringWithFormat:@"%@ (+%@)",[LangSwitcher switchLang:model.chineseName key:nil],[model.interCode substringFromIndex:2]]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ContactModel *model;
    if (tableView==_searchDisplayController.searchResultsTableView){
        model = _searchResultArr[indexPath.row];
//        ContactModel *model=_rowArr[indexPath.section][indexPath.row];
        for ( int i = 0 ; i < self.serverDataArr.count ; i ++) {
            if ([[_searchResultArr[indexPath.row] valueForKey:@"chineseName"] isEqual:self.serverDataArr[i][@"chineseName"]]) {
                model = [ContactModel mj_objectWithKeyValues:self.serverDataArr[i]];
            }
        }
    }else{
        model=_rowArr[indexPath.section][indexPath.row];
    }
    
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"chooseModel"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"chooseCoutry"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *money ;
    
    if ([TLUser user].isLogin == NO) {
        TheInitialVC *log = [TheInitialVC new];
        TLNavigationController *na = [[TLNavigationController alloc] initWithRootViewController:log];
        //            log.IsAPPJoin = YES;
        if ([model.interSimpleCode isEqualToString:@"CN"] ||[model.interSimpleCode isEqualToString:@"HK"] ||[model.interSimpleCode isEqualToString:@"TW"] || [model.interSimpleCode isEqualToString:@"MO"]) {
            [LangSwitcher changLangType:LangTypeSimple];
            money = @"CNY";
            
            [UIApplication sharedApplication].keyWindow.rootViewController = na;
        }else if ([model.interSimpleCode isEqualToString:@"KR"])
        {
            [LangSwitcher changLangType:LangTypeKorean];
            money = @"KRW";
            
            [UIApplication sharedApplication].keyWindow.rootViewController = na;
            
        }else{
            
            [LangSwitcher changLangType:LangTypeEnglish];
            money = @"USD";
            [UIApplication sharedApplication].keyWindow.rootViewController = na;
        }
        [[NSUserDefaults standardUserDefaults] setObject:money forKey:KLocalMoney];
    }
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    //取消
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
}

#pragma mark searchDisplayController delegate
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{
    //cell无数据时，不显示间隔线
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [tableView setTableFooterView:v];

}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString
                               scope:[self.searchBar scopeButtonTitles][self.searchBar.selectedScopeButtonIndex]];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self filterContentForSearchText:self.searchBar.text
                               scope:self.searchBar.scopeButtonTitles[searchOption]];
    return YES;
}

#pragma mark - 源字符串内容是否包含或等于要搜索的字符串内容
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSMutableArray *tempResults = [NSMutableArray array];
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    
    for (int i = 0; i < self.dataArr.count; i++) {
        NSString *storeString = [(ContactModel *)self.dataArr[i] chineseName];
        NSString *storeImageString=[(ContactModel *)self.dataArr[i] interCode];
        
        NSRange storeRange = NSMakeRange(0, storeString.length);
        
        NSRange foundRange = [storeString rangeOfString:searchText options:searchOptions range:storeRange];
        if (foundRange.length) {
            NSDictionary *dic=@{@"chineseName":storeString,@"interCode":storeImageString};
            [tempResults addObject:dic];
        }
        
    }
    [_searchResultArr removeAllObjects];
    [_searchResultArr addObjectsFromArray:tempResults];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
