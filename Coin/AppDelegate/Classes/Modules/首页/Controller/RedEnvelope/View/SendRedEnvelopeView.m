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
#import "CurrencyModel.h"
#import "RechargeCoinVC.h"

#define ALLPRICE 1000000

@implementation SendRedEnvelopeView
{
    UILabel *alltotalLabel;
    UILabel *transFormLab;

    NSInteger index;
    BOOL isHaveDian;

    NSString *_currency;
    NSString *_type;
    NSString *_count;
    NSString *_sendNum;
    NSString *_greeting;
    NSString *allPrice;
    UILabel *introduce;
    CurrencyModel *plat;
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
    if ([LangSwitcher currentLangType] == LangTypeEnglish) {
        [attrStr addAttribute:NSFontAttributeName value:
         [UIFont systemFontOfSize:24.0f] range:NSMakeRange(12, text.length - 15)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:
         kTextColor7 range:NSMakeRange(12, text.length - 15)];
    }else{
        [attrStr addAttribute:NSFontAttributeName value:
         [UIFont systemFontOfSize:24.0f] range:NSMakeRange(3, text.length - 6)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:
         kTextColor7 range:NSMakeRange(3, text.length - 6)];
        
    }
   
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


        UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(20), kHeight(84), kWidth(325), kHeight(543))];
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

//        [self addSubview:self.totalNumberLabel];


        NSArray *heightArray = @[@(kHeight(257)),@(kHeight(330)),@(kHeight(414)),@(kHeight(477))];
        NSArray *nameArray = @[[LangSwitcher switchLang:@"代币类型" key:nil],[LangSwitcher switchLang:@"代币总额" key:nil],[LangSwitcher switchLang:@"红包个数" key:nil]];
        NSArray *symbolArrayl = @[[LangSwitcher switchLang:@"枚" key:nil],[LangSwitcher switchLang:@"个" key:nil]];

        for (int i = 0; i<4; i ++) {
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(kWidth(60),[heightArray[i] floatValue] , kWidth(255), kHeight(48))];
            backView.backgroundColor = [UIColor whiteColor];
            kViewRadius(backView, 5);
            [self addSubview:backView];


            if (i != 3) {
                UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(10, 0, 120, kHeight(48)) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:Font(14) textColor:kTextColor3];
                nameLabel.text = nameArray[i];
                [backView addSubview:nameLabel];
                if (i == 1) {
                    self.total = nameLabel;
                }
                
                UITextField *nameTF = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, kWidth(255) - 90 - 30, kHeight(48))];
                if (i == 0) {
//                    nameTF.enabled = NO;
                  UILabel *  name = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, kWidth(255) - 90 - 30, kHeight(48))];
//                    nameTF = name;
                    
