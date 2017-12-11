//
//  TLPlaceholderView.m
//  ZHBusiness
//
//  Created by  蔡卓越 on 2016/12/21.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "TLPlaceholderView.h"

#import "CoinHeader.h"
#import <CDCommon/DeviceUtil.h>

@implementation TLPlaceholderView

+ (instancetype)placeholderViewWithText:(NSString *)text {

//    TLPlaceholderView *_placholderView = [[TLPlaceholderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
//    
//    UILabel *lbl = [UILabel labelWithFrame:CGRectMake(0, 10, _placholderView.width, 60) textAligment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithHexString:@"#484848"]];
//            [_placholderView addSubview:lbl];
//   lbl.numberOfLines = 0;
//   lbl.text = text;
//   return _placholderView;
    
    return [self placeholderViewWithText:text topMargin:0];
    
}

+ (instancetype)placeholderViewWithText:(NSString *)text topMargin:(CGFloat)margin {
    
    TLPlaceholderView *_placholderView = [[TLPlaceholderView alloc] initWithFrame:CGRectMake(0, margin, kScreenWidth, 100)];
    
    UILabel *lbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentCenter
                           backgroundColor:[UIColor clearColor]
                                      font:[UIFont systemFontOfSize:16]
                                 textColor:[UIColor colorWithHexString:@"#484848"]];
    
    [_placholderView addSubview:lbl];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_placholderView);
        make.top.equalTo(_placholderView.mas_top).offset(20);
    }];
    lbl.numberOfLines = 0;
    lbl.text = text;
    return _placholderView;
    
}

+ (instancetype) placeholderViewWithImgAndText:(NSString *)text {

    
    TLPlaceholderView *placeholderView = [[TLPlaceholderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - [DeviceUtil top64] - [DeviceUtil bottom49])];
    
        UIImageView *orderIV = [[UIImageView alloc] init];
        orderIV.image = kImage(@"暂无订单");
        orderIV.centerX = kScreenWidth/2.0;
    
        [placeholderView addSubview:orderIV];
        [orderIV mas_makeConstraints:^(MASConstraintMaker *make) {
    
            make.centerX.equalTo(@0);
            make.top.equalTo(@90);
    
        }];
    
        UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
        textLbl.text = [LangSwitcher switchLang:text
                                            key:nil];
        textLbl.textAlignment = NSTextAlignmentCenter;
    
        [placeholderView addSubview:textLbl];
        [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    
            make.top.equalTo(orderIV.mas_bottom).offset(20);
            make.centerX.equalTo(orderIV.mas_centerX);
    
        }];
    
    return placeholderView;
}
@end
