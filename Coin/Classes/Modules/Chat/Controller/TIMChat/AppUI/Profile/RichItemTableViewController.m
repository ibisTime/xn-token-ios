//
//  RichItemTableViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "RichItemTableViewController.h"

@interface RichItemTableViewController ()

@end

@implementation RichItemTableViewController

- (void)addHeaderView
{
    
}

- (void)addFooterView
{
    
}

- (BOOL)hasData
{
    return YES;
}

- (RichCellMenuItem *)getItemWithKey:(NSString *)tip
{
    if (![NSString isEmpty:tip])
    {
        RichCellMenuItem *temp = [[RichCellMenuItem alloc] init];
        temp.tip = tip;
        
        NSArray *keys = [_dataDictionary allKeys];
        for (id<NSCopying> key in keys)
        {
            NSArray *items = [_dataDictionary objectForKey:key];
            NSInteger idx = [items indexOfObject:temp];
            if (idx >= 0 && idx < items.count)
            {
                return [items objectAtIndex:idx];
            }
        }
    }
    return nil;
}



- (NSIndexPath *)getIndexOfKey:(NSString *)tip
{
    if (![NSString isEmpty:tip])
    {
        RichCellMenuItem *temp = [[RichCellMenuItem alloc] init];
        temp.tip = tip;
        
        NSArray *keys = [_dataDictionary allKeys];
        for (NSInteger sec = 0; sec < keys.count; sec++)
        {
            id<NSCopying> key = [keys objectAtIndex:sec];
            NSArray *items = [_dataDictionary objectForKey:key];
            NSInteger idx = [items indexOfObject:temp];
            if (idx >= 0 && idx < items.count)
            {
                return [NSIndexPath indexPathForItem:idx inSection:sec];
            }
        }
    }
    return nil;
}

- (void)addRefreshScrollView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = kClearColor;
    _tableView.scrollsToTop = YES;
    [self.view addSubview:_tableView];
    
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.refreshScrollView = _tableView;
}


- (RichCellMenuItem *)itemOf:(NSIndexPath *)indexPath
{
    NSArray *array = _dataDictionary[@(indexPath.section)];
    RichCellMenuItem *item = array[indexPath.row];
    return item;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataDictionary count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = _dataDictionary[@(section)];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RichMenuTableViewCell heightOf:[self itemOf:indexPath] inWidth:tableView.bounds.size.width];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RichCellMenuItem *item = [self itemOf:indexPath];
    
    return [self tableView:tableView cellForItem:item];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForItem:(RichCellMenuItem *)item
{
    NSString *reuse = [RichCellMenuItem reuseIndentifierOf:item.type];
    RichMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell)
    {
        cell = [[RichMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell configWith:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RichCellMenuItem *item = [self itemOf:indexPath];
    RichMenuTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (item.type != ERichCell_Switch)
    {
        if (item.action)
        {
            item.action(item, cell);
        }
    }
}
@end
