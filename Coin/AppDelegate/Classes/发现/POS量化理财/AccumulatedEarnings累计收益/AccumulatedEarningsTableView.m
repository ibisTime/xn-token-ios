//
//  AccumulatedEarningsTableView.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/27.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "AccumulatedEarningsTableView.h"
#import "AccumulatedEarningsCell.h"
@interface AccumulatedEarningsTableView()<UITableViewDelegate, UITableViewDataSource>


@end
@implementation AccumulatedEarningsTableView

static NSString *identifierCell = @"AccumulatedEarningsCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {

    if (self = [super initWithFrame:frame style:style]) {

        self.dataSource = self;
        self.delegate = self;
        //        [self setContentInset:UIEdgeInsetsMake(5, 0.0, -5, 0.0)];
        self.backgroundColor = kBackgroundColor;

        [self registerClass:[AccumulatedEarningsCell class] forCellReuseIdentifier:identifierCell];

        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.date = @"";
    }

    return self;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.model.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    AccumulatedEarningsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.model[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 79;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (![self.date isEqualToString:@""]) {
        return 40;
    }else
    {
        return 5;
    }

}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *view = [UIView new];

    if (![self.date isEqualToString:@""]) {
        UILabel *titleLbl = [UILabel labelWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 40) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:Font(12) textColor:kHexColor(@"#999999")];
        titleLbl.text = [NSString stringWithFormat:@"%@账单",self.date];
        [view addSubview:titleLbl];
    }

    return view;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    return [UIView new];
}

@end
