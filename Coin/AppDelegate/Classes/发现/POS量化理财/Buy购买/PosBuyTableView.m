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
,AddAndreductionDelegate>

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
        [cell.intoButton addTarget:self action:@selector(intoButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.intoButton.tag = 502;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([TLUser isBlankString:self.currencys.currency] == NO) {
            cell.currencys = self.currencys;
        }

        return cell;
    }
    PosBuyIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:PosBuyIntroduce forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.moneyModel = self.moneyModel;
    if ([TLUser isBlankString:self.dataDic[@"code"]] == NO) {
        cell.dataDic = self.dataDic;
    }


    return cell;

}

//转入
-(void)intoButtonClick:(UIButton *)sender{
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:button:selectRowAtIndex:)]) {

        [self.refreshDelegate refreshTableViewButtonClick:self button:sender selectRowAtIndex:sender.tag];
    }
}

-(void)addAndreductionButton:(UIButton *)sender
{
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:button:selectRowAtIndex:)]) {

        [self.refreshDelegate refreshTableViewButtonClick:self button:sender selectRowAtIndex:sender.tag];
    }

}

-(void)sliderActionUISlider:(UISlider *)slider
{
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:Slider:)]) {

        [self.refreshDelegate refreshTableView:self Slider:slider];
    }
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
    if (section == 1) {
        return 100;
    }
    return 0.01;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    if (section == 1) {
        UIView *footView = [[UIView alloc]init];

        UIButton *gardenBtn =[UIButton buttonWithType:(UIButtonTypeCustom)];
        [gardenBtn setImage:kImage(@"Combined Shape2") forState:(UIControlStateNormal)];
        [gardenBtn setImage:kImage(@"Oval Copy2") forState:(UIControlStateSelected)];
        gardenBtn.frame = CGRectMake(15, 0, 40, 40);
        [gardenBtn addTarget:self action:@selector(gardenBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        gardenBtn.tag = 504;
        [footView addSubview:gardenBtn];


        UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(55, 11, SCREEN_WIDTH - 70, 0)];
        titleLbl.font = FONT(12);
        titleLbl.textColor = kHexColor(@"#999999");
        titleLbl.numberOfLines = 0;

        NSString *str1 = [LangSwitcher switchLang:@"我已经仔细阅读" key:nil];
        NSString *str2 = [LangSwitcher switchLang:@"《XXXXXXXXXXXX》" key:nil];
        NSString *str3 = [LangSwitcher switchLang:@"同意协议中的有关条款。充分了解银行和自身的权利和义务。" key:nil];
        NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@，%@",str1,str2,str3]];
        [attriStr addAttribute:NSForegroundColorAttributeName value:kHexColor(@"#3D76FF") range:NSMakeRange(str1.length, str2.length)];
        titleLbl.attributedText = attriStr;
        [titleLbl sizeToFit];
        [footView addSubview:titleLbl];


        UIButton *titleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        titleBtn.frame = titleLbl.frame;
        [footView addSubview:titleBtn];
        titleBtn.tag = 503;
        [titleBtn addTarget:self action:@selector(addAndreductionButton:) forControlEvents:(UIControlEventTouchUpInside)];
        return footView;
    }
    return [UIView new];
}

-(void)gardenBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

@end
