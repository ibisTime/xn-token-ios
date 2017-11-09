//
//  BaseMJRefreshTableView.h
//  Witness
//
//  Created by 田磊 on 15/12/8.
//  Copyright © 2015年 Ancun. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MJRefresh.h"

@class TLTableView;
@protocol RefreshDelegate <NSObject>

@optional

/**
 *选中Cell时
 */
- (void)refreshTableView:(TLTableView*)refreshTableview didSelectRowAtIndexPath:(NSIndexPath*)indexPath;
/* 选中cell上的button时可使用 */

- (void)refreshTableViewButtonClick:(TLTableView *)refreshTableview button:(UIButton *)sender selectRowAtIndex:(NSInteger)index;

@end

@interface  TLTableView: UITableView

@property (nonatomic, weak)   id<RefreshDelegate> refreshDelegate;  //代理

+ (instancetype)tableViewWithFrame:(CGRect)frame

                               delegate:(id)delegate dataSource:(id)dataSource;

+ (instancetype)groupTableViewWithFrame:(CGRect)frame

                          delegate:(id)delegate dataSource:(id)dataSource;
/**
 * 添加下拉事件
 */
- (void)addRefreshAction:(void(^)())refresh;
/**
 * 添加上拉事件
 */
- (void)addLoadMoreAction:(void(^)())loadMore;

/*开始刷新,刷新只能是下拉刷新*/
- (void)beginRefreshing;

/*头部——停止刷新*/
- (void)endRefreshHeader;

/* 尾部——停止刷新 */
- (void)endRefreshFooter;

/* 上拉加载更多，提示没有更多数据*/
- (void)endRefreshingWithNoMoreData_tl;


/* 重置更多数据的状态*/
- (void)resetNoMoreData_tl;

@property (nonatomic, assign) BOOL hiddenFooter;
@property (nonatomic, assign) BOOL hiddenHeader;

@property (nonatomic,strong) UIView *placeHolderView;


//****************************数据刷新   站位图相关**********************//
/*可以检测是否有数据，没有的话显示站位图，但是有个缺点，比如说第一个Cell显示固定的东西,像搜索框*/
- (void)reloadData_tl;

/*弥补上述缺点，*/
@property (nonatomic, assign) NSInteger minDisplayRowCount;

/*scrollEnabled 有数据时是否可以滑动  scrollWasEnabled无数据是是否 可以滑动  default is yes*/
//- (void)placeholderView:(UIView*(^)())placeHolder scrollEnabled:(BOOL(^)())scrollEnabled scrollWasEnabled:(BOOL(^)())scrollWasEnabled;

@end
