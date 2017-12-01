//
//  RichItemTableViewController.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//
#import "TableRefreshViewController.h"

@interface RichItemTableViewController : TableRefreshViewController
{
@protected
    NSMutableDictionary *_dataDictionary;
}

- (RichCellMenuItem *)getItemWithKey:(NSString *)tip;

- (NSIndexPath *)getIndexOfKey:(NSString *)tip;

- (RichCellMenuItem *)itemOf:(NSIndexPath *)indexPath;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForItem:(RichCellMenuItem *)item;

@end
