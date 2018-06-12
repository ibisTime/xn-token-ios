//
//  TLAccountTableView.m
//  Coin
//
//  Created by shaojianfei on 2018/6/11.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLAccountTableView.h"
#import "PlatformCell.h"
#import "AccountMoneyCellTableViewCell.h"
@interface TLAccountTableView()<UITableViewDelegate, UITableViewDataSource>


@end
static NSString *platformAllCell = @"PlatformAllCell";
static NSString *platformPriceCell = @"PlatformPriceCell";
static NSString *platformCell = @"AccountMoneyCellTableViewCell";

@implementation TLAccountTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        //全部平台
        
        //具体平台
        [self registerClass:[AccountMoneyCellTableViewCell class] forCellReuseIdentifier:platformCell];
    }
    
    return self;
}
#pragma mark - UITableViewDataSource;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.platforms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CurrencyModel *platform = self.platforms[indexPath.row];
    
    
    
    PlatformCell *cell = [tableView dequeueReusableCellWithIdentifier:platformCell forIndexPath:indexPath];
    
    cell.platform = platform;
    cell.backgroundColor = indexPath.row%2 == 0 ? kBackgroundColor: kWhiteColor;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CurrencyModel *platform = self.platforms[indexPath.row];
    self.selectBlock(indexPath.row);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 85;
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
