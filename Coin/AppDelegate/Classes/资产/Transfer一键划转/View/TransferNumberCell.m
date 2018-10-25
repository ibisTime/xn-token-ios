//
//  TransferNumberCell.m
//  Coin
//
//  Created by 郑勤宝 on 2018/10/25.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "TransferNumberCell.h"

@implementation TransferNumberCell
{
    BOOL isHaveDian;
    BOOL isLocalCell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        
        
        UIView *blue = [[UIView alloc] init];
        
        blue.frame = CGRectMake(30, 25, 10, 10);
        self.blue = blue;
        blue.layer.cornerRadius = 5;
        blue.clipsToBounds = YES;
        [self addSubview:blue];
        
        UIView *org = [[UIView alloc] init];
        
        org.layer.cornerRadius = 5;
        org.frame = CGRectMake(30, 65, 10, 10);
        org.clipsToBounds = YES;
        
        [self addSubview:org];
        
        self.org= org;
//        [blue mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.mas_top).offset(20);
//            make.left.equalTo(self.mas_left).offset(15);
//            make.width.height.equalTo(@8);
//
//        }];
//        [org mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.top.equalTo(blue.mas_bottom).offset(30);
//            make.left.equalTo(self.mas_left).offset(15);
//            make.width.height.equalTo(@8);
//
//        }];
        
        UILabel *from = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#999999") font:12];
        
        from.text = [LangSwitcher switchLang:@"从" key:nil];
        UILabel *to = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#999999") font:12];
        to.text = [LangSwitcher switchLang:@"到" key:nil];
        
        [self addSubview:from];
        [self addSubview:to];
        [from mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(blue.mas_centerY);
            make.left.equalTo(blue.mas_right).offset(5);
            
        }];
        [to mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(org.mas_centerY);
            make.left.equalTo(org.mas_right).offset(5);
        }];
        
        UILabel *myprviate =  [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:15];
        
        UILabel *prviatekey =  [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:15];
        self.myprivate = myprviate;
        self.privateKey = prviatekey;
        [self addSubview:myprviate];
        [self addSubview:prviatekey];
        
        
        [myprviate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(from.mas_centerY);
            make.left.equalTo(to.mas_right).offset(10);
            
        }];
        [prviatekey mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(org.mas_centerY);
            make.left.equalTo(to.mas_right).offset(10);
        }];
        
        
        UIButton *but = [UIButton buttonWithTitle:@"" titleColor:kTextBlack backgroundColor:kClearColor titleFont:15];
        [but setImage:kImage(@"转换ICON") forState:UIControlStateNormal];
        but.frame = CGRectMake(SCREEN_WIDTH - 66, 35, 36, 30);
        [self addSubview:but];
        self.changebut = but;
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 90, SCREEN_WIDTH - 20, 1)];
        self.lineView = lineView;
        lineView.backgroundColor = kLineColor;
        [self addSubview:lineView];
        
        UIView *wallletView  = [UIView new];
        wallletView.backgroundColor = kWhiteColor;
        wallletView.layer.cornerRadius=5;
        wallletView.layer.shadowOpacity = 0.22;// 阴影透明度
        wallletView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
        wallletView.layer.shadowRadius=3;// 阴影扩散的范围控制
        wallletView.layer.shadowOffset = CGSizeMake(1, 1);// 阴
        self.wallletView = wallletView;
        [self addSubview:wallletView];
        
        UILabel *introduce = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
        introduce.text = [LangSwitcher switchLang:@"划入数量" key:nil];
        introduce.frame = CGRectMake(15, 15, SCREEN_WIDTH - 60, 20);
        [wallletView addSubview:introduce];
        
        
        self.inputFiled = [[TLTextField alloc] initWithFrame:CGRectMake(15, 43, kScreenWidth-60, 50) leftTitle:@"" titleWidth:5 placeholder:[LangSwitcher switchLang:@"转账数量" key:nil]];
        self.inputFiled.backgroundColor = kHexColor(@"#FBFBFB");
        self.inputFiled.clearButtonMode = UITextFieldViewModeNever;
        [wallletView addSubview:self.inputFiled];
        self.inputFiled.layer.cornerRadius = 3;
        self.inputFiled.layer.borderWidth = 1;
        self.inputFiled.layer.borderColor = kHexColor(@"#DEE0E5").CGColor;
        self.inputFiled.delegate = self;
        self.inputFiled.tag = 1000;
        self.inputFiled.keyboardType = UIKeyboardTypeDecimalPad;
        
        
        UILabel *symbolLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:15];
