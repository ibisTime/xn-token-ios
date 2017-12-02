//
//  PublishSellView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "PublishSellView.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import "TLAlert.h"
#import <UIScrollView+TLAdd.h>
#import "NSNumber+Extension.h"
#import "NSString+Extension.h"
#import "UILabel+Extension.h"
#import "UIButton+EnLargeEdge.h"

#import "HourPickerView.h"

#define myDotNumbers     @"-0123456789.\n"
#define myNumbers          @"-0123456789\n"

@interface PublishSellView ()<UITextFieldDelegate>

//留言
@property (nonatomic, strong) UIView *leaveMsgView;
//
@property (nonatomic, strong) NSArray *textArr;
//付款方式
@property (nonatomic, strong) NSArray *payTypeArr;
//高级设置选择
@property (nonatomic, assign) BOOL isSelect;
//任何时候
@property (nonatomic, assign) BOOL isAnyTime;
//右边小箭头
@property (nonatomic, strong) UIImageView *rightArrowIV;
//开放时间
@property (nonatomic, strong) UIView *openTimeView;
//仅受信任
@property (nonatomic, strong) UIView *onlyTrustView;
//时间
@property (nonatomic, strong) UIView *timeView;
//时间选择
@property (nonatomic, strong) HourPickerView *hourPicker;
//周几
@property (nonatomic, assign) NSInteger weekDay;

@end

@implementation PublishSellView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initScrollView];
        
        [self initTopView];
        //留言
        [self initLeaveMsg];
        //时间
        [self initTimeView];
        //高级设置
        [self initHighSetting];
        //发布按钮
        [self initBottomView];
        //
        [self viewHiddenWithSelect:self.isSelect];
        
    }
    return self;
}

#pragma mark Init

- (HourPickerView *)hourPicker {
    
    if (!_hourPicker) {
        
        CoinWeakSelf;
        
        NSMutableArray *hours = [NSMutableArray array];
        
        for (int i = 0; i < 25; i++) {
            
            NSString *hour = [NSString stringWithFormat:@"%02d:00", i];
            
            [hours addObject:hour];
        };
        
        _hourPicker = [[HourPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        _hourPicker.title = @"自定义";
        
        _hourPicker.selectBlock = ^(NSInteger firstIndex, NSInteger secondIndex) {
            
            UILabel *textLbl = [weakSelf.timeView viewWithTag:1710 + weakSelf.weekDay];
            
            if (firstIndex < secondIndex ) {
                
                textLbl.text = [NSString stringWithFormat:@"%02ld:00\n~\n%02ld:00", firstIndex, secondIndex];
                
                [weakSelf.startHourArr replaceObjectAtIndex:weakSelf.weekDay withObject:[NSString stringWithFormat:@"%ld", firstIndex]];
                
                [weakSelf.endHourArr replaceObjectAtIndex:weakSelf.weekDay withObject:[NSString stringWithFormat:@"%ld", secondIndex]];
                
            } else if(firstIndex == secondIndex) {
                
                textLbl.text = [NSString stringWithFormat:@"关闭\n~\n关闭"];
                
                [weakSelf.startHourArr replaceObjectAtIndex:weakSelf.weekDay withObject:[NSString stringWithFormat:@"24"]];
                
                [weakSelf.endHourArr replaceObjectAtIndex:weakSelf.weekDay withObject:[NSString stringWithFormat:@"24"]];
                
            }
            
        };
        
        _hourPicker.firstTagNames = [hours copy];
        
        _hourPicker.secondTagNames = [hours copy];
        
    }
    
    return _hourPicker;
}

- (void)initScrollView {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.scrollView adjustsContentInsets];
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@(kSuperViewHeight - 60 - kBottomInsetHeight));
        
    }];
    
}

