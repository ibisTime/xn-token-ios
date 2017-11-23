//
//  AddFriendViewController.h
//  TIMChat
//
//  Created by AlexiChen on 16/2/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMBaseViewController.h"

@interface AddFriendPageItem : RequestPageParamItem

@property (nonatomic, copy) NSString *key;

@end

@interface AddFriendSearchResultViewController : SearchResultViewController
{
@protected
    UILabel     *_noResultTip;
    
    __weak UISearchController *_searchController;
    
    __weak UISearchDisplayController *_searchDisController;
}

- (void)onSearchTextResult:(NSArray *)data;

- (void)onLoadMoreSearchTextResult:(NSArray *)data;
@end


@interface AddFriendViewController : TableSearchViewController

@end
