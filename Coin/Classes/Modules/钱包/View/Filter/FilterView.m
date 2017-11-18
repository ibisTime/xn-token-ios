//
//  FilterView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "FilterView.h"
#import "CoinHeader.h"
#import "UIColor+Extension.h"

@interface FilterView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UIView *pickerView;
//筛选
@property (nonatomic, strong) UIPickerView *filterPicker;
//text
@property (nonatomic, strong) UILabel *textLbl;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation FilterView

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

- (void)setTagNames:(NSArray *)tagNames
{
    _tagNames = [tagNames copy];
    
    [self.filterPicker reloadAllComponents];
    
    [self.filterPicker selectedRowInComponent:0];

    self.selectIndex = 0;
}

#pragma mark - Events
- (void)show {
    
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
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
        
        self.pickerView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];

        if (_selectBlock) {
            
            _selectBlock(_selectIndex);
        }
    }];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.tagNames.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return  self.tagNames[row];
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
    if (_tagNames.count) {
        
        self.textLbl.text = _tagNames[row];
        
        self.selectIndex = row;
        
    }
}

@end
