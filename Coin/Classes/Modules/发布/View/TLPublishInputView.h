//
//  TLPublishInputView.h
//  Coin
//
//  Created by  tianlei on 2018/1/03.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLUIHeader.h"

@interface TLPublishInputView : UIButton

@property (nonatomic, strong) TLBaseLabel *leftLbl;

@property (nonatomic, strong) UITextField *textField;

// lbl 和 imageView 处在同一位置，为了解决有的是文字，有的是箭头
@property (nonatomic, strong) UIImageView *markImageView;
@property (nonatomic, strong) TLBaseLabel *markLbl;
@property (nonatomic, copy) NSString *hintMsg;


@property (nonatomic, strong) UIButton *introduceBtn;

/**
 有时需要有Btn 盖在除introduceBtn 其它区域上面. 调用 - (void)adddMaskBtn;
 */
@property (nonatomic, strong) UIButton *maskBtn;
- (void)adddMaskBtn;

- (instancetype)initWithFrame:(CGRect)frame;

@end
