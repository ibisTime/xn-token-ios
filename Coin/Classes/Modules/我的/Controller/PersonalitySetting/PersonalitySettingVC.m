//
//  PersonalitySettingVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/12/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "PersonalitySettingVC.h"

#import "CoinHeader.h"

#import "SettingGroup.h"
#import "SettingModel.h"
#import "PersonalModel.h"

#import "SettingCell.h"
#import "PersonalitySettingTableView.h"

@interface PersonalitySettingVC ()
//
@property (nonatomic, strong) SettingGroup *group;
//
@property (nonatomic, strong) PersonalitySettingTableView *tableView;
//自动好评
@property (nonatomic, assign) BOOL isAutoPraise;
//自动加好友
@property (nonatomic, assign) BOOL isAutoAddFriend;

@end

@implementation PersonalitySettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [LangSwitcher switchLang:@"个性设置" key:nil];
    //
    [self setGroup];
    //
    [self initTableView];
    //查询用户设置
    [self queryUserSetting];

}

#pragma mark - Init

- (void)initTableView {
    
    self.tableView = [[PersonalitySettingTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) style:UITableViewStyleGrouped];
    
    self.tableView.group = self.group;
    
    [self.view addSubview:self.tableView];
    
}

- (void)setGroup {
    
    CoinWeakSelf;
    
    //自动好评
    SettingModel *autoPraise = [SettingModel new];
    
    autoPraise.text = [LangSwitcher switchLang:@"自动好评" key:nil];
    
    [autoPraise setAction:^{
        
        [weakSelf setAutoPraise];
    }];
    
    
    //自动加好友
    SettingModel *autoAddFriend = [SettingModel new];
    
    autoAddFriend.text = [LangSwitcher switchLang:@"自动加信任" key:nil];
    [autoAddFriend setAction:^{
        
        [weakSelf setAutoAddFriend];
        
    }];
    
    //语言设置
    SettingModel *languageSetting = [SettingModel new];
    
    languageSetting.text = [LangSwitcher switchLang:@"语言设置" key:nil];
    [languageSetting setAction:^{
        
        
    }];
    
    self.group = [SettingGroup new];
    
    self.group.sections = @[@[autoPraise, autoAddFriend], @[languageSetting]];
    
}

#pragma mark - Events

- (void)setAutoPraise {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    SettingCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    //type("1", "设置自动好评"), ("2",设置自动信任）
    //opType(0=添加设置，1=取消设置)
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625300";
    http.showView = self.view;
    http.parameters[@"type"] = @"1";
    http.parameters[@"opType"] = _isAutoPraise ? @"1": @"0";
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        _isAutoPraise = !_isAutoPraise;
        
        cell.sw.on = _isAutoPraise;
        
        NSString *title = _isAutoPraise ? @"自动好评开启成功": @"自动好评关闭成功";
        
        [TLAlert alertWithSucces:[LangSwitcher switchLang:title key:nil]];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)setAutoAddFriend {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    
    SettingCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    //type("1", "设置自动好评"), ("2",设置自动信任）
    //opType(0=添加设置，1=取消设置)
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625300";
    http.showView = self.view;
    http.parameters[@"type"] = @"2";
    http.parameters[@"opType"] = _isAutoAddFriend ? @"1": @"0";
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        _isAutoAddFriend = !_isAutoAddFriend;
        
        cell.sw.on = _isAutoAddFriend;
        
        NSString *title = _isAutoAddFriend ?
        [LangSwitcher switchLang:@"自动加信任开启成功" key:nil] :
        [LangSwitcher switchLang:@"自动加信任关闭成功" key:nil];
        
        [TLAlert alertWithSucces:[LangSwitcher switchLang:title key:nil]];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)queryUserSetting {
    
    //type("1", "设置自动好评"), ("2",设置自动信任）

    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.isList = YES;
    
    helper.code = @"625301";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.showView = self.view;
    
    [helper modelClass:[PersonalModel class]];
    
    [helper refresh:^(NSMutableArray <PersonalModel *>*objs, BOOL stillHave) {
        
        [objs enumerateObjectsUsingBlock:^(PersonalModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.type isEqualToString:kAutoPraise]) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                
                SettingCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                _isAutoPraise = [obj.value isEqualToString:@"1"] ? YES: NO;
                
                cell.sw.on = _isAutoPraise;
                
            } else if ([obj.type isEqualToString:kAutoAddFriend]) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                
                SettingCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                _isAutoAddFriend = [obj.value isEqualToString:@"1"] ? YES: NO;
                
                cell.sw.on = _isAutoAddFriend;
            }
            
        }];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
