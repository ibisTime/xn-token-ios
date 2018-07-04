//
//  SendRedEnvelopeView.m
//  Coin
//
//  Created by QinBao Zheng on 2018/7/2.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "SendRedEnvelopeView.h"
#import "AppColorMacro.h"
#import "TLUIHeader.h"
#import "CoinModel.h"
#import "CoinUtil.h"
#import "NSString+Extension.h"
#import "TLUser.h"
#import "TLNetworking.h"
#import "TLAlert.h"
#import "UIImageView+WebCache.h"

#import "NSString+Date.h"
#import "NSString+Check.h"

@implementation SendRedEnvelopeView
{
    UILabel *alltotalLabel;
    NSInteger index;
    BOOL isHaveDian;

    NSString *_currency;
    NSString *_type;
    NSString *_count;
    NSString *_sendNum;
    NSString *_greeting;

}

-(UIImageView *)headImage
{
    if (!_headImage) {
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - kHeight(70)/2, kHeight(133), kHeight(70), kHeight(70))];
        _headImage.image = kImage(@"圆 按钮");
    }
    return _headImage;
}

-(UIImageView *)HeadPortraitImage
{
    if (_HeadPortraitImage) {
        _HeadPortraitImage =[[UIImageView alloc]initWithFrame:CGRectMake(kHeight(3)  , kHeight(3), kHeight(64), kHeight(64))];
        kViewRadius(_HeadPortraitImage, kHeight(32));
        [_HeadPortraitImage sd_setImageWithURL:[NSURL URLWithString:[TLUser user].photo]];
    }
    return _HeadPortraitImage;
}

-(UILabel *)totalNumberLabel
{
    if (!_totalNumberLabel) {
        _totalNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth(35), kHeight(214), kWidth(kScreenWidth - 70), kHeight(33))];
        _totalNumberLabel.font = Font(14);
        _totalNumberLabel.textColor = [UIColor whiteColor];
        _totalNumberLabel.textAlignment = NSTextAlignmentCenter;

    }
    return _totalNumberLabel;
}