//
        self.symbolLab = symbolLab;
        [self.inputFiled addSubview:symbolLab];
        [symbolLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.inputFiled.mas_centerY);
            make.right.equalTo(self.inputFiled.mas_right).offset(-100);
            
        }];
        
        UIButton *allLab = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"全部" key:nil] titleColor:kTextBlack backgroundColor:kClearColor titleFont:14];
        
        [wallletView addSubview:allLab];
        //    self.changebut = allLab;
        [allLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.inputFiled.mas_centerY);
            make.right.equalTo(self.inputFiled.mas_right).offset(-10);
            make.width.height.equalTo(@80);
            make.height.equalTo(@35);
            
        }];
        
        allLab.layer.cornerRadius = 2;
        allLab.layer.borderWidth = 1;
        allLab.layer.borderColor = kAppCustomMainColor.CGColor;
        allLab.clipsToBounds = YES;
        self.allLab = allLab;
        
        
        
        
        
        //     谷歌验证码输入框
        self.googleAuthTF = [[TLTextField alloc] initWithFrame:CGRectMake(15, 100, kScreenWidth-60, 50)
                                                     leftTitle:[LangSwitcher switchLang:@"" key:nil]
                                                    titleWidth:5
                                                   placeholder:[LangSwitcher switchLang:@"请输入谷歌验证码" key:nil]];
        self.googleAuthTF.backgroundColor = kHexColor(@"#FBFBFB");
        self.googleAuthTF.clearButtonMode = UITextFieldViewModeNever;
        self.googleAuthTF.tag = 1001;
        self.googleAuthTF.layer.cornerRadius = 3;
        self.googleAuthTF.layer.borderWidth = 1;
        self.googleAuthTF.layer.borderColor = kHexColor(@"#DEE0E5").CGColor;
        self.googleAuthTF.keyboardType = UIKeyboardTypeDecimalPad;
        [wallletView addSubview:self.googleAuthTF];
        
        
        
        self.leftAmount = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15];
        self.leftAmount.text = [LangSwitcher switchLang:@"可用余额" key:nil];
        [wallletView addSubview:self.leftAmount];
        
#pragma mark -- 是否开启谷歌验证码
        if ([TLUser user].isGoogleAuthOpen == YES) {
            self.googleAuthTF.hidden = NO;
//            [wallletView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(lineView.mas_bottom).offset(10);
//                make.left.equalTo(@15);
//                make.right.equalTo(@-15);
//                make.height.equalTo(@(250));
//            }];
//            self.wallletView.frame = CGRectMake(15, _lineView.yy, SCREEN_WIDTH - 60, 250);
//
//            self.leftAmount.frame = CGRectMake(15, 165, SCREEN_WIDTH - 60, 20);
            
        }else
        {
            self.googleAuthTF.hidden = YES;
//            [wallletView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(lineView.mas_bottom).offset(10);
//                make.left.equalTo(@15);
//                make.right.equalTo(@-15);
//                make.height.equalTo(@(200));
//            }];
//            self.wallletView.frame = CGRectMake(15, _lineView.yy, SCREEN_WIDTH - 60, 200);
//            self.leftAmount.frame = CGRectMake(15, 115, SCREEN_WIDTH - 60, 20);
        }
        
