//
//  SettingTableView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "SettingTableView.h"
#import "CoinHeader.h"
#import "SettingCell.h"

@interface SettingTableView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation SettingTableView

static NSString *identifierCell = @"SettingCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[SettingCell class] forCellReuseIdentifier:identifierCell];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.group.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.group.items = self.group.sections[section];
    
    return self.group.items.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    
    self.group.items = self.group.sections[indexPath.section];
    
    cell.textLabel.text = self.group.items[indexPath.row].text;
    
    cell.textLabel.textColor = kTextColor;
    
    cell.textLabel.font = Font(15.0);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.switchHidden = YES;
    
//    if (indexPath.section == 1) {
//
//        cell.arrowHidden = indexPath.row == 4 ? YES: NO;
//
//        cell.switchHidden = indexPath.row == 4 ? NO: YES;
//
//        cell.sw.on = YES;
//
//    } else {
//
//        cell.switchHidden = YES;
//
//        cell.arrowHidden = NO;
//
//    }
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.group.items = self.group.sections[indexPath.section];
    
    if (self.group.items[indexPath.row].action) {
        
        self.group.items[indexPath.row].action();
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

@end
