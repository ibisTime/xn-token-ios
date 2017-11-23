//
//  SubGroupPickerViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/2.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "SubGroupPickerViewController.h"

@implementation SubGroupPickerViewController


- (instancetype)initWithCompletion:(CommonCompletionBlock)completion
{
    if (self = [super init])
    {
        self.pickCompletion = completion;
        self.title = @"选择分组";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onCompletion)];
    
    if (self.navigationController != [AppDelegate sharedAppDelegate].navigationViewController)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    }
    
}


- (void)onCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)onCompletion
{
    if (_pickCompletion)
    {
        _pickCompletion(self, YES);
    }
    
    [[AppDelegate sharedAppDelegate] dismissViewController:self animated:YES completion:nil];
}


- (void)addHeaderView
{
    
}

- (void)addFooterView
{
    
}

- (void)configOwnViews
{
    _subGroups = [[IMAPlatform sharedInstance].contactMgr subGroupList];
    NSString * log1 = [NSString stringWithFormat:@"subGroupList.count = %ld,fun = %s",(long)_subGroups.count, __func__];
    [[TIMManager sharedInstance] log:TIM_LOG_ERROR tag:@"ui crash" msg:log1];
}

- (void)addRefreshScrollView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.frame = self.view.bounds;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = kClearColor;
    _tableView.scrollsToTop = YES;
    [self.view addSubview:_tableView];
    
    self.view.backgroundColor = RGB(240, 240, 240);
    
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.refreshScrollView = _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * log1 = [NSString stringWithFormat:@"subGroupList.count = %ld,fun = %s",(long)_subGroups.count, __func__];
    [[TIMManager sharedInstance] log:TIM_LOG_ERROR tag:@"ui crash" msg:log1];
    return _subGroups.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubGroup"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddSubGroup"];
    }
    id<IMAContactDrawerShowAble> drawe = [_subGroups objectAtIndex:indexPath.row];
    cell.textLabel.text = [drawe showTitle];
    cell.accessoryType = _selectedSubGroup == drawe ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<IMAContactDrawerShowAble> drawe = [_subGroups objectAtIndex:indexPath.row];
    if (_selectedSubGroup != drawe)
    {
        NSInteger index = [_subGroups indexOfObject:_selectedSubGroup];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        _selectedSubGroup = drawe;
        cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
}




@end
