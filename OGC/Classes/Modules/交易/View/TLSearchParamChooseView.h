//
//  TLSearchParamChooseView.h
//  Coin
//
//  Created by  tianlei on 2018/2/05.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLPickerTextField.h"

@interface TLSearchParamChooseView : UIView

- (instancetype)initWithFrame:(CGRect)frame paramName:(NSString *)paramName placeholder:(NSString *)placeholder;

@property (nonatomic, strong) TLPickerTextField *pickerTextField;

@end
