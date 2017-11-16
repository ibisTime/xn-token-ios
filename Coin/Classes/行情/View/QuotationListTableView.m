//
//  QuotationListTableView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "QuotationListTableView.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import "QuotationListCell.h"

@interface QuotationListTableView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation QuotationListTableView

static NSString *identifierCell = @"QuotationListCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[QuotationListCell class] forCellReuseIdentifier:identifierCell];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    return self.quotations.count;
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QuotationListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
//    cell.quotation = self.quotations[indexPath.row];
    
    cell.quotation = [QuotationListModel new];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
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
