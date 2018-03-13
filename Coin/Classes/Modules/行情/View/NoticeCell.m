//
//  NoticeCell.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "NoticeCell.h"

#import "AppColorMacro.h"
#import "TLUIHeader.h"
#import "NSString+Date.h"

@interface NoticeCell ()

@property (nonatomic,strong) UIImageView *iconIV;
//标题
@property (nonatomic,strong) UILabel *titleLbl;
//时间
@property (nonatomic,strong) UILabel *timeLbl;
//内容
@property (nonatomic,strong) UILabel *contentLbl;

@property (nonatomic, strong) UIView *bgView;

@end

@implementation NoticeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = kWhiteColor;
        
        //icon
        self.iconIV = [[UIImageView alloc] initWithImage:kImage(@"消息")];

        [self addSubview:self.iconIV];
        [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@15);
            make.top.equalTo(@25);
            make.width.height.equalTo(@32);
            
        }];
        
        //消息标题
        self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14.0];
        
        self.titleLbl.numberOfLines = 0;
        
        [self addSubview:self.titleLbl];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.iconIV.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-15);
            make.top.equalTo(self.iconIV.mas_top);
            
        }];
        
        //时间
        self.timeLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
        
        [self addSubview:self.timeLbl];
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.titleLbl.mas_left);
            make.top.equalTo(self.titleLbl.mas_bottom).offset(5);
            
        }];
        
        //
        self.bgView = [[UIView alloc] init];
        
        self.bgView.layer.cornerRadius = 5;
        self.bgView.layer.masksToBounds = YES;

        self.bgView.backgroundColor = kBackgroundColor;
        
        [self addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.titleLbl.mas_left);
            make.top.equalTo(self.timeLbl.mas_bottom).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            
        }];
        
        //消息内容
        self.contentLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
        
        self.contentLbl.numberOfLines = 0;
        
        [self.bgView addSubview:self.contentLbl];
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(UIEdgeInsetsMake(13, 12, 13, 12));
            
            make.top.equalTo(self.bgView.mas_top).offset(13);
            
        }];
        
        UIView *line = [[UIView alloc] init];
        
        line.backgroundColor = kLineColor;
        
        [self addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(@0);
            make.height.equalTo(@0.5);
            make.top.equalTo(self.bgView.mas_bottom).offset(15);
            
        }];
        
    }
    return self;
    
}

- (void)setNotice:(NoticeModel *)notice {
    
    _notice = notice;
    
    self.titleLbl.text = _notice.smsTitle; //名称
    self.timeLbl.text = [_notice.pushedDatetime convertToDetailDate];//更新时间
    self.contentLbl.text = _notice.smsContent; //消息内容
    
    [self layoutSubviews];
    
    _notice.cellHeight = self.bgView.yy + 15.5;
    
}

@end
