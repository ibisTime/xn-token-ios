//
//  PosBuyIntroduceCell.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "PosBuyIntroduceCell.h"

@implementation PosBuyIntroduceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 28, 10, 6 )];
        lineView.backgroundColor = kHexColor(@"#0064FF");
        [self addSubview:lineView];

        UILabel *titleLbl = [UILabel labelWithFrame:CGRectMake(25, 20, kScreenWidth - 40, 21) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:HGboldfont(15) textColor:kHexColor(@"#464646")];
        self.titleLbl = titleLbl;
        titleLbl.text = @"蓝潮基金ETH增长型7期";
        [self addSubview:titleLbl];

        NSArray *nameArray = @[@"剩余额度：9999 份",@"预期年化收益：12%"];
        for (int i = 0; i < 2; i ++) {
            UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(25,  i % 2 * 25 + 51, kScreenWidth - 40, 20) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:Font(13) textColor:kHexColor(@"#464646")];
            nameLabel.text = nameArray[i];
            [self addSubview:nameLabel];
        }


        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 128, 10, 6 )];
        lineView1.backgroundColor = kHexColor(@"#0064FF");
        [self addSubview:lineView1];

        UILabel *titleLbl1 = [UILabel labelWithFrame:CGRectMake(25, 121, kScreenWidth - 40, 21) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:HGboldfont(15) textColor:kHexColor(@"#464646")];
        titleLbl1.text = @"购买份额";
        [self addSubview:titleLbl1];

        UIButton *reductionBtn = [UIButton buttonWithTitle:@"-" titleColor:kHexColor(@"#464646") backgroundColor:kHexColor(@"#F9F9FC") titleFont:30];
        reductionBtn.frame = CGRectMake(35, 155, 55, 55);
        kViewBorderRadius(reductionBtn, 0, 1, kLineColor);
        [reductionBtn addTarget:self action:@selector(reductionBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        reductionBtn.tag = 500;
        [self addSubview:reductionBtn];

        UIButton *addBtn = [UIButton buttonWithTitle:@"+" titleColor:kHexColor(@"#464646") backgroundColor:kHexColor(@"#F9F9FC") titleFont:30];
        addBtn.frame = CGRectMake(kScreenWidth - 90, 155, 55, 55);
        kViewBorderRadius(addBtn, 0, 1, kLineColor);
        [addBtn addTarget:self action:@selector(reductionBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        addBtn.tag = 501;
        [self addSubview:addBtn];

        UILabel *numberLabel = [UILabel labelWithFrame:CGRectMake(90, 155, kScreenWidth - 180, 55) textAligment:(NSTextAlignmentCenter) backgroundColor:[UIColor whiteColor] font:Font(30) textColor:kHexColor(@"#464646")];
        self.numberLabel = numberLabel;
        numberLabel.text= @"1";
        self.numberLabel.tag = 1212;
        kViewBorderRadius(numberLabel, 0, 1, kLineColor);
        [self addSubview:numberLabel];


        UILabel *priceLabel = [UILabel labelWithFrame:CGRectMake(0, 220, kScreenWidth, 18) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:Font(14) textColor:kHexColor(@"#999999")];
        priceLabel.text =@"（2.3ETH）";
        [self addSubview:priceLabel];


//        起
        UILabel *sinceLabel = [UILabel labelWithFrame:CGRectMake(35, 261, 0, 14) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:Font(14) textColor:kHexColor(@"#464646")];
        sinceLabel.text = @"1份";
        [sinceLabel sizeToFit];
        [self addSubview:sinceLabel];

//        终
        UILabel *finalLabel = [UILabel labelWithFrame:CGRectMake(35, 261, 0, 14) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:Font(14) textColor:kHexColor(@"#464646")];
        finalLabel.text = @"9999份";
        [finalLabel sizeToFit];
        [self addSubview:finalLabel];
        finalLabel.frame = CGRectMake(kScreenWidth - 35 - finalLabel.frame.size.width, 261, finalLabel.frame.size.width, 14);


        UISlider *mySlider = [[UISlider alloc] initWithFrame:(CGRect){ sinceLabel.xx + 10 , 258 ,kScreenWidth  - finalLabel.frame.size.width - 35 - sinceLabel.xx - 20,26}];
        self.mySlider = mySlider;

//        [mySlider setThumbImage:kImage(@"拖拽icon") forState:UIControlStateNormal];

        //最小边界值
        mySlider.minimumValue = 1;
        //最大边界值
        mySlider.maximumValue = 9999;
        //这个值是介于滑块的最大值和最小值之间的，如果没有设置边界值，默认为0-1
        mySlider.value = 1;
        //设置滑块值是否连续变化(默认为YES)
        mySlider.continuous= YES;
        //设置滑块左边（小于部分）线条的颜色
        mySlider.minimumTrackTintColor = [UIColor colorWithHexString:@"#0064FF"];
        //设置滑块右边（大于部分）线条的颜色
        mySlider.maximumTrackTintColor = [UIColor colorWithHexString:@"#D4E4F3"];
        //设置滑块颜色（影响已划过一端的颜色）
        mySlider.thumbTintColor = [UIColor colorWithHexString:@"#0064FF"];
        //加入视图
        [self addSubview:mySlider];
        //添加点击事件
        [mySlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];

    }
    return self;
}

-(void)sliderAction:(UISlider *)mySlider
{
//    self.numberLabel.text = [NSString stringWithFormat:@"%.0f", mySlider.value];
    [_delegate sliderActionUISlider:mySlider];
}

-(void)reductionBtnClick:(UIButton *)sender
{
    [_delegate addAndreductionButton:sender];
}

-(void)setMoneyModel:(TLtakeMoneyModel *)moneyModel
{
    self.titleLbl.text = moneyModel.name;
    
}

@end
