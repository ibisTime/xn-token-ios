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
@interface PosMyInvestmentDetailsTableView()<UITableViewDelegate, UITableViewDataSource>{
    NSInteger select;
    NSMutableArray *selectArray;
    PosMyInvestmentDetailsCell *cell;
}

@end
@implementation PosMyInvestmentDetailsTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {

    if (self = [super initWithFrame:frame style:style]) {

        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = kBackgroundColor;

        [self registerClass:[PosMyInvestmentDetailsCell class] forCellReuseIdentifier:PosMyInvestmentDetails];



        self.separatorStyle = UITableViewCellSeparatorStyleNone;

        

        selectArray = [NSMutableArray array];
        selectArray = [NSMutableArray arrayWithArray:@[@(0),@(1),@(2)]];
        select = 0;
    }

    return self;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


    return self.model.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    cell = [tableView dequeueReusableCellWithIdentifier:PosMyInvestmentDetails forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.model.count > 0) {
        cell.model = self.model[indexPath.row];
    }
    return cell;


}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cell.earningsLabel.yy + 15;

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
//        if (select == 0) {
//            [selectArray addObject:[NSString stringWithFormat:@"%d",i]];
//            headButton.selected = YES;
//        }

        BOOL isbool = [selectArray containsObject:@(i)];
        if (isbool == YES) {
            headButton.selected = YES;
        }else
        {
            headButton.selected = NO;
        }



        headButton.tag = i;
        [headView addSubview:headButton];
    }
    select = 1;
    NSLog(@"%@",selectArray);

    return headView;
}

-(void)headButtonClick:(UIButton *)sender
{
    BOOL isbool = [selectArray containsObject:@(sender.tag)];
    if (isbool == YES) {
        [selectArray removeObject:@(sender.tag)];
    }else
    {
        [selectArray addObject:@(sender.tag)];
    }
    [self reloadData];
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:button:selectRowAtIndex:setArray:)]) {
        [self.refreshDelegate refreshTableViewButtonClick:self button:sender selectRowAtIndex:sender.tag setArray:selectArray];
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    return [UIView new];
}

@end