-(void)labelText:(NSString *)text
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:text];
    [attrStr addAttribute:NSFontAttributeName value:
     [UIFont systemFontOfSize:24.0f] range:NSMakeRange(3, text.length - 6)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:
     kTextColor7 range:NSMakeRange(3, text.length - 6)];
    _totalNumberLabel.attributedText = attrStr;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = @"1";

        UIImageView *backImage = [[UIImageView alloc]initWithFrame:self.frame];
        backImage.image = kImage(@"红包底部背景");
        [self addSubview:backImage];


        UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(20), kHeight(84), kWidth(335), kHeight(543))];
        backImg.image = kImage(@"红包背景");
        [self addSubview:backImg];
       
       
         
         

        [self addSubview:self.headImage];
        [self.headImage addSubview:self.HeadPortraitImage];
        
        UIImageView *imageView =[[UIImageView alloc] init];
        [imageView sd_setImageWithURL: [NSURL URLWithString: [[TLUser user].photo convertImageUrl]] placeholderImage:kImage(@"头像")];        imageView.layer.cornerRadius = 30;
        imageView.clipsToBounds = YES;
        [self.headImage addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.equalTo(@5);
            make.right.bottom.equalTo(@-5);

            
        }];

        [self addSubview:self.totalNumberLabel];


        NSArray *heightArray = @[@(kHeight(257)),@(kHeight(320)),@(kHeight(414)),@(kHeight(477))];
        NSArray *nameArray = @[[LangSwitcher switchLang:@"代币" key:nil],[LangSwitcher switchLang:@"代币总额" key:nil],[LangSwitcher switchLang:@"糖果个数" key:nil]];
        NSArray *symbolArrayl = @[[LangSwitcher switchLang:@"枚" key:nil],[LangSwitcher switchLang:@"个" key:nil]];

        for (int i = 0; i<4; i ++) {
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(kWidth(60),[heightArray[i] floatValue] , kWidth(255), kHeight(48))];
            backView.backgroundColor = [UIColor whiteColor];
            kViewRadius(backView, 5);
            [self addSubview:backView];


            if (i != 3) {
                UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(10, 0, 80, kHeight(48)) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:Font(14) textColor:kTextColor3];
                nameLabel.text = nameArray[i];
                [backView addSubview:nameLabel];

                UITextField *nameTF = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, kWidth(255) - 90 - 30, kHeight(48))];
                if (i == 0) {
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap)];
                    [nameTF addGestureRecognizer:tap];
                }
                nameTF.tag = 10000 + i;
                nameTF.textAlignment = NSTextAlignmentRight;
                nameTF.font = Font(14);
                nameTF.keyboardType = UIKeyboardTypeEmailAddress;
                nameTF.placeholder = [LangSwitcher switchLang:[LangSwitcher switchLang:@"请输入数量" key:nil] key:nil];
                nameTF.delegate = self;
                [nameTF setValue:Font(14)
                      forKeyPath:@"_placeholderLabel.font"];
                [nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                [backView addSubview:nameTF];

            }
            if (i == 0) {
                UIImageView *youImage = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(255) - 20, kHeight(48)/2 - 6.35, 7.4, 12.7)];
                youImage.image = kImage(@"more");
                [backView addSubview:youImage];



            }
            if (i == 1 || i == 2) {
                UILabel *symbolLabel = [UILabel labelWithFrame:CGRectMake(kWidth(255) - 25, kHeight(48)/2 - 6.35, 17.4, 12.7) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:Font(14) textColor:kTextColor3];
                symbolLabel.text = symbolArrayl[i - 1];
                [backView addSubview:symbolLabel];
            }
            if (i == 3) {
                UITextField *nameTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, kWidth(255) - 20, kHeight(48))];
                nameTF.font = Font(14);
                nameTF.tag = 10003;
                nameTF.placeholder = [LangSwitcher switchLang:@"糖包一响,黄金万两" key:nil];
                [nameTF setValue:Font(14) forKeyPath:@"_placeholderLabel.font"];
                [backView addSubview:nameTF];
            }

        }

        alltotalLabel = [UILabel labelWithFrame:CGRectMake(kWidth(60),kHeight(383) , kWidth(255) - 80, kHeight(26)) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:Font(11) textColor:kTextColor5];
        [self addSubview:alltotalLabel];


        UIButton *TheWalletButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"改为普通钱包" key:nil] titleColor:kTextColor5 backgroundColor:kClearColor titleFont:11];
        [TheWalletButton setTitle:[LangSwitcher switchLang:@"改为拼手气红包" key:nil] forState:(UIControlStateSelected)];
        TheWalletButton.frame = CGRectMake(kScreenWidth - kWidth(60) - 80, kHeight(378), 80, kHeight(26));
        [TheWalletButton addTarget:self action:@selector(ButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        TheWalletButton.tag = 101;
        kViewBorderRadius(TheWalletButton,0,0.5,kTextColor5);
        [self addSubview:TheWalletButton];

        UIButton *IntoButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"塞进糖包" key:nil] titleColor:kTextColor6 backgroundColor:SugarPacketsBack titleFont:16];
        kViewRadius(IntoButton, 5);
        IntoButton.frame = CGRectMake(kWidth(60), kHeight(550), kWidth(255), kHeight(48));
        IntoButton.tag = 102;
        [IntoButton addTarget:self action:@selector(ButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:IntoButton];


    }
    return self;
}



-(void)Tap
{

    if (_platforms.count > 0) {
        NSMutableArray *nameArray = [NSMutableArray array];
        for (int i = 0; i < _platforms.count; i ++) {
            CurrencyModel *platform = _platforms[i];
            [nameArray addObject:platform.currency];
        }

        CustomActionSheet * mySheet = [[CustomActionSheet alloc] initWithTitle:[LangSwitcher switchLang:@"请选择账户来源" key:nil] otherButtonTitles:nameArray];
        mySheet.delegate = self;
        [mySheet show];

    }
//    [_delegate SendRedEnvelopeButton:100];
}

#pragma mark - delegate
// 在代理方法中写你需要处理的点击事件逻辑即可
- (void)sheet:(CustomActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    CurrencyModel *platform = _platforms[buttonIndex];
    NSLog(@"%@",platform);
    [self Platform:platform];
}

