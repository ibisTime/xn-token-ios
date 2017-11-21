//
//  PublishBuyView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "PublishBuyView.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import "TLAlert.h"
#import <CDCommon/UIScrollView+TLAdd.h>

#define myDotNumbers     @"-0123456789.\n"
#define myNumbers          @"-0123456789\n"

@interface PublishBuyView ()<UITextFieldDelegate>

//留言
@property (nonatomic, strong) UIView *leaveMsgView;

@end

@implementation PublishBuyView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initScrollView];
        
        [self initTopView];
        //留言
        [self initLeaveMsg];
        //高级设置
        [self initHighSetting];
        //发布按钮
        [self initBottomView];
        
    }
    return self;
}

#pragma mark Init
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
    
    NSArray *textArr = @[@"价        格", @"溢  价  率", @"最  小  量", @"最  大  量", @"购买总量", @"付款方式", @"付款期限"];
    
    NSArray *rightArr = @[@"CNY", @"%", @"CNY", @"CNY", @"ETH", @"", @"分钟"];
    
    NSArray *placeHolderArr = @[@"", @"根据市场的溢价比例", @"每笔交易的最小限额", @"每笔交易的最大限额", @"请输入购买总量", @"请选择付款方式", @"请选择付款期限"];
    
    
    [textArr enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //提示
        UIButton *promptBtn = [UIButton buttonWithImageName:@"问号"];
        
        promptBtn.backgroundColor = kWhiteColor;
        
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
                    make.top.equalTo(@(idx*50)); make.right.equalTo(promptBtn.mas_left).offset(0);
                    
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
                    make.top.equalTo(@(idx*50)); make.right.equalTo(rightTextLbl.mas_left).offset(0);
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
                    make.top.equalTo(@(idx*50)); make.right.equalTo(rightTextLbl.mas_left).offset(0);
                }];
                
                self.minNumTF = textField;
                
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
                    make.top.equalTo(@(idx*50)); make.right.equalTo(rightTextLbl.mas_left).offset(0);
                }];
                
                self.maxNumTF = textField;
                
            }break;
                
            case 4:
            {
                TLTextField *textField = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) leftTitle:obj titleWidth:90 placeholder:placeHolderArr[idx]];
                
                textField.delegate = self;
                
                textField.tag = 1200 + idx;
                
                [self.scrollView addSubview:textField];
                
                textField.keyboardType = UIKeyboardTypeNumberPad;
                
                [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(@0);
                    make.height.equalTo(@50);
                    make.top.equalTo(@(idx*50)); make.right.equalTo(rightTextLbl.mas_left).offset(0);
                }];
                
                self.buyTotalTF = textField;
                
            }break;
                
            case 5:
            {
                CoinWeakSelf;
                
                TLPickerTextField *picker = [[TLPickerTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) leftTitle:obj titleWidth:90 placeholder:placeHolderArr[idx]];
                
                picker.tag = 1200 + idx;

                picker.tagNames = @[@"支付宝", @"微信", @"银行转账"];

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
                
            case 6:
            {
                
                TLPickerTextField *picker = [[TLPickerTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) leftTitle:obj titleWidth:90 placeholder:placeHolderArr[idx]];

                picker.tag = 1200 + idx;
                
                [self.scrollView addSubview:picker];
                
                [picker mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(@0);
                    make.height.equalTo(@50);
                    make.top.equalTo(@(idx*50)); make.right.equalTo(rightTextLbl.mas_left).offset(0);
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
        make.top.equalTo(@(7*50 + 10));
        make.height.equalTo(@150);
    }];
    
    self.leaveMsgView = leaveMsgView;
    
    TLTextView *textView = [[TLTextView alloc] initWithFrame:leaveMsgView.bounds];
    
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
    
    UIView *highSettingView = [[UIView alloc] init];
    
    highSettingView.backgroundColor = kWhiteColor;
    
    [self.scrollView addSubview:highSettingView];
    [highSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.top.equalTo(self.leaveMsgView.mas_bottom).offset(10);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@135);
        
    }];
    
    self.highSettingView = highSettingView;
    
    NSArray *textArr = @[@"高级设置", @"开放时间", @"仅粉丝"];
    
    [textArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
        
        textLbl.text = textArr[idx];
        
        [highSettingView addSubview:textLbl];
        [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@15);
            make.height.equalTo(@45);
            make.top.equalTo(@(idx*45));
            
        }];
        
        //分割线
        UIView *line = [[UIView alloc] init];
        
        line.backgroundColor = kLineColor;
        
        [highSettingView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@15);
            make.right.equalTo(@(-15));
            make.height.equalTo(@0.5);
            make.top.equalTo(textLbl.mas_bottom).offset(-0.5);
            
        }];
        
    }];
    
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

#pragma mark - Events
- (void)publish {
    
    PublishDraftModel *draft = [PublishDraftModel new];
    
    draft.protectPrice = self.priceTF.text;
    
    draft.premiumRate = self.premiumRateTF.text;
    
    draft.minTrade = self.minNumTF.text;
    
    draft.maxTrade = self.maxNumTF.text;
    
    draft.buyTotal = self.buyTotalTF.text;
    
    draft.payType = [NSString stringWithFormat:@"%ld", _payTypeIndex];
    
    draft.payLimit = self.payLimitPicker.text;
    
    draft.leaveMessage = self.leaveMsgTV.text;
    
    draft.isPublish = YES;
    
    if (self.buyBlock) {
        
        self.buyBlock(draft);
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
                
            case 4:
            {
                count = 8;
                
                promptStr = @"购买总量不能超过99999999哦";
                
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
            count = 8;
            
            promptStr = @"最小量的小数点位数不能超过8位哦";
        }break;
            
        case 3:
        {
            count = 8;
            
            promptStr = @"最大量的小数点位数不能超过8位哦";
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
