//
//  TLTextView.m
//  ZHBusiness
//
//  Created by  蔡卓越 on 2016/12/13.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "TLTextView.h"
#import "AppColorMacro.h"
#import "TLUIHeader.h"

@interface TLTextView()<UITextViewDelegate>

@end


@implementation TLTextView

- (UILabel *)placeholderLbl {

    if (!_placeholderLbl) {
        _placeholderLbl =  [UILabel 
                            
                            
                            labelWithFrame:CGRectMake(5, 7, self.width - 30, 20)
                                             textAligment:NSTextAlignmentLeft
                                          backgroundColor:[UIColor clearColor]
                                                     font:self.font
                                                textColor:kTextColor2];
        _placeholderLbl.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginEdit)];
        [_placeholderLbl addGestureRecognizer:tap];
    }
    return _placeholderLbl;

}
- (void)beginEdit {

    [self becomeFirstResponder];

}

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.delegate = self;
        [self addSubview:self.placeholderLbl];
    }

    return self;
}

- (void)layoutSubviews {

    [super layoutSubviews];

}


- (void)setText:(NSString *)text {

    //正则表达式匹配特殊字符
    [super setText:text];
    [self.placeholderLbl removeFromSuperview];
}

- (void)setPlacholder:(NSString *)placholder {

    _placholder = [placholder copy];
    self.placeholderLbl.text = _placholder;

}

#pragma mark- textView delegate

- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length > 0) {
        
        [self.placeholderLbl removeFromSuperview];
        
    } else {
        
        [self addSubview:self.placeholderLbl];
        
    }
    
    
}
@end
