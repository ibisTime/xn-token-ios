//
//  AccountTf.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AccountTf.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"

@implementation AccountTf

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        
        UIView *leftBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, frame.size.height)];
        
        _leftIconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 16, 16)];
        _leftIconView.contentMode = UIViewContentModeCenter;
        _leftIconView.centerY = leftBgView.height/2.0;
        _leftIconView.contentMode = UIViewContentModeScaleAspectFit;
        [leftBgView addSubview:_leftIconView];
        
        self.leftView = leftBgView;
        self.leftViewMode = UITextFieldViewModeAlways;
    
        self.font = [UIFont systemFontOfSize:14];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        self.backgroundColor = [UIColor whiteColor];
        
        //白色边界线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.7, 18)];
        
        lineView.backgroundColor = [UIColor whiteColor];
        lineView.centerY = frame.size.height/2.0;
        lineView.centerX = leftBgView.width;
        
        [leftBgView addSubview:lineView];
//        self.tintColor = kAppCustomMainColor;
        lineView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        
    }
    return self;
    
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    
    _placeHolder = [placeHolder copy];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:_placeHolder attributes:@{
                                                                                                          NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#bbbbbb"]
                                                                                                          }];
    self.attributedPlaceholder = attrStr;
    
}



- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    return [self newRect:bounds];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    
    return [self newRect:bounds];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    
    return [self newRect:bounds];
}

- (CGRect)newRect:(CGRect)oldRect {
    
    CGRect newRect = oldRect;
    newRect.origin.x = newRect.origin.x + 64;
    return newRect;
}

#pragma mark --处理复制粘贴事件
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(self.isSecurity){
        
        return NO;
        
    } else{
        return [super canPerformAction:action withSender:sender];
    }
    //    if (action == @selector(paste:))//禁止粘贴
    //        return NO;
    //    if (action == @selector(select:))// 禁止选择
    //        return NO;
    //    if (action == @selector(selectAll:))// 禁止全选
    //        return NO;
}

@end
