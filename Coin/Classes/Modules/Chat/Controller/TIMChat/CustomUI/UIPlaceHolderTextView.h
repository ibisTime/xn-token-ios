//
//  UIPlaceHolderTextView.h
//  CommonLibrary
//
//  Created by AlexiChen on 15-1-11.
//  Copyright (c) 2015年 AlexiChen Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, strong) NSString *placeHolder;
@property (nonatomic, strong) UIColor  *placeHolderColor;
@property (nonatomic, strong) UIColor  *mainTextColor;

@end


@interface UILimitTextView : UIPlaceHolderTextView
{
@protected
    UILabel         *_limitText;
}

@property (nonatomic, readonly) UILabel *limitText; // 设置limitLength>0后有效

@property (nonatomic, assign) NSInteger limitLength;

- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)updateLimitText;
@end
