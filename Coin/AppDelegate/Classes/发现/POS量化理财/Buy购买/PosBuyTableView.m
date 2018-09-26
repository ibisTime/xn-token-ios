//
//  PosBuyTableView.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "PosBuyTableView.h"
#import "PosBuyBalanceCell.h"
#define PosBuyBalance @"PosBuyBalanceCell"
#import "PosBuyIntroduceCell.h"
#define PosBuyIntroduce @"PosBuyIntroduceCell"
@interface PosBuyTableView()<UITableViewDelegate, UITableViewDataSource
>

@end
@implementation PosBuyTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {

    if (self = [super initWithFrame:frame style:style]) {

        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = kBackgroundColor;

        [self registerClass:[PosBuyBalanceCell class] forCellReuseIdentifier:PosBuyBalance];
        [self registerClass:[PosBuyIntroduceCell class] forCellReuseIdentifier:PosBuyIntroduce];


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


    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        PosBuyBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:PosBuyBalance forIndexPath:indexPath];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    PosBuyIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:PosBuyIntroduce forIndexPath:indexPath];


    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60;
    }
    return 300;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 1) {
        return 5;
    }
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


@end
