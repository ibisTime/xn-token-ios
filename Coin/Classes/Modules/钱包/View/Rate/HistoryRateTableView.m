//
//  HistoryRateTableView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/30.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "HistoryRateTableView.h"

#import "HistoryRateCell.h"

@interface HistoryRateTableView ()<UITableViewDelegate, UITableViewDataSource>


@end

@implementation HistoryRateTableView

static NSString *identifierCell = @"HistoryRateCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        self.backgroundColor = kWhiteColor;
        
        [self registerClass:[HistoryRateCell class] forCellReuseIdentifier:identifierCell];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.rates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HistoryRateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.rateModel = self.rates[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    
    headerView.backgroundColor = kBackgroundColor;
    
    //日期
    UILabel *dateLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:15.0];
    
    dateLbl.text = @"时间";
    
    dateLbl.textAlignment = NSTextAlignmentCenter;
    
    [headerView addSubview:dateLbl];
    [dateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(headerView.mas_centerX).offset(-(kScreenWidth/4.0));
        make.centerY.equalTo(@0);
        
    }];
    
    //汇率
    UILabel *rateLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:16.0];
    
    rateLbl.text = @"当日汇率";
    rateLbl.textAlignment = NSTextAlignmentCenter;
    
    [headerView addSubview:rateLbl];
    [rateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(headerView.mas_centerX).offset((kScreenWidth/4.0));
        make.centerY.equalTo(@0);
        
    }];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

@end