//        UILabel *avildAmount = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15];
//        self.amountlLab = avildAmount;
//        if (self.isLocal == YES) {
//            NSString *money = [CoinUtil convertToRealCoin:self.currencys[0].balance coin:self.currencys[0].symbol];
//
//            avildAmount.text = [NSString stringWithFormat:@"%@ %@",money,self.currencys[0].symbol];
//        }else{
//            NSString *leftAmount = [self.currencys[0].amountString subNumber:self.currencys[0].frozenAmountString];
//
//            //
//            NSString *money = [CoinUtil convertToRealCoin:leftAmount coin:self.currencys[0].currency];
//
//            avildAmount.text = [NSString stringWithFormat:@"%@ %@",money,self.currencys[0].currency];
//        }
        
//        [wallletView addSubview:avildAmount];
        
        
//        [avildAmount mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.leftAmount.mas_centerY);
//
//            make.left.equalTo(self.leftAmount.mas_right).offset(15);
//
//        }];
        
        self.googleAuthTF.hidden = ![TLUser user].isGoogleAuthOpen;
        
        UISlider *slider = [UISlider new];
        self.slider = slider;
        [wallletView addSubview:slider];
        slider.maximumValue = 1.0;
        slider.minimumValue = 0;
        slider.thumbTintColor = kHexColor(@"#1B61F0");
        slider.minimumTrackTintColor = kHexColor(@"#1B61F0");
        slider.maximumTrackTintColor = kHexColor(@"#DDE6F9");
        slider.value = 0.5;
        slider.tag = 1002;
        
        [slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.bottom.equalTo(wallletView.mas_bottom).offset(-20);
            make.width.equalTo(@(kScreenWidth-60));
            make.height.equalTo(@(20));
        }];
        
        
//        UIView *line = [UIView new];
//        line.backgroundColor = kLineColor;
//        [wallletView addSubview:line];
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(avildAmount.mas_bottom).offset(10);
//            make.left.equalTo(wallletView.mas_left).offset(15);
//            make.right.equalTo(wallletView.mas_right).offset(-15);
//            make.height.equalTo(@1);
//
//        }];
        
        
        self.importButton = [UIButton buttonWithImageName:nil cornerRadius:6];
        NSString *text2 = [LangSwitcher switchLang:@"划转" key:nil];
        [self.importButton setTitle:text2 forState:UIControlStateNormal];
        self.importButton.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [self.importButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        
        [self.importButton setBackgroundColor:kAppCustomMainColor forState:UIControlStateNormal];
        self.importButton.layer.borderColor = (kAppCustomMainColor.CGColor);
        self.importButton.layer.borderWidth = 1;
        self.importButton.clipsToBounds = YES;
        [self addSubview:self.importButton];
        [self.importButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wallletView.mas_bottom).offset(60);
            make.right.equalTo(self.mas_right).offset(-35);
            make.left.equalTo(self.mas_left).offset(35);
            make.height.equalTo(@48);
            
        }];
        
        UILabel *totalFree = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
        
        [wallletView addSubview:totalFree];
        
        totalFree.textAlignment = NSTextAlignmentCenter;
        self.totalFree = totalFree;
        self.totalFree.tag = 1212;
        [totalFree mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.importButton.mas_top).offset(-10);
            make.left.equalTo(self.importButton.mas_left).offset(0);
            make.right.equalTo(self.importButton.mas_right).offset(0);
            
        }];
//        if (self.isLocal == YES) {
//            totalFree.text = [LangSwitcher switchLang:@"本次划转矿工费为" key:nil];
//
//        }else{
//
//            NSString *money1 = [CoinUtil convertToRealCoin:self.currencys[0].amountString coin:self.currencys[0].currency];
//            totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%@ %@",money1,self.currencys[0].currency]];
//
//        }

    }
    return self;
}

