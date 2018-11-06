//
//  ToolTextField.h
//  Coin
//
//  Created by 郑勤宝 on 2018/11/6.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToolTextField : UITextField

- (instancetype)initWithFrame:(CGRect)frame font:(CGFloat)font placeholder:(NSString *)placeholder placeholderFont:(CGFloat)font;

//禁止复制粘贴等功能
@property (nonatomic,assign) BOOL isSecurity;

@end
