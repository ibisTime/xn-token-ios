//
//  PosMyInvestmentDetailsTableView.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "PosMyInvestmentDetailsTableView.h"
#import "PosMyInvestmentHeadView.h"
#import "PosMyInvestmentDetailsCell.h"
#define PosMyInvestmentDetails @"PosMyInvestmentDetailsCell"
@interface PosMyInvestmentDetailsTableView()<UITableViewDelegate, UITableViewDataSource>

@end
@implementation PosMyInvestmentDetailsTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {

    if (self = [super initWithFrame:frame style:style]) {

        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = kBackgroundColor;

        [self registerClass:[PosMyInvestmentDetailsCell class] forCellReuseIdentifier:PosMyInvestmentDetails];



        self.separatorStyle = UITableViewCellSeparatorStyleNone;

        PosMyInvestmentHeadView *headView = [[PosMyInvestmentHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160 - 64)];
        headView.backgroundColor = kHexColor(@"#0848DF");
        self.tableHeaderView = headView;

    }

    return self;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    PosMyInvestmentDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:PosMyInvestmentDetails forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;


}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 138;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {


    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *headView = [[UIView alloc]init];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    backView.backgroundColor = kWhiteColor;
    [headView addSubview:backView];
    NSArray *nameArray = @[@"已申购",@"已持有",@"已回款"];
    for (int i = 0; i < 3; i ++) {
        UIButton *headButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:nameArray[i] key:nil] titleColor:kHexColor(@"#464646") backgroundColor:kClearColor titleFont:16];
        headButton.titleLabel.font = FONT(15);
        headButton.frame = CGRectMake(i % 3 * SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 45);
        [headButton addTarget:self action:@selector(headButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [headButton SG_imagePositionStyle:(SGImagePositionStyleDefault) spacing:6 imagePositionBlock:^(UIButton *button) {
            [button setImage:kImage(@"Oval1") forState:(UIControlStateNormal)];
            [button setImage:kImage(@"Oval2") forState:(UIControlStateSelected)];
        }];
        headButton.tag = i;
        [headView addSubview:headButton];
    }


    return headView;
}

-(void)headButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    return [UIView new];
}

@end