- (void)initTopView {
    
    self.textArr = @[@"价        格", @"溢  价  率", @"最  低  价", @"最  小  量", @"最  大  量", @"出售总量", @"收款方式", @"收款期限"];
    
    NSArray *rightArr = @[@"CNY", @"%", @"CNY", @"CNY", @"CNY", @"ETH", @"", @"分钟"];
    
    NSArray *placeHolderArr = @[@"", @"根据市场的溢价比例", @"广告最低可成交的价格", @"每笔交易的最小限额", @"每笔交易的最大限额", @"请输入出售总量", @"请选择收款方式", @"请选择收款期限"];

    self.payTypeArr = @[@"支付宝", @"微信", @"银行转账"];
    
    [self.textArr enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //提示
        UIButton *promptBtn = [UIButton buttonWithImageName:@"问号"];
        
        promptBtn.backgroundColor = kWhiteColor;
        
        promptBtn.tag = 1500 + idx;

        [promptBtn addTarget:self action:@selector(lookPrompt:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:promptBtn];
        [promptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.scrollView.mas_left).offset(kScreenWidth - 45);
            make.top.equalTo(self.scrollView.mas_top).offset(idx*50);
            make.width.equalTo(@(45));
            make.height.equalTo(@(50));
            
        }];
        
        //rightText
        UILabel *rightTextLbl = [UILabel labelWithBackgroundColor:kWhiteColor textColor:kTextColor font:15.0];
        
        rightTextLbl.text = rightArr[idx];
        
        rightTextLbl.textAlignment = NSTextAlignmentRight;
        
        [self.scrollView addSubview:rightTextLbl];
        [rightTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(promptBtn.mas_left).offset(0);
            make.top.equalTo(self.scrollView.mas_top).offset(idx*50);
            make.width.equalTo(@40);
            make.height.equalTo(@50);
            
        }];
        
        //arrowIV
        UIImageView *arrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多拷贝")];
        
        arrowIV.backgroundColor = kWhiteColor;
        
        arrowIV.contentMode = UIViewContentModeScaleAspectFit;
        
        if (idx == rightArr.count - 2) {
            
            [self.scrollView addSubview:arrowIV];
            
            [arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(promptBtn.mas_left).offset(0);
                make.top.equalTo(self.scrollView.mas_top).offset((rightArr.count - 2)*50 + 20);
                make.width.equalTo(@6);
                make.height.equalTo(@10);
                
            }];
        }
        
        //textField
        
        switch (idx) {
            case 0:
            {
                TLTextField *textField = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) leftTitle:obj titleWidth:90 placeholder:placeHolderArr[idx]];
                
                textField.delegate = self;
                
                textField.tag = 1200 + idx;
                
                textField.enabled = NO;
                
                [self.scrollView addSubview:textField];
                
                [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(@0);
                    make.height.equalTo(@50);
                    make.top.equalTo(@(idx*50));
                    make.right.equalTo(rightTextLbl.mas_left).offset(0);
                    
                }];
                
                self.priceTF = textField;
                
            }break;
                
            case 1:
            {
                
                TLTextField *textField = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) leftTitle:obj titleWidth:90 placeholder:placeHolderArr[idx]];
                
                textField.delegate = self;
                
                textField.tag = 1200 + idx;
                
                [textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
                [self.scrollView addSubview:textField];
                
                textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                
                [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(@0);
                    make.height.equalTo(@50);
                    make.top.equalTo(@(idx*50));
                    make.right.equalTo(rightTextLbl.mas_left).offset(0);
                }];
                
                self.premiumRateTF = textField;
                
            }break;
                
            case 2:
            {
                TLTextField *textField = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) leftTitle:obj titleWidth:90 placeholder:placeHolderArr[idx]];
                
                textField.delegate = self;
                
                textField.tag = 1200 + idx;
                
                [self.scrollView addSubview:textField];
                
                textField.keyboardType = UIKeyboardTypeDecimalPad;
                
                [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(@0);
                    make.height.equalTo(@50);
                    make.top.equalTo(@(idx*50));
                    make.right.equalTo(rightTextLbl.mas_left).offset(0);
                }];
                
                self.lowNumTF = textField;
                
            }break;
                
            case 3:
            {
                TLTextField *textField = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) leftTitle:obj titleWidth:90 placeholder:placeHolderArr[idx]];
                
                textField.delegate = self;
                
                textField.tag = 1200 + idx;
                
                [self.scrollView addSubview:textField];
                
                textField.keyboardType = UIKeyboardTypeDecimalPad;
                
                [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(@0);
                    make.height.equalTo(@50);
                    make.top.equalTo(@(idx*50));
                    make.right.equalTo(rightTextLbl.mas_left).offset(0);
                }];
                
                self.minNumTF = textField;
                
            }break;
                
            case 4:
            {
                TLTextField *textField = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) leftTitle:obj titleWidth:90 placeholder:placeHolderArr[idx]];
                
                textField.delegate = self;
                
                textField.tag = 1200 + idx;
                
                [self.scrollView addSubview:textField];
                
                textField.keyboardType = UIKeyboardTypeDecimalPad;
                
                [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(@0);
                    make.height.equalTo(@50);
                    make.top.equalTo(@(idx*50));
                    make.right.equalTo(rightTextLbl.mas_left).offset(0);
                }];
                
                self.maxNumTF = textField;
                
            }break;
                
            case 5:
            {
                TLTextField *textField = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) leftTitle:obj titleWidth:90 placeholder:placeHolderArr[idx]];
                
                textField.delegate = self;
                
                textField.tag = 1200 + idx;
                
                [self.scrollView addSubview:textField];
                
                textField.keyboardType = UIKeyboardTypeDecimalPad;

                [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(@0);
                    make.height.equalTo(@50);
                    make.top.equalTo(@(idx*50));
                    make.right.equalTo(rightTextLbl.mas_left).offset(0);
                }];
                
                self.buyTotalTF = textField;
                
            }break;
                
            case 6:
            {
                CoinWeakSelf;
                
                TLPickerTextField *picker = [[TLPickerTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) leftTitle:obj titleWidth:90 placeholder:placeHolderArr[idx]];
                
                picker.tag = 1200 + idx;
                
                picker.tagNames = self.payTypeArr;
                
                picker.didSelectBlock = ^(NSInteger index) {
                    
                    weakSelf.payTypeIndex = index;
                };
                
                [self.scrollView addSubview:picker];
                
                [picker mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(@0);
                    make.height.equalTo(@50);
                    make.top.equalTo(@(idx*50));
                    make.right.equalTo(arrowIV.mas_left).offset(-10);
                    
                }];
                
                self.payTypePicker = picker;
                
            }break;
                
            case 7:
            {
                
                TLPickerTextField *picker = [[TLPickerTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) leftTitle:obj titleWidth:90 placeholder:placeHolderArr[idx]];
                
                picker.tag = 1200 + idx;
                
                [self.scrollView addSubview:picker];
                
                [picker mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(@0);
                    make.height.equalTo(@50);
                    make.top.equalTo(@(idx*50));
                    make.right.equalTo(rightTextLbl.mas_left).offset(0);
                }];
                
                self.payLimitPicker = picker;
                
            }break;
                
            default:
                break;
        }
        
        //分割线
        UIView *line = [[UIView alloc] init];
        
        line.backgroundColor = kLineColor;
        
        [self.scrollView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@15);
            make.right.equalTo(@(-15));
            make.height.equalTo(@0.5);
            make.top.equalTo(@((idx+1)*50 - 0.5));
            
        }];
        
    }];
}

