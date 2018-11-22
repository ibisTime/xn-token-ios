//
//  PosBuyIntroduceCell.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "PosBuyIntroduceCell.h"

@implementation PosBuyIntroduceCell
{
    NSDictionary *dic;
    TLtakeMoneyModel *model;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 28, 10, 6 )];
        lineView.backgroundColor = kHexColor(@"#0064FF");
        [self addSubview:lineView];

        UILabel *titleLbl = [UILabel labelWithFrame:CGRectMake(25, 20, kScreenWidth - 40, 21) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:HGboldfont(15) textColor:kHexColor(@"#464646")];
        self.titleLbl = titleLbl;
        titleLbl.text = @"";
        [self addSubview:titleLbl];

        NSArray *nameArray = @[@"剩余额度：",@"预期年化收益："];
        for (int i = 0; i < 2; i ++) {
            UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(25,  i % 2 * 25 + 51, kScreenWidth - 40, 20) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:Font(13) textColor:kHexColor(@"#464646")];
            nameLabel.text = nameArray[i];
            [self addSubview:nameLabel];
            nameLabel.tag = 123 + i;
        }


        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 128, 10, 6 )];
        lineView1.backgroundColor = kHexColor(@"#0064FF");
        [self addSubview:lineView1];

        UILabel *titleLbl1 = [UILabel labelWithFrame:CGRectMake(25, 121, kScreenWidth - 40, 21) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:HGboldfont(15) textColor:kHexColor(@"#464646")];
        titleLbl1.text = [LangSwitcher switchLang:@"购买份额" key:nil];
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

//        UILabel *numberLabel = [UILabel labelWithFrame:CGRectMake(90, 155, kScreenWidth - 180, 55) textAligment:(NSTextAlignmentCenter) backgroundColor:[UIColor whiteColor] font:Font(30) textColor:kHexColor(@"#464646")];
//        self.numberLabel = numberLabel;
////        numberLabel.text= @"0";
//        self.numberLabel.tag = 1212;
//        kViewBorderRadius(numberLabel, 0, 1, kLineColor);
//        [self addSubview:numberLabel];

        UITextField *numberTextField = [[UITextField alloc]initWithFrame:CGRectMake(90, 155, kScreenWidth - 180, 55)];
        numberTextField.textAlignment = NSTextAlignmentCenter;
        numberTextField.textColor = kHexColor(@"#464646");
        numberTextField.font = FONT(30);
        numberTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.numberTextField = numberTextField;
        self.numberTextField.tag = 1212;
        numberTextField.delegate = self;
        kViewBorderRadius(numberTextField, 0, 1, kLineColor);
        [self addSubview:numberTextField];


        UILabel *priceLabel = [UILabel labelWithFrame:CGRectMake(0, 220, kScreenWidth, 18) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:Font(14) textColor:kHexColor(@"#999999")];
        priceLabel.text =@"（0.0ETH）";
        self.priceLabel = priceLabel;
        priceLabel.tag = 456;
        [self addSubview:priceLabel];


//        起
        UILabel *sinceLabel = [UILabel labelWithFrame:CGRectMake(35, 261, 0, 14) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:Font(14) textColor:kHexColor(@"#464646")];
        self.sinceLabel = sinceLabel;
        [self addSubview:sinceLabel];

