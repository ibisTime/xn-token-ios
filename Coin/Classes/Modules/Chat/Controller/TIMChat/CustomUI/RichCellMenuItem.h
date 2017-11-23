//
//  RichCellMenuItem.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, RichCellMenuItemType) {
    ERichCell_Text,                 // 普通的显示
    ERichCell_RichText,             // 有富文内容
    ERichCell_TextNext,             // 普通的显示，有下一步
    ERichCell_RichTextNext,         // 有富文内容，有下一步
    ERichCell_Switch,               // 需要编辑
    
    ERichCell_Member,               // 成员 value alignRight
    ERichCell_MemberPanel,          // 需要编辑
};


@class RichCellMenuItem;
@class UITableViewCell;

typedef void (^RichCellAction)(RichCellMenuItem *menu, UITableViewCell *cell);

// 复杂的UI
@interface RichCellMenuItem : NSObject

@property (nonatomic, assign) RichCellMenuItemType type;

@property (nonatomic, copy) NSString *tip;

@property (nonatomic, copy) NSString *value;


@property (nonatomic, assign) BOOL switchValue;

@property (nonatomic, assign) BOOL switchIsEnable;

@property (nonatomic, copy) RichCellAction action;

@property (nonatomic, assign) NSTextAlignment valueAlignment;

@property (nonatomic, assign) NSInteger tipMargin;
@property (nonatomic, assign) NSInteger tipWidth;

@property (nonatomic, strong) UIFont *tipFont;
@property (nonatomic, strong) UIColor *tipColor;

@property (nonatomic, strong) UIFont *valueFont;
@property (nonatomic, strong) UIColor *valueColor;

+ (NSString *)reuseIndentifierOf:(RichCellMenuItemType)type;

- (instancetype)initWith:(NSString *)tip value:(NSString *)value type:(RichCellMenuItemType)type action:(RichCellAction)action;

@end


@interface RichMemersMenuItem : RichCellMenuItem

@property (nonatomic, strong) NSMutableArray *members;

@end