- (void)initLeaveMsg {
    
    UIView *leaveMsgView = [[UIView alloc] init];
    
    leaveMsgView.backgroundColor = kWhiteColor;
    
    [self.scrollView addSubview:leaveMsgView];
    [leaveMsgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.width.equalTo(@(kScreenWidth));
        make.top.equalTo(@(self.textArr.count*50 + 10));
        make.height.equalTo(@150);
    }];
    
    self.leaveMsgView = leaveMsgView;
    
    TLTextView *textView = [[TLTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];

    textView.font = Font(14.0);

    textView.placholder = @"请写下您的广告留言吧";
    
    [leaveMsgView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@10);
        make.right.equalTo(@(-15));
        make.bottom.equalTo(@(-15));
        
    }];
    
    self.leaveMsgTV = textView;
}

- (void)initHighSetting {
    
    //高级设置
    UIView *highSettingView = [[UIView alloc] init];
    
    highSettingView.backgroundColor = kWhiteColor;
    
    [self.scrollView addSubview:highSettingView];
    [highSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.top.equalTo(self.leaveMsgView.mas_bottom).offset(10);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@60);
        
    }];
    
    self.highSettingView = highSettingView;
    
    //点击高级设置
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHighSetting:)];
    
    [highSettingView addGestureRecognizer:tapGR];
    
    UILabel *highLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    //    highLbl.text = @"高级设置(选填)";
    
    highLbl.tag = 1600;
    
    [highSettingView addSubview:highLbl];
    [highLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.height.equalTo(@50);
        make.top.equalTo(@0);
        
    }];
    
    [highLbl labelWithString:@"高级设置(选填)" title:@"(选填)" font:Font(15.0) color:kTextColor2];
    
    //右边小箭头
    UIImageView *rightArrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
    
    [highSettingView addSubview:rightArrowIV];
    [rightArrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(highSettingView.mas_right).offset(-15);
        make.width.equalTo(@6.5);
        make.centerY.equalTo(highSettingView.mas_centerY);
        
    }];
    
    self.rightArrowIV = rightArrowIV;
    
    //分割线
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kBackgroundColor;
    
    [self.highSettingView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.right.equalTo(@(0));
        make.height.equalTo(@10);
        make.top.equalTo(@50);
        
    }];
    
    [self initOpenTimeView];
    
    
}

