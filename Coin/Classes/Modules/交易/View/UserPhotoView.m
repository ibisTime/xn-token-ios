//
//  UserPhotoView.m
//  Coin
//
//  Created by  tianlei on 2017/12/19.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "UserPhotoView.h"
#import "TLUIHeader.h"
#import "NSString+Extension.h"
#import "NSString+Date.h"
#import "AppColorMacro.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface UserPhotoView()

@property (nonatomic, strong) UIView *onlineView;
@property (nonatomic, strong) UIButton *photoBtn;

@end

@implementation UserPhotoView

+ (instancetype)photoView {
    
    UserPhotoView *photView = [[UserPhotoView alloc] init];
    
    return photView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        CGFloat photoBtnW = 44;
        self.photoBtn = [UIButton buttonWithTitle:@""
                                       titleColor:kWhiteColor
                                  backgroundColor:kAppCustomMainColor
                                        titleFont:24
                                     cornerRadius:photoBtnW/2.0];
        [self addSubview:self.photoBtn];
        self.photoBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(UIEdgeInsetsZero);
            make.width.height.mas_equalTo(photoBtnW);
            
        }];
        //
        CGFloat onlineW = 12.5;
        self.onlineView = [[UIView alloc] init];
        [self addSubview:self.onlineView];
        self.onlineView.layer.cornerRadius = onlineW/2.0;
        self.onlineView.layer.masksToBounds = YES;
        self.onlineView.layer.borderWidth = 1;
        self.onlineView.layer.borderColor = [UIColor whiteColor].CGColor;
        //
        [self.onlineView  mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.bottom.equalTo(self);
            make.width.height.mas_equalTo(onlineW);
        }];
        
        
    }
    return self;
}

- (void)setUserInfo:(UserInfo *)userInfo {
    
    _userInfo = userInfo;
    
    //灰
    UIColor *beyond30Color = [UIColor colorWithHexString:@"#cdcdcd"];
    
    //黄
    UIColor *between10to30Color = [UIColor colorWithHexString:@"#fcd705"];
    
    //绿
    UIColor *in10Color = [UIColor colorWithHexString:@"#74c758"];


    //头像
    if (_userInfo.photo) {
        
        [self.photoBtn setTitle:@"" forState:UIControlStateNormal];
        
        [self.photoBtn sd_setImageWithURL:[NSURL URLWithString:[_userInfo.photo convertImageUrl]] forState:UIControlStateNormal];
        
    } else {
        
        NSString *nickName = _userInfo.nickname;
        NSString *title = [nickName substringToIndex:1];
        [self.photoBtn setTitle:title forState:UIControlStateNormal];
        
    }
    
    if (!userInfo.lastLogin || userInfo.lastLogin.length == 0) {
        
        self.onlineView.backgroundColor = beyond30Color;
        return;
        
    }
    [[NSDate date] timeIntervalSince1970];
    NSDate *lastLoginDate = [userInfo.lastLogin convertToSysDate];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:lastLoginDate];
    if (timeInterval < 0 || timeInterval <= 10*60) {
        
        _onlineView.backgroundColor = in10Color;
        
    } else if ( timeInterval < 30*60) {
        
        _onlineView.backgroundColor = between10to30Color;

    } else {
        
        _onlineView.backgroundColor = beyond30Color;

    }
    

}
@end
