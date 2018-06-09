//
//  FansCell.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/28.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "FansCell.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import "NSString+Extension.h"
#import "NSString+Date.h"

#import "UIButton+WebCache.h"
#import "NSNumber+Extension.h"

@interface FansCell ()

//头像
@property (nonatomic, strong) UIButton *photoBtn;
//昵称
@property (nonatomic, strong) UILabel *nameLbl;
//交易、好评跟信任
@property (nonatomic, strong) UILabel *dataLbl;
//日期
@property (nonatomic, strong) UILabel *dateLbl;

@end

@implementation FansCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //头像
    CGFloat imgWidth = 40;
    
    self.photoBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"" key:nil] titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:20 cornerRadius:imgWidth/2.0];
    
    self.photoBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:self.photoBtn];
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(15));
        make.width.height.equalTo(@(imgWidth));
        make.centerY.equalTo(@0);
        
    }];
    
    //昵称
    self.nameLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:16.0];
    
    [self addSubview:self.nameLbl];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(15);
        make.left.equalTo(self.photoBtn.mas_right).offset(10);
        
    }];
    
    //交易、好评跟信任
    self.dataLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
    
    [self addSubview:self.dataLbl];
    [self.dataLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameLbl.mas_bottom).offset(10);
        make.left.equalTo(self.nameLbl.mas_left);
        
    }];
    
    //订单状态
    self.dateLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
    
    [self addSubview:self.dateLbl];
    [self.dateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.nameLbl.mas_centerY);
        
    }];
    
    //分割线
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kLineColor;
    
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@(-0.5));
        make.height.equalTo(@0.5);
        
    }];
}

- (void)setFans:(FansModel *)fans {

    _fans = fans;

    ToUserInfo *userInfo = fans.toUserInfo;
    
    UserStatist *userStatist = userInfo.userStatistics;
    
    NSString *nickName = userInfo.nickname;

    NSString *photo = userInfo.photo;

    //头像
    if (photo) {

        [self.photoBtn setTitle:@"" forState:UIControlStateNormal];

        [self.photoBtn sd_setImageWithURL:[NSURL URLWithString:[photo convertImageUrl]] forState:UIControlStateNormal];

    } else {

        NSString *title = [nickName substringToIndex:1];

        [self.photoBtn setTitle:title forState:UIControlStateNormal];

        [self.photoBtn setImage:nil forState:UIControlStateNormal];
    }
    //昵称
    self.nameLbl.text = nickName;

    //
    self.dataLbl.text = [LangSwitcher switchLang:[NSString stringWithFormat:@"交易 %ld · 好评 %@ · 信任 %ld", userStatist.jiaoYiCount, userStatist.goodCommentRate, userStatist.beiXinRenCount] key:nil];
 
    //时间
    self.dateLbl.text = [userInfo.createDatetime convertDate];
}

@end
