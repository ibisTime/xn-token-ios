//
//  LocalSettingTableView.m
//  Coin
//
//  Created by shaojianfei on 2018/7/30.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "LocalSettingTableView.h"
#import "SettingCell.h"
#import "ZLGestureLockViewController.h"

@interface LocalSettingTableView ()<UITableViewDataSource, UITableViewDelegate>

@end
static NSString *identifierCell = @"SettingCell";

@implementation LocalSettingTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        //        self.backgroundColor = kWhiteColor;
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
    
    CoinWeakSelf;
    cell.SwitchBlock = ^(NSInteger switchBlock) {
        if (self.SwitchBlock) {
            self.SwitchBlock(switchBlock);
        }
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.switchHidden = YES;
    cell.iconImageView.hidden = YES;
//    cell.textLabel.text = settingModel.text;
//    cell.textLabel.textColor = kTextColor;
//    cell.textLabel.font = Font(15.0);
    
    cell.settingModel = settingModel;
    if (settingModel.subText) {

        cell.rightLabel.text = settingModel.subText;

    }
    
//    cell.rightLabel.text = @"test";
    if (indexPath.section == 1 & indexPath.row == 1) {
        if ([settingModel.text isEqualToString:@"删除钱包"] || settingModel.isSetting == YES) {
            
        }else{
            NSString* gesture  =  [ZLGestureLockViewController gesturesPassword];
            if (gesture.length >0) {
                cell.switchHidden = NO;
                cell.arrowHidden = YES;

                cell.sw.on = YES;
            }else{
                
                cell.switchHidden = NO;
                cell.arrowHidden = YES;
                cell.sw.on = NO;
                
            }
        }
       
        //        cell.userInteractionEnabled = NO;
    }
//    if (settingModel.isVersion == YES) {
//        UILabel *lab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
//        lab.textAlignment = NSTextAlignmentRight;
//        
//        [cell addSubview:lab];
//        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(cell.mas_centerX);
//            make.right.equalTo(cell.mas_right).offset(20);
//        }];
//        
//        cell.rightLabel.text = @"版本号";
//    }
    //
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.settingModel = settingModel;
    
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
    
    return 55;
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
