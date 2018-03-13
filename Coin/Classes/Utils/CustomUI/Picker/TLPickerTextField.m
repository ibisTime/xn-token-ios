//
//  XNPickerTextField.m
//  MOOM
//
//  Created by 田磊 on 16/6/23.
//  Copyright © 2016年 田磊. All rights reserved.
//

#import "TLPickerTextField.h"

#import "AppColorMacro.h"

@interface TLPickerTextField ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

@property (nonatomic,weak) UIPickerView *pickerInput;
//

@end

@implementation TLPickerTextField


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.tagNames.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
   return  self.tagNames[row];

}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row forComponent:(NSInteger)component
           reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textColor = [UIColor colorWithRed:51.0/255
                                                green:51.0/255
                                                 blue:51.0/255
                                                alpha:1.0];
//        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:Font(18.0)];
    }
    
    pickerLabel.text = [self pickerView:pickerView
                            titleForRow:row
                           forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_tagNames.count) {
        
        self.text = self.tagNames[row];
        
        self.selectIndex = row;
        
        if (self.didSelectBlock) {
            
            self.didSelectBlock(row);
        }
        
    }
}



- (void)setTagNames:(NSArray *)tagNames
{
    _tagNames = [tagNames copy];
    
    if (!self.pickerInput) {
        
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 215)];
        _pickerInput = picker;
        _pickerInput.delegate = self;
        _pickerInput.dataSource = self;
        _pickerInput.backgroundColor = [UIColor whiteColor];
        
        self.inputView = _pickerInput;
        self.isSecurity = YES;
        self.delegate = self;
        self.clearButtonMode = UITextFieldViewModeNever;
        self.tintColor = kClearColor;

        self.selectIndex = 0;
        self.textColor = kTextColor;
        
    }
    
    [self.pickerInput reloadAllComponents];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (_tagNames.count) {
        
      self.text = _tagNames[self.selectIndex];
        
        if (self.didSelectBlock) {
            
            self.didSelectBlock(self.selectIndex);
        }
    }
    
    return YES;
}

@end
