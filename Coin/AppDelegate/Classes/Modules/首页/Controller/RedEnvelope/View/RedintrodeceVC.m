//
//  RedintrodeceVC.m
//  Coin
//
//  Created by shaojianfei on 2018/9/17.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "RedintrodeceVC.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"
@implementation RedintrodeceVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews
{
    
    self.contentLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    [self addSubview:self.contentLab];
    self.contentLab.numberOfLines = 0;
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    UIImageView *arrow = [[UIImageView alloc] init];
    arrow.contentMode = UIViewContentModeScaleToFill;
    arrow.image = kImage(@"more");
    [self addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentLab.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15);
        make.width.height.equalTo(@15);
    }];
    UIView *line = [UIView new];
    line.backgroundColor = kLineColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@1);
    }];
}

-(void)setModel:(RedModel *)model
{
    _model = model;
    self.contentLab.text = model.question;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
