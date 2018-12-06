//
//  FindTheGameTableView.m
//  Coin
//
//  Created by 郑勤宝 on 2018/12/4.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "FindTheGameTableView.h"
#import "FindTheGameHeadCell.h"
#import "GameIntroducedCell.h"
#import "StrategyCell.h"
@interface FindTheGameTableView()<UITableViewDelegate, UITableViewDataSource,GameIntroducedCellDelegate>

{
    GameIntroducedCell *_cell;
    NSInteger select;
}

@end

@implementation FindTheGameTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = kBackgroundColor;
        
        [self registerClass:[FindTheGameHeadCell class] forCellReuseIdentifier:@"FindTheGameHeadCell"];
        [self registerClass:[GameIntroducedCell class] forCellReuseIdentifier:@"GameIntroducedCell"];
        [self registerClass:[StrategyCell class] forCellReuseIdentifier:@"StrategyCell"];
//        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
//        selectBtn.tag = 400;
        select = 0;
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (section == 1) {
        if (select == 0) {
            return 1;
        }else
        {
            return self.model.count;
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        FindTheGameHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindTheGameHeadCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.GameModel = self.GameModel;
        [cell.actionBtn addTarget:self action:@selector(actionBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        return cell;
    }
    if (select == 0) {
        GameIntroducedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameIntroducedCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _cell = cell;
        _cell.delegate = self;
        cell.GameModel = self.GameModel;
        return cell;
    }else
    {
        StrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StrategyCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.model[indexPath.row];
        return cell;
    }
}

-(void)actionBtnClick:(UIButton *)sender
{
    [self.refreshDelegate refreshTableViewButtonClick:self button:sender selectRowAtIndex:0];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 177;
    }
    if (indexPath.section == 1) {
        if (select == 0) {
            return _cell.scrollView.yy + 50;
        }else
        {
            return 40;
        }
    }
    return 0;
    
}

-(void)GameIntroducedCellClick
{
    [self reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        return 74;
    }
    return 0.01;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 0.01;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *headView = [UIView new];
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 74)];
        backView.backgroundColor = kWhiteColor;
        [headView addSubview:backView];
        NSArray *array = @[@"介绍",@"攻略"];
        for (int i = 0; i < 2; i ++) {
            
            UIButton *headBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:array[i] key:nil] titleColor:kHexColor(@"#acacac") backgroundColor:kWhiteColor titleFont:14];
            headBtn.frame = CGRectMake(20 + i % 2 * (SCREEN_WIDTH/2 - 20 - 3.5 + 7), 17, (SCREEN_WIDTH/2 - 20 - 3.5), 40);
            [headBtn setBackgroundColor:kHexColor(@"#0064ff") forState:(UIControlStateSelected)];
            [headBtn setTitleColor:kWhiteColor forState:(UIControlStateSelected)];
//            if (i == select) {
//                selectBtn = sender;
//            }
            if (i == select) {
                
                headBtn.selected = YES;
                kViewBorderRadius(headBtn, 6.5, 1, kHexColor(@"#0064ff"));
            }
            else
            {
                kViewBorderRadius(headBtn, 6.5, 1, kHexColor(@"#acacac"));
            }
            [headBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
            headBtn.tag = 400 + i;
            [backView addSubview:headBtn];
        }
        
        return headView;
    }
    return nil;
}

-(void)headBtnClick:(UIButton *)sender
{
    select = sender.tag - 400;
    [self reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

@end
