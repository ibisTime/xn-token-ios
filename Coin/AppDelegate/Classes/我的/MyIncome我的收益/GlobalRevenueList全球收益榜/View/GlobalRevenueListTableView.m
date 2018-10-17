//
//  GlobalRevenueListTableView.m
//  Coin
//
//  Created by QinBao Zheng on 2018/10/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "GlobalRevenueListTableView.h"
#import "GlobalRevenueListCell.h"
#define MyInconme @"MyInconmeCell"
#import "GlobalRevenueListHeadCell.h"
#define GlobalRevenueListHead @"GlobalRevenueListHeadCell"
@interface GlobalRevenueListTableView()<UITableViewDelegate, UITableViewDataSource>

@end
@implementation GlobalRevenueListTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {

    if (self = [super initWithFrame:frame style:style]) {

        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = kBackgroundColor;

        [self registerClass:[GlobalRevenueListCell class] forCellReuseIdentifier:MyInconme];
        [self registerClass:[GlobalRevenueListHeadCell class] forCellReuseIdentifier:GlobalRevenueListHead];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;

    }

    return self;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 1) {
        return self.topModel.count - 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GlobalRevenueListHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:GlobalRevenueListHead forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.topModel.count > 0) {
            cell.topModel = self.topModel;
        }

        return cell;
    }
    GlobalRevenueListCell *cell = [tableView dequeueReusableCellWithIdentifier:MyInconme forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.topModel.count > 3) {
        cell.topModel = self.topModel[indexPath.row + 3];
    }
    return cell;


}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 400 - 64 + kNavigationBarHeight;
    }

    return 60;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {


    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 0.01;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {


    return [UIView new];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

//    if (scrollView.contentOffset.y <= 0) {
//        self.bounces = YES;
//    }else
//    {
//        self.bounces = NO;
//    }
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:scrollView:)]) {
        [self.refreshDelegate refreshTableView:self scrollView:scrollView];
    }
}

@end
