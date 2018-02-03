//
//  TLPublishInputView.m
//  Coin
//
//  Created by  tianlei on 2018/1/03.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TLPublishInputView.h"
#import "TLAlert.h"
#define INTRODUCE_WIDTH 50
#define MARK_WIDTH 50
#define LEFT_LBL_WIDTH 90


@interface TLPublishInputView()



@end

@implementation TLPublishInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat selfH = frame.size.height;
        CGFloat selfW = frame.size.width;

        //
        self.leftLbl = [TLBaseLabel labelWithFrame:CGRectMake(0, 0, LEFT_LBL_WIDTH, selfH)
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor whiteColor]
                                          font:[UIFont systemFontOfSize:14]
                                     textColor:[UIColor textColor]];
        [self addSubview:self.leftLbl];
        
        //右边标志
        self.markLbl = [TLBaseLabel labelWithFrame:CGRectZero
                                      textAligment:NSTextAlignmentRight
                                   backgroundColor:[UIColor whiteColor]
                                              font:[UIFont systemFontOfSize:14]
                                         textColor:[UIColor textColor]];
        [self addSubview:self.markLbl];
        
        //图片标志
        self.markImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.markImageView];
        
        //最右边介绍(autolayout)
        self.introduceBtn = [[UIButton alloc] init];
        [self addSubview:self.introduceBtn];
        [self.introduceBtn setImage:[UIImage imageNamed:@"问号"] forState:UIControlStateNormal];
        
        //中间输入框
        CGFloat w = selfW - LEFT_LBL_WIDTH - INTRODUCE_WIDTH - MARK_WIDTH;
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(self.leftLbl.right, 0, w , selfH)];
        [self addSubview:self.textField];
        self.textField.font = [UIFont systemFontOfSize:14];
        self.textField.keyboardType = UIKeyboardTypeDecimalPad;

        
        //底线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [self addSubview:line];
     
        //
        [self.introduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_right);
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(INTRODUCE_WIDTH);
            
        }];
        
        [self.markLbl mas_makeConstraints:^(MASConstraintMaker *make) {

//            make.top.bottom.equalTo(self.introduceBtn);
            make.right.equalTo(self.introduceBtn.mas_left);
            make.centerY.equalTo(self.mas_centerY);
//            make.width.mas_equalTo(MARK_WIDTH);
            
        }];
        
        [self.markImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.introduceBtn.mas_left);
            
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(0.7);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        [self addEvent];
   
    }
    
    return self;
    
}

- (void)addEvent {
    
    [self.introduceBtn addTarget:self action:@selector(displayHint) forControlEvents:UIControlEventTouchUpInside];
}

- (void)displayHint {
    
    [TLAlert alertWithTitle:@"" message:self.hintMsg];
    
}

- (void)adddMaskBtn {
    
    self.maskBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self addSubview:self.maskBtn];
    [self.maskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.right.equalTo(self.introduceBtn.mas_left);
    }];
    
}


@end