-(void)setIsLocal:(BOOL)isLocal
{
    isLocalCell = isLocal;
    if (isLocal == NO) {
        self.slider.hidden = YES;
        self.blue.backgroundColor =kAppCustomMainColor;
        self.org.backgroundColor =kOrangeRedColor;
        
        self.myprivate.text = [LangSwitcher switchLang:@"个人账户" key:nil];
        self.privateKey.text = [LangSwitcher switchLang:@"私钥账户" key:nil];
        if ([TLUser user].isGoogleAuthOpen == YES) {
            
            self.wallletView.frame = CGRectMake(15, _lineView.yy + 10, SCREEN_WIDTH - 30, 200);
            self.leftAmount.frame = CGRectMake(15, 165, SCREEN_WIDTH - 60, 20);
            
        }else
        {
            
            self.wallletView.frame = CGRectMake(15, _lineView.yy + 10, SCREEN_WIDTH - 30, 150);
            self.leftAmount.frame = CGRectMake(15, 115, SCREEN_WIDTH - 60, 20);
        }
    }else
    {
        self.org.backgroundColor =kAppCustomMainColor;
        self.blue.backgroundColor =kOrangeRedColor;
        
        self.myprivate.text = [LangSwitcher switchLang:@"私钥账户" key:nil];
        self.privateKey.text = [LangSwitcher switchLang:@"个人账户" key:nil];
        self.slider.hidden = NO;
        if ([TLUser user].isGoogleAuthOpen == YES) {
            
            self.wallletView.frame = CGRectMake(15, _lineView.yy + 10, SCREEN_WIDTH - 30, 250);
            self.leftAmount.frame = CGRectMake(15, 165, SCREEN_WIDTH - 60, 20);
            
        }else
        {
            
            self.wallletView.frame = CGRectMake(15, _lineView.yy + 10, SCREEN_WIDTH - 30, 200);
            self.leftAmount.frame = CGRectMake(15, 115, SCREEN_WIDTH - 60, 20);
        }
    }
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.bottom.equalTo(self.wallletView.mas_bottom).offset(-20);
        make.width.equalTo(@(kScreenWidth-60));
        make.height.equalTo(@(20));
    }];
    [self.importButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wallletView.mas_bottom).offset(60);
        make.right.equalTo(self.mas_right).offset(-35);
        make.left.equalTo(self.mas_left).offset(35);
        make.height.equalTo(@48);
        
    }];
    [self.totalFree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.importButton.mas_top).offset(-10);
        make.left.equalTo(self.importButton.mas_left).offset(0);
        make.right.equalTo(self.importButton.mas_right).offset(0);
        
    }];
}

-(void)setModel:(CurrencyModel *)model
{
    if (isLocalCell == YES) {
        NSString *money = [CoinUtil convertToRealCoin:model.balance coin:model.symbol];
        self.leftAmount.text= [NSString stringWithFormat:@"%@:  %@ %@",[LangSwitcher switchLang:@"可用余额" key:nil],money,model.symbol];
        _symbolLab.text = model.currency;
        
    }
    else
    {
        NSString *leftAmount = [model.amountString subNumber:model.frozenAmountString];
        NSString *money = [CoinUtil convertToRealCoin:leftAmount coin:model.currency];
        self.leftAmount.text = [NSString stringWithFormat:@"%@:  %@ %@",[LangSwitcher switchLang:@"可用余额" key:nil],money,model.currency];
        
        CoinModel *currentCoin = [CoinUtil getCoinModel:model.currency];
        self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%@ %@", [CoinUtil convertToRealCoin:currentCoin.withdrawFeeString coin:model.currency], model.currency]];
//        self.amountlLab.text = [NSString stringWithFormat:@"%@ %@",money,model.currency];
    }
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField.text rangeOfString:@"."].location==NSNotFound) {
        isHaveDian=NO;
    }
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            if([textField.text length]==0){
                if(single == '.'){
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            if (single=='.')
            {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian=YES;
                    return YES;
                }else
                {
                    
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            
            return YES;
        }else{
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}


// 全部
-(void)allTransform
{
    
}


@end