//                    [nameTF resignFirstResponder];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap)];
                    [nameTF addGestureRecognizer:tap];
                }
                nameTF.tag = 10000 + i;
                if (i == 0) {
                    nameTF.textAlignment = NSTextAlignmentRight;

                }else{
                    
                    nameTF.textAlignment = NSTextAlignmentCenter;

                }
                nameTF.font = Font(14);
                nameTF.keyboardType = UIKeyboardTypeEmailAddress;
                nameTF.placeholder = [LangSwitcher switchLang:[LangSwitcher switchLang:@"请输入数量" key:nil] key:nil];
                nameTF.delegate = self;
                [nameTF setValue:Font(14)
                      forKeyPath:@"_placeholderLabel.font"];
                [nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                [backView addSubview:nameTF];
                if (i == 2) {
                    nameTF.keyboardType = UIKeyboardTypePhonePad;
                }

            }
            if (i == 0) {
                UIImageView *youImage = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(255) - 20, kHeight(48)/2 - 6.35, 7.4, 12.7)];
                youImage.image = kImage(@"more");
                [backView addSubview:youImage];



            }
            if (i == 1 || i == 2) {
                UILabel *symbolLabel = [UILabel labelWithFrame:CGRectMake(kWidth(255) - 55, kHeight(48)/2 - 6.35, 47.4, 12.7) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:Font(12) textColor:kTextColor3];
                symbolLabel.text = symbolArrayl[i - 1];
                if (i == 2) {
                    
                }
                [backView addSubview:symbolLabel];
            }
            if (i == 3) {
                UITextField *nameTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, kWidth(255) - 20, kHeight(48))];
                nameTF.font = Font(14);
                nameTF.tag = 10003;
                nameTF.placeholder = [LangSwitcher switchLang:@"红包一响,黄金万两" key:nil];
                [nameTF setValue:Font(14) forKeyPath:@"_placeholderLabel.font"];
                [backView addSubview:nameTF];
            }

        }

        alltotalLabel = [UILabel labelWithFrame:CGRectMake(kWidth(60),kHeight(284+25) , kWidth(92+50), kHeight(16)) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:Font(11) textColor:kTextColor5];
        [self addSubview:alltotalLabel];
        
        transFormLab = [UILabel labelWithFrame:CGRectMake(alltotalLabel.xx+10,kHeight(284+25) , kWidth(92), kHeight(16)) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:Font(11) textColor:kHexColor(@"#FBDDA9")];
        transFormLab.userInteractionEnabled = YES;
        [self addSubview:transFormLab];
        
        transFormLab.text = [LangSwitcher switchLang:@"转入资金" key:nil];
        UIView *lineView = [UIView new];
        lineView.backgroundColor = kHexColor(@"#FBDDA9");
        [transFormLab addSubview:lineView];
        UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(transformMoney)];
        [transFormLab addGestureRecognizer:ta];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(transFormLab.mas_bottom).offset(-2);
            make.left.equalTo(transFormLab.mas_left).offset(0);
            make.height.equalTo(@0.5);
            make.width.equalTo(@50);

        }];
        introduce = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:11];
        
        introduce.text = [LangSwitcher switchLang:@"当前为拼手气红包" key:nil];
        introduce.layer.borderWidth = 0.5;
        introduce.layer.borderColor = kHexColor(@"#FBDDA9").CGColor;
        introduce.frame = CGRectMake(kWidth(60), kHeight(388), kWidth(84), kHeight(16));
        [self addSubview:introduce];

        UIButton *TheWalletButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"改为普通红包" key:nil] titleColor:kTextColor5 backgroundColor:kClearColor titleFont:11];
        [TheWalletButton setTitle:[LangSwitcher switchLang:@"改为拼手气红包" key:nil] forState:(UIControlStateSelected)];
        TheWalletButton.frame = CGRectMake(kScreenWidth - kWidth(60)-kWidth(84), kHeight(382), kWidth(84), kHeight(26));
        [TheWalletButton addTarget:self action:@selector(ButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        TheWalletButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [TheWalletButton.titleLabel sizeToFit];
//        TheWalletButton.titleLabel.numberOfLines = 0;
        TheWalletButton.tag = 101;
        kViewBorderRadius(TheWalletButton,0,0.5,kTextColor5);
        [self addSubview:TheWalletButton];

        UIButton *IntoButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"塞进红包" key:nil] titleColor:kTextColor6 backgroundColor:SugarPacketsBack titleFont:16];
        kViewRadius(IntoButton, 5);
        IntoButton.frame = CGRectMake(kWidth(60), kHeight(540), kWidth(255), kHeight(48));
        IntoButton.tag = 102;
        [IntoButton addTarget:self action:@selector(ButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:IntoButton];
       
        UILabel *redIntroduce = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:11];
        redIntroduce.text = [LangSwitcher switchLang:@"红包规则" key:nil];
        redIntroduce.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerClick)];
        [redIntroduce addGestureRecognizer:tap1];
        [self addSubview:redIntroduce];
        [redIntroduce mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(IntoButton.mas_bottom).offset(10);
            make.centerX.equalTo(self.mas_centerX);
            
        }];
        UIImageView *imageV  = [[UIImageView alloc] init];
        imageV.backgroundColor = kClearColor;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerClick)];
        [imageV addGestureRecognizer:tap];
        imageV.userInteractionEnabled = YES;
        [self addSubview:imageV];
        imageV.image = kImage(@"红包规则问号");
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(IntoButton.mas_bottom).offset(10);
            make.left.equalTo(redIntroduce.mas_right).offset(3);
            make.width.height.equalTo(@14);
            
        }];

    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self endEditing:YES];
}

- (void)centerClick
{
    if (self.redPackBlock) {
        self.redPackBlock();
    }
    
   
    
}

