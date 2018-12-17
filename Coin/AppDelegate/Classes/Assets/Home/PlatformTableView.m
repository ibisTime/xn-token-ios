//
//  PlatformTableView.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PlatformTableView.h"
//V
#import "PlatformCell.h"
#import "AccountMoneyCellTableViewCell.h"
@interface PlatformTableView()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *arr;
}
@end

@implementation PlatformTableView

static NSString *platformAllCell = @"PlatformAllCell";
static NSString *platformPriceCell = @"PlatformPriceCell";
static NSString *platformCell = @"PlatformCell";
static NSString *platformCell1 = @"AccountMoneyCellTableViewCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[PlatformCell class] forCellReuseIdentifier:platformCell];
        [self registerClass:[AccountMoneyCellTableViewCell class] forCellReuseIdentifier:platformCell1];
    }
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.platforms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountMoneyCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:platformCell1 forIndexPath:indexPath];
    if ([self.isWallet isEqualToString:@"私钥钱包"])
    {
        cell.platform = self.platforms[indexPath.row];
    }else
    {
        cell.platform1 = self.platforms[indexPath.row];
    }
    return cell;
}

//设置cell可编辑状态
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//定义编辑样式为删除样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

//设置返回存放侧滑按钮数组
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //这是iOS8以后的方法
    UITableViewRowAction *transferBtn = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:[LangSwitcher switchLang:@"提币" key:nil] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:setCurrencyModel:setTitle:)]) {
            if ([self.isWallet isEqualToString:@"个人钱包"]) {
                [self.refreshDelegate refreshTableView:self setCurrencyModel:self.platforms[indexPath.row] setTitle:@"转账"];
            }else
            {
                [self.refreshDelegate refreshTableView:self setCurrencyModel:self.platforms[indexPath.row] setTitle:@"转账"];
            }
        }
    }];
    
    UITableViewRowAction *collectionBtn = [UITableViewRowAction  rowActionWithStyle:UITableViewRowActionStyleNormal title:[LangSwitcher switchLang:@"充币" key:nil] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:setCurrencyModel:setTitle:)]) {
            if ([self.isWallet isEqualToString:@"个人钱包"]) {
                [self.refreshDelegate refreshTableView:self setCurrencyModel:self.platforms[indexPath.row] setTitle:@"收款"];
            }else
            {
                [self.refreshDelegate refreshTableView:self setCurrencyModel:self.platforms[indexPath.row] setTitle:@"收款"];
            }
        }
    }];
    return @[transferBtn,collectionBtn];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectBlock(indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

@end
