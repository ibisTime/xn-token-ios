//
//  TLPublishTimeChooseView.m
//  Coin
//
//  Created by  tianlei on 2018/1/03.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TLPublishTimeChooseView.h"
#import "TLSingleTimeView.h"
#import "TLUIHeader.h"

@interface TLPublishTimeChooseView()

@property (nonatomic, strong)  NSMutableArray <TLSingleTimeView *> *timeViews;

@end

@implementation TLPublishTimeChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        
        int count = 7;
        self.timeViews = [[NSMutableArray alloc] initWithCapacity:count];
        CGFloat singleW = frame.size.width/count;
        CGFloat height = frame.size.height;
        
        // 周1 到 日
        for (int i = 0; i < 7; i ++) {
            
            TLSingleTimeView *timeView = [[TLSingleTimeView alloc] initWithFrame:CGRectMake(i*singleW, 0, singleW, height)];
//            timeView.backgroundColor = [UIColor orangeColor];
            timeView.weekLbl.text = [self getWeek:i+1];
            [self addSubview:timeView];
            [self.timeViews addObject:timeView];
            Displaytime *displaytime = [Displaytime defaultTime];
            displaytime.week = [NSString stringWithFormat:@"%d",i + 1];
            timeView.displayTime = displaytime;
            
        }
        
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(0.7);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    return self;
}

- (NSArray <NSDictionary *> *)obtainTimes {
    
    NSMutableArray *arrays = [[NSMutableArray alloc] init];
    
    [self.timeViews enumerateObjectsUsingBlock:^(TLSingleTimeView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [arrays addObject:[obj.displayTime toDict]];
        
    }];
    
    return arrays;
    
}


- (NSString *)getWeek:(int)c {
    
    static NSDictionary *dict = nil;
    
    dict = @{
             @"1" : @"一",
             @"2" : @"二",
             @"3" : @"三",
             @"4" : @"四",
             @"5" : @"五",
             @"6" : @"六",
             @"7" : @"日"
             
             };
    
    NSString *str = [NSString stringWithFormat:@"%d",c];
    return [NSString stringWithFormat:@"星期%@",dict[str]];
    
}
@end
