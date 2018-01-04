//
//  TLHighLevelSettingsView.m
//  Coin
//
//  Created by  tianlei on 2018/1/03.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TLHighLevelSettingsView.h"
#import "TLUIHeader.h"
#import "TLPublishInputView.h"
#import "TLPublishTimeChooseView.h"

@interface TLHighLevelSettingsView()


//@property (nonatomic, strong) TLPublishInputView *topView;

@property (nonatomic, strong) TLPublishInputView *timeView;

@property (nonatomic, strong) TLPublishInputView *onlyTrustView;
@property (nonatomic, strong) TLPublishTimeChooseView *publishTimeChooseView;

@end

@implementation TLHighLevelSettingsView

#define HEGHT 45

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor backgroundColor];
        self.clipsToBounds = YES;
        self.layer.masksToBounds = YES;
        
        //顶部
        UIButton *topBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, frame.size.width, HEGHT)];
        [self addSubview:topBtn];
        self.topBtn = topBtn;
        topBtn.backgroundColor = [UIColor whiteColor];
        [topBtn addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
        UILabel *textLbl = [UILabel labelWithFrame:CGRectZero
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor whiteColor]
                                              font:FONT(14)
                                         textColor:[UIColor textColor]];
        [topBtn addSubview:textLbl];
        textLbl.text = @"高级设置";
        [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(topBtn.mas_left).offset(15);
            make.centerY.equalTo(topBtn.mas_centerY);
            
        }];
        
        //开放时间
        self.timeView = [[TLPublishInputView alloc] initWithFrame:CGRectMake(0, topBtn.yy + 5, SCREEN_WIDTH, 45)];
        [self addSubview:self.timeView];
//        self.timeView.textField.userInteractionEnabled = NO;
        self.timeView.leftLbl.text = [LangSwitcher switchLang:@"开放时间" key:nil];
//        self.timeView.enabled = NO;
        
        //时间选择
        self.publishTimeChooseView = [[TLPublishTimeChooseView alloc] initWithFrame:CGRectMake(0, self.timeView.yy, self.width, 120)];
        [self addSubview:self.publishTimeChooseView];
        
        //仅粉丝
        self.onlyTrustView = [[TLPublishInputView alloc] initWithFrame:CGRectMake(0, self.publishTimeChooseView.yy, SCREEN_WIDTH, 45)];
        [self addSubview:self.onlyTrustView];
//        self.onlyTrustView.textField.userInteractionEnabled = NO;
        self.onlyTrustView.leftLbl.text = [LangSwitcher switchLang:@"仅粉丝" key:nil];
//        self.onlyTrustView.enabled = NO;
        
        
        [self.onlyTrustView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.publishTimeChooseView.mas_bottom);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(HEGHT);
        }];
        
        [self layoutIfNeeded];
        
        
    }
    return self;
}

- (void)change {
    
    
}

- (CGFloat)nextShouldHeight {
    
    if (self.height == [TLHighLevelSettingsView normalHeight]) {
        
        return [TLHighLevelSettingsView fullHeight];
        
    } else {
        
        return [TLHighLevelSettingsView normalHeight];
    }
    
}


//
- (void)show {
    
    
}

//- (void)changeFrame {
//    
//    if (!self.superview) {
//        return;
//    }
//    
//    [self mas_];
//}

+ (CGFloat)normalHeight {
    
    return 55;
    
}

+ (CGFloat)fullHeight {
    
    return 265;
}


@end