- (void)initOpenTimeView {
    
    //开放时间
    self.openTimeView = [[UIView alloc] init];
    
    self.openTimeView.backgroundColor = kWhiteColor;
    
    [self.scrollView addSubview:self.openTimeView];
    [self.openTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.top.equalTo(self.highSettingView.mas_bottom);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@50);
        
    }];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    textLbl.text = @"开放时间";
    
    [self.openTimeView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.height.equalTo(@45);
        make.top.equalTo(@0);
        
    }];
    
    //问号
    UIButton *promptBtn = [UIButton buttonWithImageName:@"问号"];
    
    promptBtn.backgroundColor = kWhiteColor;
    
    promptBtn.tag = 1508;
    
    [promptBtn addTarget:self action:@selector(lookPrompt:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.openTimeView addSubview:promptBtn];
    [promptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kScreenWidth - 45));
        make.top.equalTo(@0);
        make.width.equalTo(@(45));
        make.height.equalTo(@(50));
        
    }];
    
    //自定义
    UIButton *customTimeBtn = [UIButton buttonWithTitle:@"自定义" titleColor:kTextColor backgroundColor:kClearColor titleFont:13.0];
    
    [customTimeBtn addTarget:self action:@selector(selectCustomTime:) forControlEvents:UIControlEventTouchUpInside];
    
    [customTimeBtn setImage:kImage(@"未选中") forState:UIControlStateNormal];
    
    [customTimeBtn setImage:kImage(@"选中") forState:UIControlStateSelected];
    
    customTimeBtn.tag = 1700;
    
    [self.openTimeView addSubview:customTimeBtn];
    [customTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@0);
        make.right.equalTo(promptBtn.mas_left).offset(0);
        make.height.equalTo(@50);
        make.width.equalTo(@80);
        
    }];
    
    [customTimeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    
    [customTimeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    //任何时候
    UIButton *anyTimeBtn = [UIButton buttonWithTitle:@"任何时候" titleColor:kTextColor backgroundColor:kClearColor titleFont:13.0];
    
    anyTimeBtn.selected = YES;
    
    [anyTimeBtn setImage:kImage(@"未选中") forState:UIControlStateNormal];
    
    [anyTimeBtn setImage:kImage(@"选中") forState:UIControlStateSelected];
    
    [anyTimeBtn addTarget:self action:@selector(selectAnyTime:) forControlEvents:UIControlEventTouchUpInside];
    
    anyTimeBtn.tag = 1701;
    
    [self.openTimeView addSubview:anyTimeBtn];
    [anyTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@0);
        make.right.equalTo(customTimeBtn.mas_left).offset(0);
        make.height.equalTo(@50);
        make.width.equalTo(@80);
        
    }];
    
    self.anyTimeBtn = anyTimeBtn;
    
    [anyTimeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    
    [anyTimeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    //分割线
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kLineColor;
    
    [self.openTimeView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.height.equalTo(@0.5);
        make.bottom.equalTo(@(-0.5));
        
    }];
    
}

