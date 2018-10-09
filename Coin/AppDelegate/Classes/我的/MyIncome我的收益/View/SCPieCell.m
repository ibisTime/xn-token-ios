//
//  SCPieCell.m
//  SCChart
//
//  Created by 2014-763 on 15/3/24.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "SCPieCell.h"
#import "SCChart.h"

@interface SCPieCell()
{
    SCPieChart *chartView;
}
@end

@implementation SCPieCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        if (chartView) {
            [chartView removeFromSuperview];
            chartView = nil;
        }
        NSArray *items = @[
                           [SCPieChartDataItem dataItemWithValue:75 color:RGB(255, 198, 83) description:@""],
                           [SCPieChartDataItem dataItemWithValue:25 color:RGB(255, 91, 67) description:@""],
                           ];

        chartView = [[SCPieChart alloc] initWithFrame:CGRectMake(33, 32, 185, 185) items:items];
        chartView.descriptionTextColor = [UIColor whiteColor];
        chartView.descriptionTextFont  = FONT(0);
        [chartView strokeChart];
        [self addSubview:chartView];



        UILabel *priceLabel = [UILabel labelWithFrame:CGRectMake(33 + 30, 32 + 180/2 - 31, 120, 44) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(32) textColor:kHexColor(@"#333333")];
        priceLabel.text = @"0.9015";
        [self addSubview:priceLabel];

        UILabel *coinLabel = [UILabel labelWithFrame:CGRectMake(33 + 30, 32 + 180/2 - 31 + 44, 120, 18) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#999999")];
        coinLabel.text = @"BTC";
        [self addSubview:coinLabel];


        NSArray *colorArray = @[RGB(255, 198, 83),RGB(255, 91, 67),RGB(59, 170, 174),RGB(0, 108, 109)];
        NSArray *nameArray = @[@"量化收益",@"邀请收益"];
        NSArray *detailsArray = @[@"75%  详情",@"25%  详情"];
        for (int i = 0; i < 2; i ++) {
            UIView *pointView = [[UIView alloc]initWithFrame:CGRectMake(chartView.xx + 33, 32 + 45 + i % 4 * 65, 8, 8)];
            pointView.backgroundColor = colorArray[i];
            kViewRadius(pointView, 4);
            [self addSubview:pointView];

            UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(chartView.xx + 33 + 16, 26 + 45 + i % 4 * 65, SCREEN_WIDTH - (chartView.xx + 33 + 16) - 8, 20) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:HGboldfont(14) textColor:kHexColor(@"#333333")];
            nameLabel.text = [LangSwitcher switchLang:nameArray[i] key:nil];
            [self addSubview:nameLabel];


            UIButton *detailsBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:detailsArray[i] key:nil] titleColor:kHexColor(@"#666666") backgroundColor:kClearColor titleFont:13];
            detailsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

            detailsBtn.frame = CGRectMake(chartView.xx + 33 + 16, 46 + 45 + i % 4 * 65, SCREEN_WIDTH - (chartView.xx + 33 + 16) - 8, 18);
            if (i == 0) {
                self.quantitativeButton = detailsBtn;
            }else
            {
                self.invitationButton = detailsBtn;
            }
            [detailsBtn SG_imagePositionStyle:(SGImagePositionStyleRight) spacing:5 imagePositionBlock:^(UIButton *button) {
                [button setImage:kImage(@"更多拷贝") forState:(UIControlStateNormal)];
            }];
            [self addSubview:detailsBtn];
        }



    }
    return self;
}



@end
