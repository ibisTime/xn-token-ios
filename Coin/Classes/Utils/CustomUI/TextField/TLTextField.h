//
//  TLTextField.h
//  WeRide
//
//  Created by  蔡卓越 on 2016/12/7.
//  Copyright © 2016年 trek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLTextField : UITextField

@property (nonatomic, strong) UILabel *leftLbl;

- (instancetype)initWithFrame:(CGRect)frame
                    leftTitle:(NSString *)leftTitle
                   titleWidth:(CGFloat)titleWidth
                  placeholder:(NSString *)placeholder;

//禁止复制粘贴等功能
@property (nonatomic,assign) BOOL isSecurity;

@property (nonatomic,assign) NSInteger maxCount;


@end