- (void)initTimeView {
    
    self.startHourArr = [NSMutableArray array];
    
    self.endHourArr = [NSMutableArray array];
    
    for (int i = 0; i < 7; i++) {
        
        [self.startHourArr addObject:@"0"];
        
        [self.endHourArr addObject:@"24"];
    };
    
    //时间
    self.timeView = [[UIView alloc] init];
    
    self.timeView.backgroundColor = kWhiteColor;
    
    [self.scrollView addSubview:self.timeView];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.top.equalTo(self.leaveMsgView.mas_bottom).offset(30);
        make.height.equalTo(@140);
        make.width.equalTo(@(kScreenWidth));
        
    }];
    
    NSArray *weekArr = @[@"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", @"星期日"];
    
    CGFloat btnW = kScreenWidth/(weekArr.count*1.0);
    
    [weekArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
        
        textLbl.text = weekArr[idx];
        
        textLbl.textAlignment = NSTextAlignmentCenter;
        
        [self.timeView addSubview:textLbl];
        [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(btnW*idx));
            make.top.equalTo(@10);
            make.width.equalTo(@(btnW));
            
        }];
        
        UILabel *timeLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
        
        timeLbl.numberOfLines = 0;
        
        timeLbl.textAlignment = NSTextAlignmentCenter;
        
        timeLbl.tag = 1710 + idx;
        
        timeLbl.text = [NSString stringWithFormat:@"%02ld:00\n~\n%02ld:00", [self.startHourArr[idx] integerValue], [self.endHourArr[idx] integerValue]];
        
        [self.timeView addSubview:timeLbl];
        [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(btnW*idx));
            make.top.equalTo(textLbl.mas_bottom).offset(10);
            make.width.equalTo(@(btnW));
            
        }];
        
        //按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.tag = 1720 + idx;
        
        [btn addTarget:self action:@selector(clickSelectTime:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.timeView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(btnW*idx));
            make.top.equalTo(@0);
            make.width.equalTo(@(btnW));
            make.height.equalTo(@(90));
        }];
        
    }];
    
    //分割线
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kLineColor;
    
    [self.timeView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.height.equalTo(@0.5);
        make.bottom.equalTo(@(-0.5));
        
    }];
    
    [self initOnlyTrustView];
}

- (void)initOnlyTrustView {
    
    //仅粉丝
    self.onlyTrustView = [[UIView alloc] init];
    
    self.onlyTrustView.backgroundColor = kWhiteColor;
    
    [self.timeView addSubview:self.onlyTrustView];
    [self.onlyTrustView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.top.equalTo(self.timeView.mas_top).offset(90);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@50);
        
    }];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    textLbl.text = @"仅粉丝";
    
    [self.onlyTrustView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.height.equalTo(@45);
        make.top.equalTo(@0);
        
    }];
    
    //问号
    UIButton *promptBtn = [UIButton buttonWithImageName:@"问号"];
    
    promptBtn.backgroundColor = kWhiteColor;
    
    promptBtn.tag = 1509;
    
    [promptBtn addTarget:self action:@selector(lookPrompt:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.onlyTrustView addSubview:promptBtn];
    [promptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kScreenWidth - 45));
        make.top.equalTo(@0);
        make.width.equalTo(@(45));
        make.height.equalTo(@(50));
        
    }];
    
    //自定义
    UIButton *selectBtn = [UIButton buttonWithTitle:@"" titleColor:kTextColor backgroundColor:kClearColor titleFont:13.0];
    
    [selectBtn addTarget:self action:@selector(selectOnlyTrust:) forControlEvents:UIControlEventTouchUpInside];
    
    [selectBtn setImage:kImage(@"未选中") forState:UIControlStateNormal];
    
    [selectBtn setImage:kImage(@"选择") forState:UIControlStateSelected];
    
    [selectBtn setEnlargeEdgeWithTop:0 right:0 bottom:0 left:100];
    
    [self.onlyTrustView addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@0);
        make.right.equalTo(promptBtn.mas_left).offset(0);
        make.height.equalTo(@50);
        
    }];
    
    self.onlyTrustBtn = selectBtn;
    
}

