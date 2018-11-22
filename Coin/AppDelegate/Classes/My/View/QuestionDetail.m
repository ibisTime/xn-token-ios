//
//  QuestionDetail.m
//  Coin
//
//  Created by shaojianfei on 2018/8/5.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "QuestionDetail.h"
#import "QDetailCell.h"
#import "NSString+Date.h"
@interface   QuestionDetail()<UITableViewDelegate, UITableViewDataSource>

@end
static NSString *identifierCell = @"QDetailCell";

@implementation QuestionDetail

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        self.backgroundColor = kBackgroundColor;
        
        [self registerClass:[QDetailCell class] forCellReuseIdentifier:identifierCell];
        
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
    
    if (self.model.pic) {
        return 8;
    }else{
        
        return 7;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.nameLab.text = [LangSwitcher switchLang:@"所在端" key:nil];
            cell.stateLab.text = [LangSwitcher switchLang:self.model.deviceSystem key:nil];
            [cell setNeedsLayout];
            
            self.model.rowHeight = cell.stateLab.height+20;
            break;
        case 1:
            cell.nameLab.text = [LangSwitcher switchLang:@"问题描述" key:nil];
            cell.stateLab.text = [LangSwitcher switchLang:self.model.commitNote key:nil];
            [cell setNeedsLayout];
            
            self.model.rowHeight = cell.stateLab.height+20;
            break;
        case 2:
            cell.nameLab.text = [LangSwitcher switchLang:@"复现步骤" key:nil];
            cell.stateLab.text = [LangSwitcher switchLang:self.model.reappear key:nil];
            [cell setNeedsLayout];
            
            self.model.rowHeight = cell.stateLab.height+20;
            break;
        case 3:
            if (self.model.pic) {
                cell.nameLab.text = [LangSwitcher switchLang:@"问题截图" key:nil];

                NSArray *arr = [self.model.pic componentsSeparatedByString:@"||"];
                cell.imageArray = arr;
                
                
            }else{
                
                cell.nameLab.text = [LangSwitcher switchLang:@"备注" key:nil];
                cell.stateLab.text = [LangSwitcher switchLang:self.model.commitNote key:nil];
                [cell setNeedsLayout];
                
                self.model.rowHeight = cell.stateLab.height+20;
            }
            break;
        case 4:
            if (self.model.pic) {
                cell.nameLab.text = [LangSwitcher switchLang:@"备注" key:nil];
                cell.stateLab.text = [LangSwitcher switchLang:self.model.commitNote key:nil];
                [cell setNeedsLayout];
                
                self.model.rowHeight = cell.stateLab.height+20;
            }else{
                
                cell.nameLab.text = [LangSwitcher switchLang:@"提交时间" key:nil];
                cell.stateLab.text = [LangSwitcher switchLang:[self.model.commitDatetime convertDate] key:nil];
                [cell setNeedsLayout];
                
                self.model.rowHeight = cell.stateLab.height+20;
            }
            break;
        case 5:
            if (self.model.pic) {
                cell.nameLab.text = [LangSwitcher switchLang:@"提交时间" key:nil];
                cell.stateLab.text = [LangSwitcher switchLang:[self.model.commitDatetime convertDate] key:nil];
                [cell setNeedsLayout];
                
                self.model.rowHeight = cell.stateLab.height+20;
            }else{
                
                cell.nameLab.text = [LangSwitcher switchLang:@"bug状态" key:nil];
                if ([self.model.status isEqualToString:@"0"]) {
                    cell.stateLab.text = [LangSwitcher switchLang:@"待确认" key:nil];
                    [cell setNeedsLayout];
                    
                    self.model.rowHeight = cell.stateLab.height+20;

                }else if ([self.model.status isEqualToString:@"1"]) {
                    cell.stateLab.text = [LangSwitcher switchLang:@"已确认,待奖励" key:nil];
                    [cell setNeedsLayout];
                    
                    self.model.rowHeight = cell.stateLab.height+20;

                }
                else if ([self.model.status isEqualToString:@"2"]) {
                    cell.stateLab.text = [LangSwitcher switchLang:@"复现不成功" key:nil];
                    [cell setNeedsLayout];
                    
                    self.model.rowHeight = cell.stateLab.height+20;

                }else{
                    cell.stateLab.text = [LangSwitcher switchLang:@"已领取" key:nil];
                    [cell setNeedsLayout];
                    
                    self.model.rowHeight = cell.stateLab.height+20;
                }
                
            }
            break;
        case 6:
            if (self.model.pic) {
                cell.nameLab.text = [LangSwitcher switchLang:@"bug状态" key:nil];
                if ([self.model.status isEqualToString:@"0"]) {
                    cell.stateLab.text = [LangSwitcher switchLang:@"待确认" key:nil];
                    [cell setNeedsLayout];
                    
                    self.model.rowHeight = cell.stateLab.height+20;
                }else if ([self.model.status isEqualToString:@"1"]) {
                    cell.stateLab.text = [LangSwitcher switchLang:@"已确认,待奖励" key:nil];
                    [cell setNeedsLayout];
                    
                    self.model.rowHeight = cell.stateLab.height+20;
                }
                else if ([self.model.status isEqualToString:@"2"]) {
                    cell.stateLab.text = [LangSwitcher switchLang:@"复现不成功" key:nil];
                    [cell setNeedsLayout];
                    
                    self.model.rowHeight = cell.stateLab.height+20;
                }else{
                    cell.stateLab.text = [LangSwitcher switchLang:@"已领取" key:nil];
                    [cell setNeedsLayout];
                    
                    self.model.rowHeight = cell.stateLab.height+20;
                }            }else{
                
                cell.nameLab.text = [LangSwitcher switchLang:@"最终确认等级" key:nil];
                cell.stateLab.text = [LangSwitcher switchLang:self.model.level key:nil];
                    [cell setNeedsLayout];
                    
                    self.model.rowHeight = cell.stateLab.height+20;
            }
            break;
        case 7:
            cell.nameLab.text = [LangSwitcher switchLang:@"最终确认等级" key:nil];
            cell.stateLab.text = [LangSwitcher switchLang:self.model.level key:nil];
            [cell setNeedsLayout];
            
            self.model.rowHeight = cell.stateLab.height+20;
            break;
            
        default:
            break;
    }
    [cell setNeedsLayout];
    
    self.model.rowHeight = cell.stateLab.height+20;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return self.model.rowHeight+20;
//    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
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
////    [contentView addSubview:view];
    
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
