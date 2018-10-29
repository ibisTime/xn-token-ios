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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.platforms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.isLocal == YES) {
        if (self.platforms.count >0) {
            CurrencyModel *platform = self.platforms[indexPath.row];
            
            
            AccountMoneyCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:platformCell1 forIndexPath:indexPath];
            cell.platform = platform;

            return cell;
        }else{
            return nil;
        }
    }else{
        if (self.platforms.count >0) {
            CurrencyModel *platform = self.platforms[indexPath.row];
            
            
            PlatformCell *cell = [tableView dequeueReusableCellWithIdentifier:platformCell forIndexPath:indexPath];
            cell.platform = platform;
            
            return cell;
        }else{
            
            
            return nil;
        }
        
    }
    
    
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectBlock(indexPath.row);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
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
