//
//  CustomActionSheet.h
//  YYFocus
//
//  Created by anjun on 16/3/17.
//  Copyright © 2016年 anjun. All rights reserved.
//
//
//
//
//
//  注:具体样式开发者可以根据需要自行调整.
//
//
//
//


#import <UIKit/UIKit.h>
@class CustomActionSheet;

@protocol CustomActionSheetDelagate <NSObject>

@optional
// 点击各个选项所触发的代理方法
- (void)sheet:(CustomActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface CustomActionSheet : UIView

/**
 *  从屏幕下方弹出一个自定义view
 *
 *  @param title             标题
 *  @param otherButtonTitles 其它按钮的标题文字
 */
- initWithTitle:(NSString *)title otherButtonTitles:(NSArray *)otherButtonTitles;

/** 弹出视图 */
- (void)show;

/** 移除视图 */
- (void)closeView;

@property (nonatomic, weak) id<CustomActionSheetDelagate> delegate;

/** 最下面的那个按钮的文字,默认为"取消" */
@property (nonatomic, copy) NSString *cancelTitle;

@end
