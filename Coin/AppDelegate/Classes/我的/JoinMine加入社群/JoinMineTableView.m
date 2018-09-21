//
//  JoinMineTableView.m
//  Coin
//
//  Created by shaojianfei on 2018/6/7.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "JoinMineTableView.h"
#import "JoinMineCell.h"

@interface JoinMineTableView()<UITableViewDataSource, UITableViewDelegate>


@end
static NSString *identifierCell = @"JoinMineCell";

@implementation JoinMineTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[JoinMineCell class] forCellReuseIdentifier:identifierCell];
    }
    
    return self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.models.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JoinMineCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];

    cell.model = self.models[indexPath.section];
    
   
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
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
@end
