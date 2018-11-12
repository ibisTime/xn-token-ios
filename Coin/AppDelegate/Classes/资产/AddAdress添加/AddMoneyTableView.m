//
//  AddMoneyTableView.m
//  Coin
//
//  Created by shaojianfei on 2018/6/7.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "AddMoneyTableView.h"
#import "AddMoneyCell.h"
@interface AddMoneyTableView()<UITableViewDataSource, UITableViewDelegate>


@end
static NSString *identifierCell = @"AddMoneyCell";

@implementation AddMoneyTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[AddMoneyCell class] forCellReuseIdentifier:identifierCell];
    }
    
    return self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.currencys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    cell.PersonalWallet = _PersonalWallet;
    cell.currency = self.currencys[indexPath.section];
    
    cell.tag = 1200 + 100*indexPath.section;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.AddMoneyDelegate = self;
    cell.selectButton.tag = indexPath.section;
    [cell.selectButton addTarget:self action:@selector(SelectTheButton:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)SelectTheButton:(UIButton *)sender
{
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:button:selectRowAtIndex:)]) {
        [self.refreshDelegate refreshTableViewButtonClick:self button:sender selectRowAtIndex:sender.tag];
    }
}

-(void)setPersonalWallet:(NSInteger)PersonalWallet
{
    _PersonalWallet = PersonalWallet;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 88;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
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