- (void)transformMoney
{
    RechargeCoinVC *coinVC = [RechargeCoinVC new];

    coinVC.currency = plat;
    
    if (self.transFormBlock) {
        self.transFormBlock(plat);
    }
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
            introduce.text = [LangSwitcher switchLang:@"当前为普通红包" key:nil];

            self.total.text = [LangSwitcher switchLang:@"单个数量" key:nil];
            _type = @"0";
        }
        else
        {
            self.total.text = [LangSwitcher switchLang:@"代币总额" key:nil];
            introduce.text = [LangSwitcher switchLang:@"当前为拼手气红包" key:nil];
            _type = @"1";
        }
        [self CalculateThePrice];
    }
    if (sender.tag == 102) {
        if (![TLUser user].isLogin) {
            return;
        }
        if ([_count isEqualToString:@""] || !_count) {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入代币数量" key:nil]];
            return;
        }
      if([_count floatValue] <0.001)
        {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"总金额最少为0.001" key:nil]];

            return;
        }
        
        if ([_sendNum isEqualToString:@""] || !_sendNum) {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入红包个数" key:nil]];
            return;

        }
        if ([allPrice floatValue] > ALLPRICE) {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"不得大于一百万" key:nil]];
            return;
        }

        UITextField *textField3 = [self viewWithTag:10003];
        if ([textField3.text isEqualToString:@""] || !textField3.text ) {
            _greeting = [LangSwitcher switchLang:@"红包一响,黄金万两" key:nil];
        }else
        {
            _greeting = textField3.text;
        }
     //付款
        [self payAmount];
        
        
       

    }
    
}

- (void)payAmount
{
    [self endEditing:YES];
    UIView * view1 = [UIView new];
    self.view1 = view1;
    self.view1.hidden = NO;

    view1.frame =CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    view1.backgroundColor =
    view1.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.45];
    
//    view.alpha = 0.5;
    [self addSubview:view1];
    UIView *whiteView = [UIView new];
    
    [view1 addSubview:whiteView];
    
    whiteView.frame = CGRectMake(24, kHeight(194), kScreenWidth - 48, kHeight(300));
    
    whiteView.backgroundColor = kWhiteColor;
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn setBackgroundImage:kImage(@"红包 删除") forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.mas_top).offset(10);
        make.right.equalTo(whiteView.mas_right).offset(-15);
        make.width.height.equalTo(@22.5);
    }];
    
    UILabel *sureLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:20];
    sureLab.text = [LangSwitcher switchLang:@"立即付款" key:nil];
    [whiteView addSubview:sureLab];
    [sureLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.mas_top).offset(50);
        make.centerX.equalTo(whiteView.mas_centerX);
    }];
    UILabel *money = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#A75E02") font:17];
    CoinModel *coin = [CoinUtil getCoinModel:plat.currency];
    
    NSString *leftAmount = [CoinUtil convertToRealCoin:plat.amountString coin:coin.symbol];
    NSString *rightAmount = [CoinUtil convertToRealCoin:plat.frozenAmountString coin:coin.symbol];
    NSString *ritAmount = [leftAmount subNumber:rightAmount];
    if ([_type isEqualToString:@"0"]) {
        money.text = [NSString stringWithFormat:@"%f%@",[_count floatValue]*[_sendNum floatValue],plat.currency];

    }else{
        money.text = [NSString stringWithFormat:@"%@%@",_count,plat.currency];

    }
    [whiteView addSubview:money];
    [money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sureLab.mas_bottom).offset(16);
        make.centerX.equalTo(whiteView.mas_centerX);
    }];
    
    UIView *buttonView =[UIView new];
    buttonView.backgroundColor = kWhiteColor;
    buttonView.layer.borderWidth = 0.5;
    buttonView.layer.borderColor = kLineColor.CGColor;
//    buttonView.layer.cornerRadius = 5.0;
//    buttonView.clipsToBounds = YES;
    [whiteView addSubview:buttonView];
    
    [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(money.mas_bottom).offset(16);
        make.left.equalTo(whiteView.mas_left).offset(25);
        make.right.equalTo(whiteView.mas_right).offset(-25);
        make.height.equalTo(@48);
    }];
    
    UILabel *blanceMoney = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:15];
    blanceMoney.text = [LangSwitcher switchLang:@"账户余额" key:nil];
    [buttonView addSubview:blanceMoney];
    [blanceMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonView.mas_top).offset(13);
        make.left.equalTo(buttonView.mas_left).offset(10);
        
    }];
    
    UILabel *blance = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15];
    blance.text = [LangSwitcher switchLang:[NSString stringWithFormat:@"%.3f%@",[ritAmount floatValue],plat.currency] key:nil];
    [buttonView addSubview:blance];
    [blance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonView.mas_top).offset(13);
        make.left.equalTo(blanceMoney.mas_right).offset(16);
        
    }];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setBackgroundColor:SugarPacketsBack forState:UIControlStateNormal];
    [sureButton setTitleColor:kHexColor(@"#A75E02 ") forState:UIControlStateNormal];
    [whiteView addSubview:sureButton];
    [sureButton setTitle:[LangSwitcher switchLang:@"立即付款" key:nil] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(payMoney) forControlEvents:UIControlEventTouchUpInside];
    
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonView.mas_bottom).offset(20);
        make.left.equalTo(whiteView.mas_left).offset(20);
        make.right.equalTo(whiteView.mas_right).offset(-20);
        make.height.equalTo(@50);
        
    }];
}

