//
//  MyIncomeTableView.m
//  Coin
//
//  Created by QinBao Zheng on 2018/10/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "MyIncomeTableView.h"
#import "MyInconmeHeadCell.h"
#define MyInconmeHead @"MyInconmeHeadCell"
#import "SCPieCell.h"
#define SCPie @"SCPieCell"
#import "MyInconmeCell.h"
#define MyInconme @"MyInconmeCell"

@interface MyIncomeTableView()<UITableViewDelegate, UITableViewDataSource>

@end
@implementation MyIncomeTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {

    if (self = [super initWithFrame:frame style:style]) {

        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = kBackgroundColor;

        [self registerClass:[MyInconmeHeadCell class] forCellReuseIdentifier:MyInconmeHead];
        [self registerClass:[SCPieCell class] forCellReuseIdentifier:SCPie];
        [self registerClass:[MyInconmeCell class] forCellReuseIdentifier:MyInconme];





        self.separatorStyle = UITableViewCellSeparatorStyleNone;

    }

    return self;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 2) {
        return 5;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    if (indexPath.section == 0) {
        MyInconmeHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:MyInconmeHead forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataDic = @{};
        cell.backgroundColor = kHexColor(@"#0848DF");
        return cell;
    }
    if (indexPath.section == 1) {
        SCPieCell *cell = [tableView dequeueReusableCellWithIdentifier:SCPie forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.quantitativeButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.quantitativeButton.tag = 100;
        [cell.invitationButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.invitationButton.tag = 101;
        return cell;
    }
    MyInconmeCell *cell = [tableView dequeueReusableCellWithIdentifier:MyInconme forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.numberLabel.text = [NSString stringWithFormat:@"NO.%ld",indexPath.row + 1];
    return cell;


}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 160 - 64;
    }
    if (indexPath.section == 1) {
        return 249;
    }
    return 60;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 2) {
        return 30;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 100;
    }
    return 0.01;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        UIView *headView = [UIView new];

        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        backView.backgroundColor = kWhiteColor;
        [headView addSubview:backView];

        UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 30) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:HGboldfont(16) textColor:kHexColor(@"#333333")];
        nameLabel.text = [LangSwitcher switchLang:@"全球收益榜" key:nil];
        [backView addSubview:nameLabel];
        return headView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    if (section == 2) {
        UIView *headView = [UIView new];

        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        backView.backgroundColor = kWhiteColor;
        [headView addSubview:backView];

        UIButton *moreButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"查看更多" key:nil] titleColor:kHexColor(@"#666666") backgroundColor:kClearColor titleFont:13];
        moreButton.frame = CGRectMake(0, 20, SCREEN_WIDTH, 40);
        [moreButton SG_imagePositionStyle:(SGImagePositionStyleRight) spacing:5 imagePositionBlock:^(UIButton *button) {
            [button setImage:kImage(@"更多拷贝") forState:(UIControlStateNormal)];
        }];
        [moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [backView addSubview:moreButton];

        return headView;
    }
    return [UIView new];
}

-(void)moreButtonClick:(UIButton *)sender
{
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:button:selectRowAtIndex:)]) {
        [self.refreshDelegate refreshTableViewButtonClick:self button:sender selectRowAtIndex:sender.tag];
    }
}

@end
