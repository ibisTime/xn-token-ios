//
//  NoticeListCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/30.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "NoticeListCell.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

@interface NoticeListCell ()
//头像
@property (nonatomic, strong) UIImageView *photoIV;
//昵称
@property (nonatomic, strong) UILabel *nickNameLbl;
//聊天内容
@property (nonatomic, strong) UILabel *contentLbl;
//时间
@property (nonatomic, strong) UILabel *timeLbl;

@end

@implementation NoticeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat leftMargin = 15;

        CGFloat headIconH = 50;

        //头像
        self.photoIV = [[UIImageView alloc] initWithImage:USER_PLACEHOLDER_SMALL];
        
        self.photoIV.layer.cornerRadius = headIconH/2.0;
        self.photoIV.layer.masksToBounds = YES;
        self.photoIV.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:self.photoIV];
        [self.photoIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(leftMargin));
            make.top.equalTo(@(leftMargin));
            make.width.height.equalTo(@(headIconH));
            
        }];
        
        //昵称
        self.nickNameLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14.0];
        
        [self addSubview:self.nickNameLbl];
        
        [self.nickNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.photoIV.mas_top).offset(2);
            make.left.equalTo(self.photoIV.mas_right).offset(10);
            
        }];
        
        self.contentLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
        
        self.contentLbl.numberOfLines = 0;
        
        [self addSubview:self.contentLbl];
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(leftMargin);
            make.bottom.equalTo(self.mas_bottom).offset(-15);
            make.right.equalTo(self.mas_right).offset(-leftMargin);
        }];
        
        //时间
        self.timeLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
        
        [self addSubview:self.timeLbl];
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_right).offset(-15);
            
            make.top.equalTo(self.mas_top).offset(15);
        }];
    }

    return self;
}

- (void)setConversation:(IMAConversation *)conversation {
    
    _conversation = conversation;
    
//    TIMConversation *conv = conversation
//    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:<#(nonnull NSString *)#>] placeholderImage:USER_PLACEHOLDER_SMALL];
    
//    self.nickNameLbl.text =
}

@end
