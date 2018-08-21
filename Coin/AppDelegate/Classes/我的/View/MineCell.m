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

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UIImageView *accessoryImageView;

@end

@implementation MineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.layer.cornerRadius = 4;
        self.clipsToBounds = YES;
        self.layer.borderWidth = 1;
        
        self.layer.borderColor = [UIColor colorWithRed:240/255.0 green:244/255.0  blue:247/255.0  alpha:0.3].CGColor;
        self.iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconImageView];
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@20);
            make.height.equalTo(@20);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(15);
            
        }];
        
        //右边箭头
        self.accessoryImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.accessoryImageView];
        [self.accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@7);
            make.height.equalTo(@12);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            
        }];
        self.accessoryImageView.image = [UIImage imageNamed:@"更多-灰色"];
        
        self.rightLabel = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:15.0];
        
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_lessThanOrEqualTo(200);
            make.height.mas_equalTo(15.0);
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
            
        }];
        
        //
        self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
        
        [self.contentView addSubview:self.titleLbl];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(10);
            
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.lessThanOrEqualTo(self.accessoryImageView.mas_left);
        }];
        
        //
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kLineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(@(kLineHeight));
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    return self;
    
}

- (void)setMineModel:(MineModel *)mineModel {
    
    self.iconImageView.image = [UIImage imageNamed:mineModel.imgName];
    
    self.titleLbl.text = mineModel.text;
    
    self.rightLabel.text = mineModel.rightText;
    
}

#pragma mark - 消息小红点
- (void)showBadge {
    
    //移除之前的小红点
    [self removeBadge];
    
    CGFloat badgeW = 8;
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888;
    badgeView.layer.cornerRadius = badgeW/2.0;
    badgeView.backgroundColor = [UIColor redColor];
    
    //确定小红点的位置
    
    badgeView.frame = CGRectMake(30, 10, badgeW, badgeW);
    [self addSubview:badgeView];
    
}

- (void)hideBadge{
    
    //移除小红点
    [self removeBadge];
    
}

- (void)removeBadge{
    
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        
        if (subView.tag == 888) {
            
            [subView removeFromSuperview];
            
        }
    }
}

@end
