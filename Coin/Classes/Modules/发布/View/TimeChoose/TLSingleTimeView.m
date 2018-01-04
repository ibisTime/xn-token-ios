//
//  TLSingleTimeView.m
//  Coin
//
//  Created by  tianlei on 2018/1/03.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TLSingleTimeView.h"
#import "TLUIHeader.h"
#import "HourPickerView.h"

@interface TLSingleTimeView ()

//时间选择
@property (nonatomic, strong) HourPickerView *hourPicker;


@end

@implementation TLSingleTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //周几
        self.weekLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor whiteColor]
                                          font:[UIFont systemFontOfSize:14]
                                     textColor:[UIColor textColor]];
        [self addSubview:self.weekLbl];
        
        //
        self.beginTimeLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor whiteColor]
                                          font:[UIFont systemFontOfSize:14]
                                     textColor:[UIColor textColor]];
        [self addSubview:self.beginTimeLbl];
        
        //分割符
        UILabel *markLbl = [UILabel labelWithFrame:CGRectZero
                                       textAligment:NSTextAlignmentCenter
                                    backgroundColor:[UIColor whiteColor]
                                               font:[UIFont systemFontOfSize:14]
                                          textColor:[UIColor textColor]];
        [self addSubview:markLbl];
        markLbl.text = @"~";
        
        
        
        //end
        self.endTimeLbl = [UILabel labelWithFrame:CGRectZero
                                       textAligment:NSTextAlignmentCenter
                                    backgroundColor:[UIColor whiteColor]
                                               font:[UIFont systemFontOfSize:14]
                                          textColor:[UIColor textColor]];
        [self addSubview:self.endTimeLbl];
        [self.weekLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_top).offset(8);
            make.left.right.equalTo(self);
            
        }];
        
        [self.beginTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.weekLbl.mas_bottom).offset(8);
            make.left.right.equalTo(self);
            
        }];
        
        //分隔符
        [markLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.beginTimeLbl.mas_bottom).offset(3);
            make.left.right.equalTo(self);
            
        }];
        
        [self.endTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(markLbl.mas_bottom).offset(3);
            make.left.right.equalTo(self);
            
        }];
         
         
        
//        [self data];
        [self addTarget:self action:@selector(chooseTime) forControlEvents:UIControlEventTouchUpInside];
        
        __weak typeof(self) weakself = self;
        [self.hourPicker setSelectBlock:^(NSInteger firstIndex, NSInteger secondIndex) {
            
            NSLog(@"%ld-%ld",firstIndex,secondIndex);
            
            //变ui
            
            weakself.beginTimeLbl.text = [weakself beginHourStringByIndex:firstIndex];
            weakself.endTimeLbl.text = [weakself endHourStringByIndex:secondIndex];

            
            //开始为 0~24
            //结束为 0~25
            //变数据
            if (firstIndex == 24 && secondIndex == 25) {
                
                weakself.displayTime.startTime = 24;
                weakself.displayTime.endTime = 24;
            } else {
                
                weakself.displayTime.startTime = firstIndex;
                weakself.displayTime.endTime = secondIndex;

            }
  
        }];
    }
    return self;
}

//- (void)setDisplayTime:(Displaytime *)displayTime {
//
//
//
//}



- (void)setDisplayTime:(Displaytime *)displayTime {
    
    _displayTime = displayTime;
    
    self.beginTimeLbl.text = [self beginHourStringByIndex:displayTime.startTime];
    self.endTimeLbl.text = [self endHourStringByIndex:displayTime.endTime];

    
}



- (void)chooseTime {
    
    [self.hourPicker show];
    
}

- (NSString *)beginHourStringByIndex:(NSInteger)idx {
    
    
    NSString *str = nil;
    if (idx == 24) {

        str = @"关闭";
        
    } else {
        
        str = [NSString stringWithFormat:@"%02ld:00", idx];
        
    }
    
    return str;
}

