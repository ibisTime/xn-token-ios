//
//  InviteEarningsTableView.m
//  Coin
//
//  Created by QinBao Zheng on 2018/10/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "InviteEarningsTableView.h"
#import "InviteEarningCell.h"
#define InviteEarning @"InviteEarningCell"
@interface InviteEarningsTableView()<UITableViewDelegate, UITableViewDataSource>


@end
@implementation InviteEarningsTableView

static NSString *identifierCell = @"AccumulatedEarningsCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {

    if (self = [super initWithFrame:frame style:style]) {

        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = kBackgroundColor;

        [self registerClass:[InviteEarningCell class] forCellReuseIdentifier:InviteEarning];

        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

    return self;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//    NSArray *array = self.array[section];
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    InviteEarningCell *cell = [tableView dequeueReusableCellWithIdentifier:InviteEarning forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

//    NSArray *array = self.array[indexPath.section];
//    if (array.count > 0) {
//        cell.model = [InviteEarningsModel mj_objectWithKeyValues:array[indexPath.row]];
//    }
    cell.row = indexPath.row;

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 45;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.01;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *view = [UIView new];

    UILabel *titleLbl = [UILabel labelWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 45) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:Font(12) textColor:kHexColor(@"#999999")];
//    NSArray *array = self.array[section];
//    if (array.count > 0) {
//        InviteEarningsModel *model = [InviteEarningsModel mj_objectWithKeyValues:array[0]];
//        titleLbl.text = model.createDatetime;
//    }

    [view addSubview:titleLbl];

    return view;
}




- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    return [UIView new];
}

@end
