//
//  BackupCollectionViewCell.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/19.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "BackupCollectionViewCell.h"

@implementation BackupCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [UILabel labelWithFrame:CGRectMake(0 , 0, (SCREEN_WIDTH - 70)/3, 135/4)textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(14) textColor:kWhiteColor];
        kViewBorderRadius(self.label, 5, 1, kWhiteColor);
        [self addSubview:self.label];
    }
    return self;
}

@end
