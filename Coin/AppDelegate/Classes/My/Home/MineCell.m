//
//  MineCell.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "MineCell.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"

@interface MineCell ()



@property (nonatomic, strong) UIImageView *accessoryImageView;

@end

@implementation MineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        
        self.iconImageView = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.iconImageView.frame = CGRectMake(24, 15, 20, 20);
        [self.contentView addSubview:self.iconImageView];

        
        //右边箭头
        self.accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 19 - 7, 19, 7, 15)];
        [self.contentView addSubview:self.accessoryImageView];

        self.accessoryImageView.image = [UIImage imageNamed:@"矩形7拷贝2"];
        
        

        self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
        self.titleLbl.font = FONT(15);
        self.titleLbl.frame = CGRectMake(self.iconImageView.xx + 8, 0, SCREEN_WIDTH - self.iconImageView.xx - 16 - 31, 50);
        [self.contentView addSubview:self.titleLbl];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 49, SCREEN_WIDTH - 30, 1)];
        line.backgroundColor = kLineColor;
        [self addSubview:line];

        
    }
    return self;
    
}

//- (void)setMineModel:(MineModel *)mineModel {
//    
//    self.iconImageView.image = [UIImage imageNamed:mineModel.imgName];
//    
//    self.titleLbl.text = mineModel.text;
//    
//    self.rightLabel.text = mineModel.rightText;
//    
//}

#pragma mark - 消息小红点
//- (void)showBadge {
//
//    //移除之前的小红点
//    [self removeBadge];
//
//    CGFloat badgeW = 8;
//
//    //新建小红点
//    UIView *badgeView = [[UIView alloc]init];
//    badgeView.tag = 888;
//    badgeView.layer.cornerRadius = badgeW/2.0;
//    badgeView.backgroundColor = [UIColor redColor];
//
//    //确定小红点的位置
//
//    badgeView.frame = CGRectMake(30, 10, badgeW, badgeW);
//    [self addSubview:badgeView];
//
//}

//- (void)hideBadge{
//
//    //移除小红点
//    [self removeBadge];
//
//}

//- (void)removeBadge{
//
//    //按照tag值进行移除
//    for (UIView *subView in self.subviews) {
//
//        if (subView.tag == 888) {
//
//            [subView removeFromSuperview];
//
//        }
//    }
//}

@end
