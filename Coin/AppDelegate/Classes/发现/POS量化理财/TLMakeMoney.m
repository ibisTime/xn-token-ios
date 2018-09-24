//
//  TLMakeMoney.m
//  Coin
//
//  Created by shaojianfei on 2018/8/10.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLMakeMoney.h"
#import "CoinHeader.h"
#import "AppColorMacro.h"
#import "BillCell.h"
#import "questionListCells.h"
#import "MakeMoneyCell.h"
@interface TLMakeMoney()<UITableViewDelegate, UITableViewDataSource>


@end
@implementation TLMakeMoney
static NSString *identifierCell = @"MakeMoneyCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        [self setContentInset:UIEdgeInsetsMake(5, 0.0, -5, 0.0)];
        self.backgroundColor = kBackgroundColor;
        
        [self registerClass:[MakeMoneyCell class] forCellReuseIdentifier:identifierCell];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.Moneys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MakeMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.model = self.Moneys[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kHeight(160);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    //    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(15, 20, kScreenWidth, 22)];
    //
    //    UIButton *button = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"筛选" key:nil] titleColor:kTextColor backgroundColor:kClearColor titleFont:12];
    //    [button addTarget:self action:@selector(clickFilter:) forControlEvents:UIControlEventTouchUpInside];
    //    //    [UIBarButtonItem addRightItemWithTitle:[LangSwitcher switchLang:@"筛选" key:nil]
    //    //                                titleColor:kTextColor
    //    //                                     frame:CGRectMake(0, 0, 60, 30)
    //    //                                        vc:self
    //    //                                    action:@selector(clickFilter:)];
    //    [contentView addSubview:button];
    //
    //    [button mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(contentView.mas_top);
    //        make.right.equalTo(contentView.mas_right).offset(-15);
    //        make.width.equalTo(@75);
    //        make.height.equalTo(@22);
    //    }];
    //    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 22)];
    //    [contentView addSubview:lab];
    //
    //    lab.textColor = kTextColor;
    //    lab.font = [UIFont systemFontOfSize:12];
    //
    //    lab.text =[NSString stringWithFormat:@"    %@",[LangSwitcher switchLang:@"交易记录" key:nil]];
    UIView *view = [UIView new];
    //    view.backgroundColor = kHexColor(@"276FFA ");
    //    view.frame = CGRectMake(0, 8, 10, 5);
    //    [contentView addSubview:view];
    
    return view;
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