- (NSString *)endHourStringByIndex:(NSInteger)idx {
    
    
    NSString *str = nil;
    if (idx == 24) {
        
        str = @"23:59";
        
    } else if(idx == 25) {
        
        str = @"关闭";

    } else {
        
        str = [NSString stringWithFormat:@"%02ld:00", idx];

    }

    return str;
}

//- (Displaytime *)displayTime {
//    return nil;
//}

//- (Displaytime *)displayTime {
//
//    if (!_displayTime) {
//
//        _displayTime = [Displaytime new];
//
//    }
//
//    return _displayTime;
//
//}

- (HourPickerView *)hourPicker {
    
    if (!_hourPicker) {
        
        //        CoinWeakSelf;
        NSMutableArray *leftHours = [NSMutableArray array];
        NSMutableArray *rightHours = [NSMutableArray array];
        
        for (int i = 0; i < 26; i++) {
            
            NSString *leftHour = [NSString stringWithFormat:@"%02d:00", i];
            NSString *rightHour = [NSString stringWithFormat:@"%02d:00", i];
            
            if (i == 24) {
                
                leftHour = @"关闭";
                rightHour = @"23:59";
                
            } else if (i == 25) {
                
                rightHour = @"关闭";
            }
            
            if (i < 25) {
                
                [leftHours addObject:leftHour];
            }
            
            [rightHours addObject:rightHour];
            
        };
        
        _hourPicker = [[HourPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _hourPicker.title = [LangSwitcher switchLang:@"自定义" key:nil];
        
//        _hourPicker.selectBlock = ^(NSInteger firstIndex, NSInteger secondIndex) {
//
//            UILabel *textLbl = [weakSelf.timeView viewWithTag:1710 + weakSelf.weekDay];
//
//            if (firstIndex == 24 && secondIndex == 25) {
//
//                textLbl.text = [NSString stringWithFormat:@"关闭\n~\n关闭"];
//
//                [weakSelf.startHourArr replaceObjectAtIndex:weakSelf.weekDay withObject:[NSString stringWithFormat:@"24"]];
//
//                [weakSelf.endHourArr replaceObjectAtIndex:weakSelf.weekDay withObject:[NSString stringWithFormat:@"24"]];
//
//                return ;
//            }
//
//            if (firstIndex < secondIndex) {
//
//                if (secondIndex != 24) {
//
//                    textLbl.text = [NSString stringWithFormat:@"%02ld:00\n~\n%02ld:00", firstIndex, secondIndex];
//
//                } else {
//
//                    textLbl.text = [NSString stringWithFormat:@"%02ld:00\n~\n23:59", firstIndex];
//
//                }
//
//                [weakSelf.startHourArr replaceObjectAtIndex:weakSelf.weekDay withObject:[NSString stringWithFormat:@"%ld", firstIndex]];
//
//                [weakSelf.endHourArr replaceObjectAtIndex:weakSelf.weekDay withObject:[NSString stringWithFormat:@"%ld", secondIndex]];
//
//            } else if(firstIndex == secondIndex) {
//
//                textLbl.text = [NSString stringWithFormat:@"关闭\n~\n关闭"];
//
//                [weakSelf.startHourArr replaceObjectAtIndex:weakSelf.weekDay withObject:[NSString stringWithFormat:@"24"]];
//
//                [weakSelf.endHourArr replaceObjectAtIndex:weakSelf.weekDay withObject:[NSString stringWithFormat:@"24"]];
//
//            }
        
//        };
        
        _hourPicker.firstTagNames = leftHours;
        _hourPicker.secondTagNames = rightHours;
        
    }
    
    return _hourPicker;
}

//- (void)data {
//    
//    self.weekLbl.text = @"星期一";
//    self.beginTimeLbl.text = @"00:00";
//    self.endTimeLbl.text   = @"11:59";
//
//}


@end
