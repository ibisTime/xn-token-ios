//
//  TLMyRecodeTB.m
//  Coin
//
//  Created by shaojianfei on 2018/8/18.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLMyRecodeTB.h"
#import "CoinHeader.h"
#import "AppColorMacro.h"
#import "BillCell.h"
#import "questionListCells.h"
#import "RecodeCell.h"
@interface TLMyRecodeTB ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation TLMyRecodeTB

static NSString *identifierCell = @"RecodeCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        [self setContentInset:UIEdgeInsetsMake(5, 0.0, -5, 0.0)];
        self.backgroundColor = kBackgroundColor;
        
        [self registerClass:[RecodeCell class] forCellReuseIdentifier:identifierCell];
        
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
    
    RecodeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.model = self.Moneys[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 200;
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

@end
