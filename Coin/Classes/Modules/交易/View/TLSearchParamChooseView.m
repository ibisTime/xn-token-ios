//
//  TLSearchParamChooseView.m
//  Coin
//
//  Created by  tianlei on 2018/2/05.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TLSearchParamChooseView.h"
#import "TLPickerTextField.h"
#import "AppColorMacro.h"
#import "TLUIHeader.h"

@implementation TLSearchParamChooseView

- (instancetype)initWithFrame:(CGRect)frame
                    paramName:(NSString *)paramName
                  placeholder:(NSString *)placeholder
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        CGFloat rightSpaceWidth = 50;
        //广告类型
        self.pickerTextField = [[TLPickerTextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - rightSpaceWidth, frame.size.height)
                                                                  leftTitle:paramName
                                                                 titleWidth:90
                                                                placeholder:placeholder];
        [self addSubview:self.pickerTextField];
        
        //
        UIImageView *advertiseArrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多拷贝")];
        advertiseArrowIV.backgroundColor = kWhiteColor;
        advertiseArrowIV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:advertiseArrowIV];
        [advertiseArrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(@(-20));
            make.centerY.equalTo(self.pickerTextField.mas_centerY);
            
        }];
        
        //广告类型下面的线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kLineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@20);
            make.right.equalTo(@(-20));
            make.height.equalTo(@1);
            make.bottom.equalTo(self);
            
        }];
        
    }
    return self;
}

@end
