//
//  ContactDrawerView.h
//  TIMChat
//
//  Created by AlexiChen on 16/2/18.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactDrawerView : UITableViewHeaderFooterView
{
@protected
    UIImageView *_drawerIcon;
    
    UILabel     *_drawerName;
    
    UILabel     *_itemsCount;
    
    UIView      *_line;
    
@protected
    BOOL        _isPicker;         // NO是联系人界面，YES是先择好友界面
    
@protected
    __weak id<IMAContactDrawerShowAble> _drawer;
}

@property (nonatomic, weak) id<IMAContactDrawerShowAble> drawer;
@property (nonatomic, copy) CommonBlock tapDrawerCompletion;

- (instancetype)initWithPickReuseIdentifier:(NSString *)reuseIdentifier;


- (void)configWithDrawer:(id<IMAContactDrawerShowAble>)drawer;
- (void)updateDrawer;

@end