-(void)ButtonClick:(UIButton *)sender
{
    if (sender.tag == 101) {
        sender.selected = !sender.selected;
        if (sender.selected == YES)
        {
            _type = @"0";
        }
        else
        {
            _type = @"1";
        }
        [self CalculateThePrice];
    }
    if (sender.tag == 102) {
        if (![TLUser user].isLogin) {
            return;
        }
        if ([_count isEqualToString:@""]) {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入代币数量" key:nil]];
            return;
        }
        if ([_sendNum isEqualToString:@""]) {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入糖果个数" key:nil]];
            return;

        }
        UITextField *textField3 = [self viewWithTag:10003];
        if ([textField3.text isEqualToString:@""]) {
            _greeting = @"糖包一响,黄金万两";
        }else
        {
            _greeting = textField3.text;
        }
        [_delegate SendRedEnvelopeButton:102 currency:_currency type:_type count:_count sendNum:_sendNum greeting:_greeting];

    }
}



-(void)setPlatforms:(NSMutableArray<CurrencyModel *> *)platforms
{
    _platforms = platforms;
    CurrencyModel *platform = platforms[index];
    NSLog(@"%@",platform);
    [self Platform:platform];

}

-(void)Platform:(CurrencyModel *)platform
{

    UITextField *textField2 = [self viewWithTag:10001];
    UITextField *textField3 = [self viewWithTag:10002];
    _count = @"";
    _sendNum = @"";
    textField2.text = @"";
    textField3.text = @"";

    UITextField *textField1 = [self viewWithTag:10000];
    textField1.text = platform.currency;
    _currency = platform.currency;
    CoinModel *coin = [CoinUtil getCoinModel:platform.currency];

    NSString *leftAmount = [CoinUtil convertToRealCoin:platform.amountString coin:coin.symbol];
    NSString *rightAmount = [CoinUtil convertToRealCoin:platform.frozenAmountString coin:coin.symbol];
    NSString *ritAmount = [leftAmount subNumber:rightAmount];
    alltotalLabel.text = [NSString stringWithFormat:@"持有%@总量:%.3f",platform.currency,[ritAmount floatValue]];


    NSString *str = [NSString stringWithFormat:@"共发送 0.000 %@",_currency];
    [self labelText:str];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 1000) {
        return NO;
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSLog(@"-%@-%@",textField.text,string);
    if (textField.tag == 10001 || textField.tag == 10002) {
        if ([textField.text rangeOfString:@"."].location == NSNotFound) {
            isHaveDian = NO;
        }
        if ([string length] > 0) {
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
                //首字母不能为0和小数点
                if([textField.text length] == 0){
                    if(single == '.') {
                        //                    [self showError:@"亲，第一个数字不能为小数点"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                    //                if (single == '0') {
                    //                    //                    [self showError:@"亲，第一个数字不能为0"];
                    //                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    //                    return NO;
                    //                }
                }
                //输入的字符是否是小数点
                if (single == '.') {
                    if(!isHaveDian)//text中还没有小数点
                    {
                        isHaveDian = YES;
                        return YES;

                    }else{
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }else{
                    if (isHaveDian) {//存在小数点

                        //判断小数点的位数
                        NSRange ran = [textField.text rangeOfString:@"."];
                        if (range.location - ran.location <= 3) {
                            return YES;
                        }else{
                            return NO;
                        }
                    }else{
                        return YES;
                    }
                }
            }else{//输入的数据格式不正确
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }else
        {
            return YES;
        }
    }
    else
    {
        return YES;
    }
}


- (void)textFieldDidChange:(UITextField *)textField{
    if (textField.tag == 10001) {
        _count = textField.text;
    }
    if (textField.tag == 10002) {
        _sendNum = textField.text;

    }

    NSLog(@"%@==%@",_count,_sendNum);
    [self CalculateThePrice];

}

-(void)CalculateThePrice
{
    if ([_type isEqualToString:@"0"]) {
        if (![_count isEqualToString:@""] && ![_sendNum isEqualToString:@""]) {
            NSString *str = [NSString stringWithFormat:@"共发送 %.3f %@",[_count floatValue]*[_sendNum floatValue],_currency];
            [self labelText:str];
        }
    }else
    {
        NSString *str = [NSString stringWithFormat:@"共发送 %.3f %@",[_count floatValue],_currency];
        [self labelText:str];
    }
}

@end
