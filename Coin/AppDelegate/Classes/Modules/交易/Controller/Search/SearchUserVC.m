//
//  SearchUserVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "SearchUserVC.h"

#import "TLTextField.h"

#import "NSString+Check.h"

#import "SearchResultVC.h"

@interface SearchUserVC ()

@property (nonatomic, strong) TLTextField *nickNameTF;

@end

@implementation SearchUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubciews];
}

#pragma mark - Init
- (void)initSubciews {
    
    //昵称
    self.nickNameTF = [[TLTextField alloc] initWithFrame:CGRectMake(5, 0, kScreenWidth - 5, 55)
                                               leftTitle:[LangSwitcher switchLang:@"用户昵称" key:nil]
                                              titleWidth:100
                                             placeholder:[LangSwitcher switchLang:@"请输入用户昵称" key:nil]];
    
    [self.view addSubview:self.nickNameTF];

    //分割线
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kLineColor;
    
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@20);
        make.right.equalTo(@(-20));
        make.top.equalTo(self.nickNameTF.mas_bottom);
        make.height.equalTo(@0.5);
        
    }];
    
    //搜昵称
    UIButton *searchBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"搜用户" key:nil]
                                         titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:16.0 cornerRadius:5];
    
    [searchBtn addTarget:self action:@selector(searchUser) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.height.equalTo(@45);
        make.top.equalTo(line.mas_bottom).offset(70);
        
    }];
}

#pragma mark - Events
- (void)searchUser {
    
    if (![self.nickNameTF.text valid]) {
        
        [TLAlert alertWithInfo: [LangSwitcher switchLang:@"请输入用户昵称" key:nil]];
        
        return ;
    }
    
    SearchResultVC *resultVC = [SearchResultVC new];
    
    resultVC.searchType = SearchTypeUser;
    
    resultVC.nickName = self.nickNameTF.text;
    
    [self.navigationController pushViewController:resultVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