- (void)initBottomView {
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kSuperViewHeight - 60 - kBottomInsetHeight, kScreenWidth, 60 + kBottomInsetHeight)];
    
    self.bottomView.backgroundColor = kWhiteColor;
    
    [self addSubview:self.bottomView];
    
    //发布按钮
    UIButton *publishBtn = [UIButton buttonWithTitle:@"直接发布" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:16.0 cornerRadius:5];
    
    [publishBtn addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:publishBtn];
    [publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.right.equalTo(self.bottomView.mas_right).offset(-15);
        make.height.equalTo(@(45));
        make.top.equalTo(@(7.5));
        
    }];
    
}

#pragma mark - Setting
- (void)setTimeArr:(NSArray *)timeArr {
    
    _timeArr = timeArr;
    
    self.payLimitPicker.tagNames = timeArr;
    
}

- (void)setMarketPrice:(NSString *)marketPrice {
    
    _marketPrice = marketPrice;
    
    self.priceTF.text = marketPrice;
    
}

- (void)setAdvertise:(AdvertiseModel *)advertise {
    
    _advertise = advertise;
    //最低价
    self.lowNumTF.text = [advertise.protectPrice convertToSimpleRealMoney];
    //溢价率
    CGFloat rate = [[advertise.premiumRate convertToRealMoneyWithNum:4] doubleValue]*100;
    
    self.premiumRateTF.text = [NSString stringWithFormat:@"%lg", rate];
    //最小量
    self.minNumTF.text = [advertise.minTrade convertToSimpleRealMoney];
    //最大量
    self.maxNumTF.text = [advertise.maxTrade convertToSimpleRealMoney];
    //购买数量
    self.buyTotalTF.text = [advertise.totalCountString convertToSimpleRealCoin];
    //付款方式
    NSInteger index = [advertise.payType integerValue];
    
    self.payTypePicker.text = self.payTypeArr[index];
    
    //付款期限
    self.payLimitPicker.text = [NSString stringWithFormat:@"%ld", advertise.payLimit];
    
    //留言
    self.leaveMsgTV.text = advertise.leaveMessage;
    
    UIButton *customTimeBtn = [self.openTimeView viewWithTag:1700];
    
    UIButton *anyTimeBtn = [self.openTimeView viewWithTag:1701];
    
    if (advertise.displayTime) {
        
        [advertise.displayTime enumerateObjectsUsingBlock:^(Displaytime * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self.startHourArr replaceObjectAtIndex:idx withObject:[NSString stringWithFormat:@"%ld", obj.startTime]];
            
            [self.endHourArr replaceObjectAtIndex:idx withObject:[NSString stringWithFormat:@"%ld", obj.endTime]];
            
            [self.endHourArr replaceObjectAtIndex:idx withObject:@"24"];
            
            UILabel *timeLbl = [self.timeView viewWithTag:1710 + idx];
            
            if (obj.startTime != 24) {
                
                timeLbl.text = [NSString stringWithFormat:@"%02ld:00\n~\n%02ld:00", obj.startTime, obj.endTime];
                
            } else {
                
                timeLbl.text = [NSString stringWithFormat:@"关闭\n~\n关闭"];
                
            }
        }];
        
        customTimeBtn.selected = YES;
        
        anyTimeBtn.selected = !customTimeBtn.selected;
        
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.highSettingView.yy + 10 + 190);
        
        self.timeView.transform = CGAffineTransformMakeTranslation(0, 90);
        
    } else {
        
        customTimeBtn.selected = NO;
        
        anyTimeBtn.selected = !customTimeBtn.selected;
    }
    
    self.onlyTrustBtn.selected = [advertise.onlyTrust isEqualToString:@"0"] ? NO: YES;

}

