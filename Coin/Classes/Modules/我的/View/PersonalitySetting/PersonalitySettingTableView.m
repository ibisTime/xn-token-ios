//
//  PersonalitySettingTableView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/12/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "PersonalitySettingTableView.h"

#import "CoinHeader.h"
#import "SettingCell.h"

@interface PersonalitySettingTableView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation PersonalitySettingTableView

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
    
    SettingModel *settingModel = self.group.items[indexPath.row];
    cell.textLabel.text = settingModel.text;
    
    cell.textLabel.textColor = kTextColor;
    cell.textLabel.font = Font(15.0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (settingModel.subText) {
        cell.rightLabel.text = settingModel.subText;
    }
    
    cell.sw.on = NO;
    
    cell.sw.tag = 1600 + indexPath.row;
    
    [cell.sw addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
    
    cell.switchHidden = indexPath.section == 0 ? NO: YES;
    
    cell.arrowHidden = indexPath.section == 0 ? YES: NO;
    
    return cell;
    
}

- (void)switchDidChange:(UISwitch *)sender {
    
    NSInteger index = sender.tag - 1600;
    
    self.group.items = self.group.sections[0];

    if (self.group.items[index].action) {
        
        self.group.items[index].action();

    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.group.items = self.group.sections[indexPath.section];
    
    if (self.group.items[indexPath.row].action && indexPath.section == 1) {
        
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}
@end
