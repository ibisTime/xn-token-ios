//
//  BillDetailCell.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "BillDetailCell.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"

@interface BillDetailCell ()

@end

@implementation BillDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
       
        //
        self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:13.0];
        self.titleLbl.frame = CGRectMake(15, 18, 0, 14);
        [self.contentView addSubview:self.titleLbl];
//        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.equalTo(self.mas_left).offset(15);
////            make.width.equalTo(@60);
//            make.centerY.equalTo(self.contentView.mas_centerY);
//
//        }];
        
        self.rightLabel = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:13.0];
        
        self.rightLabel.textAlignment = NSTextAlignmentLeft;
        self.rightLabel.numberOfLines = 0;
        self.rightLabel.frame = CGRectMake(self.titleLbl.xx + 10, 18, SCREEN_WIDTH - self.titleLbl.xx - 25, 0);
        [self.contentView addSubview:self.rightLabel];
//        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.equalTo(self.titleLbl.mas_right).offset(15);
//            make.right.equalTo(self.mas_right).offset(-15);
//            make.top.equalTo(self.titleLbl.mas_top);
//
//        }];
        
    }
    UIView *lineView = [UIView new];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = kBackgroundColor;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@1);

        
    }];
    
    return self;
}


@end
