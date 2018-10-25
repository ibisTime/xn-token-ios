//
//  keyTransferTableView.m
//  Coin
//
//  Created by 郑勤宝 on 2018/10/25.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "keyTransferTableView.h"
#import "TransformButtonCell.h"
#define TransformButton @"TransformButtonCell"
#import "TransferNumberCell.h"
#define TransferNumber @"TransferNumberCell"
//@implementation keyTransferTableView

@interface keyTransferTableView()<UITableViewDelegate, UITableViewDataSource,TransformButtonDelegate>


@end
@implementation keyTransferTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
//        self.backgroundColor = kBackgroundColor;
        
        [self registerClass:[TransformButtonCell class] forCellReuseIdentifier:TransformButton];
        [self registerClass:[TransferNumberCell class] forCellReuseIdentifier:TransferNumber];
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
        TransformButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:TransformButton forIndexPath:indexPath];
        cell.models = self.models;
        cell.SelectDelegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    TransferNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:TransferNumber forIndexPath:indexPath];
//    cell.models = self.models;
    cell.isLocal = self.isLocal;
    cell.model = self.model;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.slider addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    
    [cell.changebut addTarget:self action:@selector(allTransform:) forControlEvents:UIControlEventTouchUpInside];
    cell.changebut.tag = 100;
    [cell.allLab addTarget:self action:@selector(allTransform:) forControlEvents:UIControlEventTouchUpInside];
    cell.allLab.tag = 101;
    [cell.importButton addTarget:self action:@selector(allTransform:) forControlEvents:UIControlEventTouchUpInside];
    cell.importButton.tag = 102;
    
    
    return cell;
    
}

-(void)allTransform:(UIButton *)sender
{
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:button:selectRowAtIndex:)]) {
        [self.refreshDelegate refreshTableViewButtonClick:self button:sender selectRowAtIndex:sender.tag];
    }
}

-(void)SelectTheButton:(UIButton *)sender
{
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:button:selectRowAtIndex:)]) {
        [self.refreshDelegate refreshTableViewButtonClick:self button:sender selectRowAtIndex:sender.tag];
    }
}

-(void)valueChange:(UISlider *)slider
{
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:Slider:)]) {
        [self.refreshDelegate refreshTableView:self Slider:slider];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        float numberToRound;
        int result;
        numberToRound = (self.models.count - 1 + 1.0)/3.0;
        result = (int)ceilf(numberToRound);
        
        return result * 50 + 20;
    }
    return 500;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    return nil;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return nil;
    
}
@end
