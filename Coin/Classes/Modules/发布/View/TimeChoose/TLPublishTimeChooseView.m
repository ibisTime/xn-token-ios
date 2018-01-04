//
//  TLPublishTimeChooseView.m
//  Coin
//
//  Created by  tianlei on 2018/1/03.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TLPublishTimeChooseView.h"
#import "TLSingleTimeView.h"

@interface TLPublishTimeChooseView()

@property (nonatomic, strong)  NSMutableArray <TLSingleTimeView *> *timeViews;

@end

@implementation TLPublishTimeChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        int count = 7;
        self.timeViews = [[NSMutableArray alloc] initWithCapacity:count];
        CGFloat singleW = frame.size.width/count;
        CGFloat height = frame.size.height;
        
        // 周1 到 日
        for (int i = 0; i < 7; i ++) {
            
            TLSingleTimeView *timeView = [[TLSingleTimeView alloc] initWithFrame:CGRectMake(i*singleW, 0, singleW, height)];
            timeView.weekLbl.text = [self getWeek:i+1];
            [self addSubview:timeView];
            timeView.beginTimeLbl.text = @"00:00";
            timeView.endTimeLbl.text   = @"11:59";
            
        }
        
    }
    return self;
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
