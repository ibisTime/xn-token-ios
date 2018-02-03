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
#import "UIButton+Custom.h"
#import "AppColorMacro.h"

@interface TLHighLevelSettingsView()


//@property (nonatomic, strong) TLPublishInputView *topView;

@property (nonatomic, strong) TLPublishInputView *timeView;

@property (nonatomic, strong) TLPublishInputView *onlyTrustView;
@property (nonatomic, strong) TLPublishTimeChooseView *publishTimeChooseView;
@property (nonatomic, strong) UIImageView *topIndicateArrowImgView;

@end

@implementation TLHighLevelSettingsView

#define HEGHT 45
#define TIME_CHOOSE_VIEW_HEIGHT 100

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
        
        //顶部箭头
        self.topIndicateArrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 6, 10)];
        self.topIndicateArrowImgView.backgroundColor = [UIColor whiteColor];
        self.topIndicateArrowImgView.centerY = HEGHT/2.0;
        self.topIndicateArrowImgView.right = SCREEN_WIDTH - 25;
        self.topIndicateArrowImgView.image = [UIImage imageNamed:@"更多拷贝"];
        [topBtn addSubview:self.topIndicateArrowImgView];
        
        //开放时间
        self.timeView = [[TLPublishInputView alloc] initWithFrame:CGRectMake(0, topBtn.yy + 5, SCREEN_WIDTH, 45)];
        [self addSubview:self.timeView];
//        self.timeView.textField.userInteractionEnabled = NO;
        self.timeView.leftLbl.text = [LangSwitcher switchLang:@"开放时间" key:nil];
        
        //自定义
        self.customTimeBtn = [self btnWithTitle:@"自定义"];
        [self.timeView addSubview:self.customTimeBtn];
        [self.customTimeBtn addTarget:self action:@selector(selectCustomTime:) forControlEvents:UIControlEventTouchUpInside];
        
        //任何时候
        self.anyTimeBtn = [self btnWithTitle:@"任何时候"];
        [self.timeView addSubview:self.anyTimeBtn];
        self.anyTimeBtn.selected = YES;
        [self.anyTimeBtn addTarget:self action:@selector(selectCustomTime:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.customTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.top.equalTo(self.timeView);
            make.width.mas_equalTo(80);
            make.right.equalTo(self.timeView.introduceBtn.mas_left);
            
        }];
        
        [self.anyTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.top.equalTo(self.timeView);
            make.width.mas_equalTo(80);
            make.right.equalTo(self.customTimeBtn.mas_left);
            
        }];
   
        
        //时间选择
        self.publishTimeChooseView = [[TLPublishTimeChooseView alloc] initWithFrame:CGRectMake(0, self.timeView.yy, self.width, TIME_CHOOSE_VIEW_HEIGHT)];
        [self addSubview:self.publishTimeChooseView];
        self.publishTimeChooseView.height = 0;
        
        
        //仅粉丝
        self.onlyTrustView = [[TLPublishInputView alloc] initWithFrame:CGRectMake(0, self.publishTimeChooseView.yy, SCREEN_WIDTH, 45)];
        [self addSubview:self.onlyTrustView];
//        self.onlyTrustView.textField.userInteractionEnabled = NO;
        self.onlyTrustView.leftLbl.text = [LangSwitcher switchLang:@"仅粉丝" key:nil];
//        [self.onlyTrustView adddMaskBtn];
        
        //
        self.onlyTrustBtn = [[UIButton alloc] init];
        [self.onlyTrustView addSubview:self.onlyTrustBtn];
        [self.onlyTrustBtn setImage:kImage(@"未选中") forState:UIControlStateNormal];
        [self.onlyTrustBtn setImage:kImage(@"选择") forState:UIControlStateSelected];
        [self.onlyTrustBtn addTarget:self action:@selector(selectCustomTime:) forControlEvents:UIControlEventTouchUpInside];
        self.onlyTrustBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.onlyTrustBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.top.equalTo(self.onlyTrustView);
            make.right.equalTo(self.onlyTrustView.introduceBtn.mas_left);
            make.width.mas_equalTo(80);
            
        }];
        
        
        [self.onlyTrustView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.publishTimeChooseView.mas_bottom);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(HEGHT);
        }];
        
        
        
    }
    return self;
}

- (void)setDisplyTimeHint:(NSString *)displyTimeHint {
    
    _displyTimeHint = [displyTimeHint copy];
    self.timeView.hintMsg = _displyTimeHint;
    
}

- (void)setOnlyTrustHint:(NSString *)onlyTrustHint {
    
    _onlyTrustHint = onlyTrustHint;
    self.onlyTrustView.hintMsg = _onlyTrustHint;
    
}

- (void)beginWithCustomTime {
    
    self.customTimeBtn.selected = YES;
    self.anyTimeBtn.selected = !self.customTimeBtn.selected;
    self.publishTimeChooseView.height = TIME_CHOOSE_VIEW_HEIGHT;
    
}

- (void)beginWithAnyime {
    
    self.customTimeBtn.selected = NO;
    self.anyTimeBtn.selected = !self.customTimeBtn.selected;
    self.publishTimeChooseView.height = 0;

}

- (BOOL)isCustomTime {
    
    return self.customTimeBtn.isSelected;
    
}

- (BOOL)isOnlyTrust {
    
    return self.onlyTrustBtn.isSelected;
    
}

- (NSArray <NSDictionary *>*)obtainDisplayTimes;
 {
    
    return [self.publishTimeChooseView obtainTimes];
    
}

- (void)selectCustomTime:(UIButton *)btn {
    
    if ([btn isEqual:self.onlyTrustBtn]) {
        
        btn.selected = !btn.selected;
        
        return;
    }
    
    //其它事件
    btn.selected = !btn.selected;
    if ([btn isEqual:self.anyTimeBtn]) {
        
        self.customTimeBtn.selected = !self.anyTimeBtn.selected;
        
    } else if ([btn isEqual:self.customTimeBtn]) {
        
        self.anyTimeBtn.selected = !self.customTimeBtn.selected;
    
    }
    
    if (self.customTimeBtn.selected) {
        
        self.publishTimeChooseView.height = TIME_CHOOSE_VIEW_HEIGHT;
        
    } else {
        
        self.publishTimeChooseView.height = 0;
        
    }
    
}

- (void)change {
    
    
}

- (UIButton *)btnWithTitle:(NSString *)title {
    
    UIButton *btn = [UIButton buttonWithTitle:title
                                   titleColor:kTextColor
                              backgroundColor:kClearColor
                                    titleFont:13.0];
    
    [btn setImage:kImage(@"未选中") forState:UIControlStateNormal];
    [btn setImage:kImage(@"选中") forState:UIControlStateSelected];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    return btn;
    

    
}

- (CGFloat)nextShouldHeight {
    
    if (self.height == [TLHighLevelSettingsView normalHeight]) {
        
        return [TLHighLevelSettingsView fullHeight];
        
    } else {
        
        return [TLHighLevelSettingsView normalHeight];
    }
    
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    CGAffineTransform nextTransform;
    
    if (frame.size.height > [TLHighLevelSettingsView normalHeight]) {
        
        nextTransform = CGAffineTransformMakeRotation(M_PI_2);
        
    } else {
        
        nextTransform = CGAffineTransformIdentity;
        
    }
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.topIndicateArrowImgView.transform = nextTransform;
                     }];
    
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