#pragma mark - Events
- (void)publish {
    
    PublishDraftModel *draft = [PublishDraftModel new];
    
    draft.protectPrice = self.lowNumTF.text;
    
    draft.premiumRate = self.premiumRateTF.text;
    
    draft.minTrade = self.minNumTF.text;
    
    draft.maxTrade = self.maxNumTF.text;
    
    draft.buyTotal = self.buyTotalTF.text;
    
    draft.payType = [NSString stringWithFormat:@"%ld", _payTypeIndex];
    
    draft.payLimit = self.payLimitPicker.text;
    
    draft.leaveMessage = self.leaveMsgTV.text;
    
    draft.isPublish = YES;
    
    draft.onlyTrust = [NSString stringWithFormat:@"%d", self.onlyTrustBtn.selected];

    if (self.sellBlock) {
        
        self.sellBlock(draft);
    }
}

- (void)textDidChange:(UITextField *)sender {
    
    CGFloat preRate = [sender.text doubleValue];
    
    if (preRate > -100 && preRate < 100) {
        
        CGFloat prePrice = [self.marketPrice doubleValue]*(preRate/100.0 + 1);
        
        self.priceTF.text = [NSString stringWithFormat:@"%.4lf", prePrice];
        
    } else {
        
        [TLAlert alertWithInfo:@"溢价率应在-99.99~99.99之间"];
    }
    
}

- (void)lookPrompt:(UIButton *)sender {
    
    NSArray *keyArr = @[@"price", @"premiumRate", @"protectPrice", @"minTrade", @"maxTrade", @"totalCount", @"payType", @"payLimit", @"displayTime", @"trust"];
    
    NSInteger index = sender.tag - 1500;
    
    __block NSString *prompt = @"";
    
    [self.values enumerateObjectsUsingBlock:^(KeyValueModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.ckey isEqualToString:keyArr[index]]) {
            
            
            prompt = obj.cvalue;
        }
    }];
    
    [TLAlert alertWithTitle:@"提示" message:prompt confirmMsg:@"关闭" confirmAction:^{
        
        
    }];
}

- (void)clickHighSetting:(UITapGestureRecognizer *)tapGR {
    
    //未选择，就开放
    
    CGFloat pointY = 200;
    
    CGRect frame = _scrollView.frame;
    frame.origin.x = 0;
    frame.origin.y = pointY;
    
    if (!self.isSelect) {
        
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.highSettingView.yy + 10 + 190);
        //改变scrollView高度
        self.scrollView.height += pointY;

        [self viewHiddenWithSelect:!self.isSelect];
        
        [UIView animateWithDuration:0.25 animations:^{
            //向上偏移
            self.scrollView.transform = CGAffineTransformMakeTranslation(0, -pointY);
            
            self.rightArrowIV.transform = CGAffineTransformMakeRotation(M_PI_2);
            
        } completion:^(BOOL finished) {
            
            self.isSelect = YES;
            
        }];
        
    } else {
        
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.highSettingView.yy);
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.scrollView.transform = CGAffineTransformIdentity;

            self.rightArrowIV.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
            self.isSelect = NO;
            
            self.scrollView.height -= pointY;

            [self viewHiddenWithSelect:self.isSelect];
            
        }];
    }
    
}