//        终
        UILabel *finalLabel = [UILabel labelWithFrame:CGRectMake(35, 261, 0, 14) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:Font(14) textColor:kHexColor(@"#464646")];
        self.finalLabel = finalLabel;
        [self addSubview:finalLabel];
        finalLabel.frame = CGRectMake(kScreenWidth - 35 - finalLabel.frame.size.width, 261, finalLabel.frame.size.width, 14);


        UISlider *mySlider = [[UISlider alloc] initWithFrame:(CGRect){ sinceLabel.xx + 10 , 258 ,kScreenWidth  - finalLabel.frame.size.width - 35 - sinceLabel.xx - 20,26}];
        self.mySlider = mySlider;
        mySlider.tag = 12345;


        mySlider.value = 1;
        //最小边界值
        mySlider.minimumValue = 1;
        //最大边界值
        mySlider.maximumValue = 10;
        //这个值是介于滑块的最大值和最小值之间的，如果没有设置边界值，默认为0-1
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
    model = moneyModel;
    switch ([LangSwitcher currentLangType]) {
        case LangTypeEnglish:
            self.titleLbl.text = moneyModel.nameEn;

            break;
        case LangTypeKorean:
            self.titleLbl.text = moneyModel.nameKo;

            break;
        case LangTypeSimple:
            self.titleLbl.text = moneyModel.nameZhCn;

            break;

        default:
            break;
    }

    NSString *avilAmount = [CoinUtil convertToRealCoin:moneyModel.avilAmount coin:moneyModel.symbol];
    NSString *increAmount = [CoinUtil convertToRealCoin:moneyModel.increAmount coin:moneyModel.symbol];

    UILabel *label1 = [self viewWithTag:123];
    label1.text = [NSString stringWithFormat:@"%@：%.0f%@",[LangSwitcher switchLang:@"剩余额度" key:nil],[avilAmount floatValue]/[increAmount floatValue],[LangSwitcher switchLang:@"份" key:nil]];
    UILabel *label2 = [self viewWithTag:124];
    label2.text = [NSString stringWithFormat:@"%@：%.2f%%",[LangSwitcher switchLang:@"预期年化收益" key:nil],[moneyModel.expectYield floatValue]*100];

//    递增金额
    self.priceLabel.text = [NSString stringWithFormat:@"(%.2f%@)",[increAmount floatValue],moneyModel.symbol];

}

-(void)setDataDic:(NSDictionary *)dataDic
{
    dic = dataDic;
    self.mySlider.value = [dataDic[@"min"] floatValue];
    //最小边界值
    self.mySlider.minimumValue = [dataDic[@"min"] floatValue];
    self.mySlider.maximumValue = [dataDic[@"max"] floatValue];
    //    份额
    self.sinceLabel.text = [NSString stringWithFormat:@"%ld%@",[dataDic[@"min"]  integerValue],[LangSwitcher switchLang:@"份" key:nil]];
    self.finalLabel.text = [NSString stringWithFormat:@"%ld%@",[dataDic[@"max"]  integerValue],[LangSwitcher switchLang:@"份" key:nil]];
    self.numberTextField.text = [NSString stringWithFormat:@"%ld",[dataDic[@"min"]  integerValue]];

    [self.sinceLabel sizeToFit];
    self.finalLabel.frame = CGRectMake(35, 261, 0, 14);
    [self.finalLabel sizeToFit];
    self.finalLabel.frame = CGRectMake(kScreenWidth - 35 - self.finalLabel.frame.size.width, 261, self.finalLabel.frame.size.width, 14);
    self.mySlider.frame = CGRectMake(self.sinceLabel.xx + 10 , 258 ,kScreenWidth  - self.finalLabel.frame.size.width - 35 - self.sinceLabel.xx - 20,26);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //    限制只能输入数字
    BOOL isHaveDian = YES;
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {

        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确

            if([textField.text length] == 0){
                if(single == '.') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            //输入的字符是否是小数点
            if (single == '.') {
                return NO;

            }
            NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
            NSLog(@"00000  %@",toBeString);
            if ([toBeString integerValue] > [dic[@"max"]  integerValue]) {
                return NO;
            }else
            {
                return YES;
            }
        }else{//输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text floatValue] == 0) {
        self.numberTextField.text = [NSString stringWithFormat:@"%ld",[dic[@"min"]  integerValue]];
        NSString *increAmount = [CoinUtil convertToRealCoin:model.increAmount coin:model.symbol];
        self.priceLabel.text = [NSString stringWithFormat:@"(%.2f%@)",[increAmount floatValue],model.symbol];
    }
}

@end