- (void)hideSelf
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view1.hidden = YES;
//        self.view1.frame = CGRectZero;
//        [self.view1 removeFromSuperview];
        
    }];
}

- (void)payMoney
{
    
    self.view1.hidden = YES;
//    self.view1.frame = CGRectZero;
//    [self.view1 removeFromSuperview];
    [UIView animateWithDuration:0.5 animations:^{
        
        [_delegate SendRedEnvelopeButton:102 currency:_currency type:_type count:_count sendNum:_sendNum greeting:_greeting];
        
    }];
    
    
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

    UITextField *textField1 = [self viewWithTag:10000];
    textField1.text = platform.currency;
    plat = platform;
    _currency = platform.currency;
    CoinModel *coin = [CoinUtil getCoinModel:platform.currency];

    NSString *leftAmount = [CoinUtil convertToRealCoin:platform.amountString coin:coin.symbol];
    NSString *rightAmount = [CoinUtil convertToRealCoin:platform.frozenAmountString coin:coin.symbol];
    NSString *ritAmount = [leftAmount subNumber:rightAmount];
    alltotalLabel.text = [NSString stringWithFormat:@"%@%@ %.3f",[LangSwitcher switchLang:@"个人账户余额" key:nil],platform.currency,[ritAmount floatValue]];


    NSString *str = [NSString stringWithFormat:@"%@ 0.000 %@",[LangSwitcher switchLang:@"共发送" key:nil],_currency];
    [self labelText:str];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 1000) {
        return NO;
    }
    if (textField.tag == 10000) {
        [self Tap];
        return NO;
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * resultStr = [textField.text stringByAppendingString:string];
    if (textField.tag == 10001) {

        if ([textField.text rangeOfString:@"."].location == NSNotFound) {
            isHaveDian = NO;
        }
        if ([string length] > 0) {
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
                //首字母不能为小数点
               
                if ([resultStr floatValue] > ALLPRICE) {
                    [TLAlert alertWithInfo:[LangSwitcher switchLang:@"不得大于一百万" key:nil]];
                    return NO;
                }else
                {
                    return YES;
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
    else if(textField.tag == 10002)
    {
        if ([string length] > 0) {
            unichar single = [string characterAtIndex:0];//当前输入的字符

            if([textField.text length] == 0){
                if(single == '.' || single == '0') {
                    [TLAlert alertWithInfo:[LangSwitcher switchLang:@"格式错误" key:nil]];
                    return NO;
                }
            }
            if ((single >= '0' && single <= '9')) {
                if ([resultStr floatValue] > 10000) {
                    [TLAlert alertWithInfo:[LangSwitcher switchLang:@"数量不得大于10000" key:nil]];
                    return NO;
                }else
                {
                    return YES;
                }
            }else
            {
                [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入数字" key:nil]];
                return NO;
            }
        }
    }else if(textField.tag == 10000)
    {
        
        return NO;
    }

    return YES;
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
            NSString *str = [NSString stringWithFormat:@"%@ %.3f %@",[LangSwitcher switchLang:@"共发送" key:nil],[_count floatValue]*[_sendNum floatValue],_currency];
            allPrice = [NSString stringWithFormat:@"%f",[_count floatValue]*[_sendNum floatValue]];
            [self labelText:str];
        }
    }else
    {
        NSString *str = [NSString stringWithFormat:@"%@ %.3f %@",[LangSwitcher switchLang:@"共发送" key:nil],[_count floatValue],_currency];
        allPrice = [NSString stringWithFormat:@"%f",[_count floatValue]];
        [self labelText:str];
    }
}

@end
