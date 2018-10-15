//
//  BillTableView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "BillTableView.h"
#import "CoinHeader.h"
#import "AppColorMacro.h"
#import "BillCell.h"

@interface BillTableView ()<UITableViewDelegate, UITableViewDataSource>
{
    BillCell *cell;
}
@end

@implementation BillTableView

static NSString *identifierCell = @"BillListCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        self.backgroundColor = kBackgroundColor;
        
        [self registerClass:[BillCell class] forCellReuseIdentifier:identifierCell];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.bills.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {



//    static NSString *CellIdentifier = @"Cell";
//    cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
//    if (cell == nil) {
//        cell = [[BillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }


    cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
//    if (indexPath.row == 3) {
//        cell.backgroundColor = [UIColor redColor];
//    }
    cell.billModel = self.bills[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    return self.bills[indexPath.row].dHeightValue + 70;
    return cell.timeLbl.yy + 16;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {



    UIView *contentView = [[UIView alloc] init];

    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:backView];

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, kScreenWidth - 35, 40)];
    [backView addSubview:lab];

    lab.textColor = kTextColor;
    lab.font = [UIFont systemFontOfSize:13];
    lab.text =[NSString stringWithFormat:@"%@",[LangSwitcher switchLang:@"交易记录" key:nil]];


    UIView *view = [UIView new];
    view.backgroundColor = kHexColor(@"276FFA ");
    view.frame = CGRectMake(15, 14, 5, 12);
    kViewRadius(view, 1);
    [backView addSubview:view];


    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 39, SCREEN_WIDTH - 30, 1)];
    lineView.backgroundColor = kLineColor;
    [backView addSubview:lineView];

    
    UIButton *button = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"筛选" key:nil] titleColor:kTextColor backgroundColor:kClearColor titleFont:12];
    [button addTarget:self action:@selector(clickFilter:) forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top);
        make.right.equalTo(contentView.mas_right).offset(-15);
        make.width.equalTo(@75);
        make.height.equalTo(@40);
    }];
    return contentView;
}

- (void)clickFilter:(UIButton *)sender {
    
    if (self.addBlock) {
        self.addBlock();
    }
    NSLog(@"ready");
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}
@end