- (void)selectCustomTime:(UIButton *)sender {
    
    if (sender.selected) {
        
        return ;
    }
    
    sender.selected = !sender.selected;
    
    UIButton *btn = [self.openTimeView viewWithTag:1701];
    
    btn.selected = !sender.selected;
    
    if (sender.selected) {
        
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.highSettingView.yy + 10 + 190);
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.timeView.transform = CGAffineTransformMakeTranslation(0, 90);
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)selectAnyTime:(UIButton *)sender {
    
    if (sender.selected) {
        
        return ;
    }
    
//    for (int i = 0; i < 7; i++) {
//
//        [self.startHourArr replaceObjectAtIndex:i withObject:@"0"];
//
//        [self.endHourArr replaceObjectAtIndex:i withObject:@"24"];
//    };
//
//    [self.startHourArr enumerateObjectsUsingBlock:^(Displaytime * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//        UILabel *timeLbl = [self.timeView viewWithTag:1710 + idx];
//
//        timeLbl.text = [NSString stringWithFormat:@"%02ld:00\n~\n%02ld:00", [self.startHourArr[idx] integerValue], [self.endHourArr[idx] integerValue]];
//
//    }];
    
    sender.selected = !sender.selected;
    
    UIButton *btn = [self.openTimeView viewWithTag:1700];
    
    btn.selected = !sender.selected;
    
    if (sender.selected) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.timeView.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)clickSelectTime:(UIButton *)sender {
    
    self.weekDay = sender.tag - 1720;
    
    [self.hourPicker show];
}

- (void)selectOnlyTrust:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
}

- (void)viewHiddenWithSelect:(BOOL)selected {
    
    self.openTimeView.hidden = !selected;
    
    self.timeView.hidden = !selected;
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"] || [string isEqualToString:@""]) {//按下return
        return YES;
    }
    
    NSCharacterSet *cs;
    NSUInteger nDotLoc = [textField.text rangeOfString:@"."].location;
    
    NSInteger index = textField.tag - 1200;
    
    NSInteger count = 0;
    
    NSString *promptStr;
    
    if (NSNotFound == nDotLoc && 0 != range.location) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers] invertedSet];
        if ([string isEqualToString:@"."]) {
            return YES;
        }
        
        switch (index) {
            case 1:
            {
                count = 2;
                
                if ([textField.text containsString:@"-"]) {
                    
                    count = 3;
                }
                
                promptStr = @"溢价率要在-99.99~99.99之间哦";
                
                if (textField.text.length >= count) {  //小数点前面6位
                    
                    [TLAlert alertWithInfo:promptStr];
                    return NO;
                }
                
            }break;
                
            case 5:
            {
                count = 8;
                
                promptStr = @"出售总量不能超过99999999哦";
                
                if (textField.text.length >= count) {  //小数点前面6位
                    
                    [TLAlert alertWithInfo:promptStr];
                    return NO;
                }
                
            }break;
                
            default:
                break;
        }
        
    }
    else {
        
        cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers] invertedSet];
        if (textField.text.length >= 12) {
            
            return NO;
        }
    }
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest) {
        return NO;
    }
    
    switch (index) {
        case 1:
        {
            count = 2;
            
            promptStr = @"溢价率的小数点位数不能超过2位哦";
        }break;
            
        case 2:
        {
            count = 2;
            
            promptStr = @"最低价的小数点位数不能超过2位哦";
            
        }break;
            
        case 3:
        {
            count = 2;
            
            promptStr = @"最小量的小数点位数不能超过2位哦";
        }break;
            
        case 4:
        {
            count = 2;
            
            promptStr = @"最大量的小数点位数不能超过2位哦";
        }break;
            
        case 5:
        {
            count = 8;
            
            promptStr = @"出售总量的小数点不能超过8位哦";
            
        }break;
            
        default:
            break;
    }
    
    if (NSNotFound != nDotLoc && range.location > nDotLoc + count) {
        
        [TLAlert alertWithInfo:promptStr];
        
        return NO;  //小数点后面两位
    }
    if (NSNotFound != nDotLoc && range.location > nDotLoc && [string isEqualToString:@"."]) {
        return NO;  //控制只有一个小数点
    }
    return YES;
}

@end
