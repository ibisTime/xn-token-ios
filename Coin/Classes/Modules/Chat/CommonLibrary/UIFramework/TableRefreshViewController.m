//
//  TableRefreshViewController.m
//  CommonLibrary
//
//  Created by Alexi on 15-2-5.
//  Copyright (c) 2015年 Alexi Chen. All rights reserved.
//

#import "TableRefreshViewController.h"


#import "RefreshView.h"

#import "ImageTitleButton.h"

#import "TLUIHeader.h"

@implementation RequestPageParamItem

- (instancetype)init
{
    if (self = [super init])
    {
        _pageIndex = 0;
        _pageSize = 20;
        _canLoadMore = YES;
    }
    return self;
}


@end

@interface TableRefreshViewController ()<UIGestureRecognizerDelegate>

@end

@implementation TableRefreshViewController

- (void)initialize
{
    [super initialize];
    _clearsSelectionOnViewWillAppear = YES;
    _pageItem = [[RequestPageParamItem alloc] init];
}

- (void)addHeaderView
{
    self.headerView = [[HeadRefreshView alloc] init];
}

- (void)pinHeaderAndRefesh
{
    [self pinHeaderView];
    [self refresh];
}

- (void)addFooterView
{
    self.footerView = [[FootRefreshView alloc] init];
}

- (void)addRefreshScrollView
{
    _tableView = [[UITableView alloc] init];
    _tableView.frame = self.view.bounds;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = kClearColor;
    _tableView.scrollsToTop = YES;
    [self.view addSubview:_tableView];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView setTableFooterView:v];
    
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.refreshScrollView = _tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_tableView)
    {
        NSIndexPath *selected = [_tableView indexPathForSelectedRow];
        if (selected)
        {
            [_tableView deselectRowAtIndexPath:selected animated:animated];
        }
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self addConfig];
}

- (void)addConfig {
    
    self.view.backgroundColor = kBackgroundColor;
    
    [self setViewEdgeInset];
    
    //    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    // 设置导航栏背景色
    [self.navigationController.navigationBar setBackgroundImage:[kWhiteColor convertToImage] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}

// 如果tableview在视图最底层 默认会偏移电池栏的高度
- (void)setViewEdgeInset {
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (BOOL)hasData
{
    BOOL has = _datas.count != 0;
    _tableView.separatorStyle = has ? UITableViewCellSeparatorStyleSingleLine : UITableViewCellSeparatorStyleNone;
    return has;
}

- (void)addNoDataView
{
    _noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight)];
    
    UIImageView *noticeIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90, 80, 80)];
    
    noticeIV.image = kImage(@"暂无消息");
    
    noticeIV.centerX = kScreenWidth/2.0;
    
    [_noDataView addSubview:noticeIV];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    textLbl.text = @"暂无消息哦";
    
    textLbl.frame = CGRectMake(0, noticeIV.yy + 20, kScreenWidth, 15);
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [_noDataView addSubview:textLbl];
    
    _noDataView.hidden = YES;
    
    [self.view addSubview:_noDataView];
}

- (BOOL)needFollowScrollView
{
    return NO;
}

- (void)reloadData
{
    //    BOOL has = [self hasData];
    //    _noDataView.hidden = has;
    //    if (!has)
    //    {
    //        [self showNoDataView];
    //    }
    [_tableView reloadData];
    [self allLoadingCompleted];
    
    //    if ([self needFollowScrollView])
    //    {
    //        if (_tableView.contentSize.height > 2 * _tableView.bounds.size.height)
    //        {
    //            [self followScrollView:_tableView];
    //        }
    //        else
    //        {
    //            [self followScrollView:nil];
    //        }
    //    }
}

- (void)showNoDataView
{
    
}

- (void)allLoadingCompleted
{
    [super allLoadingCompleted];
    
    BOOL has = [self hasData];
    _noDataView.hidden = has;
    if (!has)
    {
        [self showNoDataView];
    }
}

- (BOOL)isRootViewController {
    return (self == self.navigationController.viewControllers.firstObject);
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    // 判断是都是根控制器， 是的话就不pop
    if ([self isRootViewController]) {
        return NO;
    } else {
        return YES;
    }
}

// 允许手势同时识别
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

// 优化pop时, 禁用其他手势,如：scrollView滑动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}
@end
