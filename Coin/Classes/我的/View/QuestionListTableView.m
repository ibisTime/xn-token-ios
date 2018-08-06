//
//  QuestionListTableView.m
//  Coin
//
//  Created by shaojianfei on 2018/8/4.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "QuestionListTableView.h"
#import "CoinHeader.h"
#import "AppColorMacro.h"
#import "BillCell.h"
#import "questionListCells.h"
@interface QuestionListTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation QuestionListTableView
static NSString *identifierCell = @"questionListCells";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        [self setContentInset:UIEdgeInsetsMake(5, 0.0, -5, 0.0)];
        self.backgroundColor = kBackgroundColor;
        
        [self registerClass:[questionListCells class] forCellReuseIdentifier:identifierCell];
        
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
    
    return self.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    questionListCells *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.model = self.questions[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kHeight(100);
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
