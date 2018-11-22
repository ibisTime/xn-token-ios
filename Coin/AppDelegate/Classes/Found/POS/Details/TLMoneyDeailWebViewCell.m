//
//  TLMoneyDeailWebViewCell.m
//  Coin
//
//  Created by QinBao Zheng on 2018/10/16.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLMoneyDeailWebViewCell.h"

@implementation TLMoneyDeailWebViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        
        self.web.scrollView.bounces=NO;
        self.web.scrollView.showsHorizontalScrollIndicator = NO;
        self.web.scrollView.scrollEnabled = NO;
        self.web.backgroundColor = kWhiteColor;
        self.web.dataDetectorTypes=UIDataDetectorTypeNone;
        
        [self addSubview:self.web];
    }
    return self;
}

@end
