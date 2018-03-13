//
//  NoticeTableView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/30.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "NoticeTableView.h"
#import "NoticeListCell.h"

@interface NoticeTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation NoticeTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        
        [self registerClass:[NoticeListCell class] forCellReuseIdentifier:@"NoticeListCellId"];
        
    }
    return self;
}

#pragma mark - UITableViewSatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.conversationList.safeArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *noticeListCellId = @"NoticeListCellId";
    NoticeListCell *cell = [tableView dequeueReusableCellWithIdentifier:noticeListCellId forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.conversation = self.conversationList.safeArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        return 68;
    
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
@end
