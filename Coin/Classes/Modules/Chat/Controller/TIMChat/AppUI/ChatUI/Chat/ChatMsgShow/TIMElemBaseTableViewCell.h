//
//  TIMElemBaseTableViewCell.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/8.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>


// 用于基本的聊天界面
//
@interface TIMElemBaseTableViewCell : UITableViewCell<TIMElemAbleCell>
{
@protected
    UIButton                                *_icon;             // 用户头像
    
@protected
    UILabel                                 *_remarkTip;        // 用户remark，群消息的时候有用
    
@protected
    UIImageView                             *_contentBack;      // 聊天内容气泡
    UIView                                  *_elemContentRef;   // 实际聊天内容显示控件
    
@protected
    UIView<TIMElemSendingAbleView>          *_sendingTipRef;    // 发送提示
    
@protected
    
    UIView<TIMElemPickedAbleView>           *_pickedViewRef;    // 选中按钮
@protected
    TIMElemCellStype                        _cellStyle;         // 样式
    __weak IMAMsg                           *_msg;              // 要显示的消息弱引用
    
@protected
    FBKVOController                         *_msgKVO;           // 消息的KVO，主要是监听消息的发送状态
}
@property (nonatomic, weak) IMAMsg *msg;

+ (UIFont *)defaultNameFont;
+ (UIFont *)defaultTextFont;

- (instancetype)initWithC2CReuseIdentifier:(NSString *)reuseIdentifier;
- (instancetype)initWithGroupReuseIdentifier:(NSString *)reuseIdentifier;

// 配置消息显示
- (void)configWith:(IMAMsg *)msg;

// 以下方法均求子类重写
// 更新KVO监听
- (void)configKVO;

// 添加C2C样式下的控件
- (void)addC2CCellViews;

// 添加群样式下的控件
- (void)addGroupCellViews;

// 只创建，外部统一添加
- (UIView *)addElemContent;

// 子类重写，只创建，外部重写不作添加到_contentBack，内部逻辑统一添加
- (UIView<TIMElemSendingAbleView> *)addSendingTips;

// 子类重写，只创建，外部重写不作添加到_contentBack，内部逻辑统一添加
- (UIView<TIMElemPickedAbleView> *)addPickedView;

// 布局C2C显示的样式
- (void)relayoutC2CCellViews;

// 布局群聊天显示样式
- (void)relayoutGroupCellViews;
// 
- (void)configContent;
- (void)configElemContent;
- (void)configSendingTips;



@end
