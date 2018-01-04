//
//  HourPickerView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/29.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "HourPickerView.h"

#import "CoinHeader.h"
#import "UIColor+Extension.h"

@interface HourPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UIView *pickerView;
//筛选
@property (nonatomic, strong) UIPickerView *filterPicker;
//text
@property (nonatomic, strong) UILabel *textLbl;
//第一个选择
@property (nonatomic, assign) NSInteger firstIndex;
//第二个选择
@property (nonatomic, assign) NSInteger secondIndex;

@end

@implementation HourPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init

- (UIPickerView *)filterPicker {
    
    if (!_filterPicker) {
        
        _filterPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 200)];
        
        _filterPicker.delegate = self;
        _filterPicker.dataSource = self;
        
        _filterPicker.backgroundColor = [UIColor whiteColor];
        
        [self.pickerView addSubview:_filterPicker];
    }
    
    return _filterPicker;
}

- (void)initSubviews {
    
    CoinWeakSelf;
    
    self.alpha = 0;
    self.backgroundColor = [UIColor colorWithUIColor:kBlackColor alpha:0.4];
    
    //背景
    self.pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 250)];
    
    self.pickerView.backgroundColor = kWhiteColor;
    
    [self addSubview:self.pickerView];
    //取消
    UIButton *cancelBtn = [UIButton buttonWithTitle:@"取消" titleColor:kTextColor2 backgroundColor:kClearColor titleFont:15.0];
    
    [cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    [self.pickerView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@0);
        make.height.equalTo(@50);
        make.width.equalTo(@80);
        
    }];
    
    //text
    self.textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:16.0];
    
    [self.pickerView addSubview:self.textLbl];
    [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@0);
        make.centerX.equalTo(self.pickerView.mas_centerX);
        make.height.equalTo(@50);
        
    }];
    
    //确定
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确定" titleColor:kThemeColor backgroundColor:kClearColor titleFont:15.0];
    
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
    [self.pickerView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.top.equalTo(@0);
        make.height.equalTo(@50);
        make.width.equalTo(@80);
        
    }];
    
    //分割线
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kLineColor;
    
    [self.pickerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(cancelBtn.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@0.5);
        
    }];
}

- (void)setTitle:(NSString *)title {
    
    _title = title;
    
    self.textLbl.text = title;
    
}

- (void)setFirstTagNames:(NSArray *)firstTagNames
{
    _firstTagNames = [firstTagNames copy];
    
    _firstIndex = 0;
}

- (void)setSecondTagNames:(NSArray *)secondTagNames {
    
    _secondTagNames = secondTagNames;
    
    [self.filterPicker reloadAllComponents];
    
    self.secondIndex = secondTagNames.count - 2;
}

#pragma mark - Events
- (void)show {
    
    [self.filterPicker selectRow:0 inComponent:0 animated:NO];
    
    [self.filterPicker selectRow:self.secondTagNames.count - 2 inComponent:1 animated:NO];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 1;
        
        self.pickerView.transform = CGAffineTransformMakeTranslation(0, -250);
        
    }];
}

- (void)hide {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
        
        self.pickerView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

- (void)confirm {
    
    if (self.firstIndex > self.secondIndex) {
        
        [TLAlert alertWithInfo:@"开始时间不能大于结束时间"];
        
        return ;
    }
    
    if (self.firstIndex == 24 && self.secondIndex != 25) {
        
        [TLAlert alertWithInfo:@"请将结束时间选为关闭"];
        
        return ;
    }
    
    if (self.firstIndex != 24 && self.secondIndex == 25) {
        
        [TLAlert alertWithInfo:@"请将开始时间选为关闭"];
        
        return ;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
        self.pickerView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
        if (_selectBlock) {
            
            _selectBlock(_firstIndex, _secondIndex);
        }
    }];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        
        return self.firstTagNames.count;
    }
    
    return self.secondTagNames.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        
        return self.firstTagNames[row];
        
    }
    return self.secondTagNames[row];
}

#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textColor = [UIColor colorWithRed:51.0/255
                                                green:51.0/255
                                                 blue:51.0/255
                                                alpha:1.0];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:Font(19.0)];
    }
    
    pickerLabel.text = [self pickerView:pickerView
                            titleForRow:row
                           forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component == 0) {
        
        self.firstIndex = row;
        
    } else if (component == 1) {
        
        self.secondIndex = row;
        
    }
}

@end
