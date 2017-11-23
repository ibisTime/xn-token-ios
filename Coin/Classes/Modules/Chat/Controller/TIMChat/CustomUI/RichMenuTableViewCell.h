//
//  RichMenuTableViewCell.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RichMenuTableViewCell : UITableViewCell
{
@protected
    UILabel     *_tip;
    UILabel     *_value;
    
@protected
    UISwitch    *_onSwitch;
    
@protected
    __weak RichCellMenuItem *_item;
}

@property (nonatomic, weak) RichCellMenuItem *item;
@property (nonatomic, readonly) UISwitch *onSwitch;


+ (NSInteger)heightOf:(RichCellMenuItem *)item inWidth:(CGFloat)width;
- (void)configWith:(RichCellMenuItem *)item;


@end


@interface RichMemerPanelTableViewCell : UITableViewCell
{
@protected
    NSMutableArray  *_memberIconViews;
    RichCellMenuItem *_item;
    
    BOOL _hasAdd;
    IMAGroup *_group;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier hasAdd:(BOOL)has;

- (void)configWith:(RichCellMenuItem *)item;

- (void)configGroup:(IMAGroup *)group;
@end
