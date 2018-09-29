//
//  PosBuyVC.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "PosBuyVC.h"
#import "PosBuyTableView.h"
#import "TLPwdRelatedVC.h"
#import "RechargeCoinVC.h"
#import "PayModel.h"
#import "AssetPwdView.h"
//#import "TLMyRecordVC.h"
#import "PosMyInvestmentDetailsVC.h"
@interface PosBuyVC ()<RefreshDelegate>
{
    int number;
    
}
@property (nonatomic , strong)PosBuyTableView *tableView;

@property (nonatomic , strong)UILabel *numberLabel;

@property (nonatomic , strong)UIView *view2;
@property (nonatomic , strong)UIView *view3;


@property (nonatomic , strong)NSTimer *timeOut;

@property (nonatomic ,strong) AssetPwdView *pwdView;

@property (nonatomic, strong)CurrencyModel *currencyModel;

@property (nonatomic , strong)UILabel *moneyLab;
@property (nonatomic , strong)TLTextField *inputFiled;
@property (nonatomic , strong)UILabel *coinLab;
@property (nonatomic , copy)NSString *payCount;
@property (nonatomic , strong)PayModel *payModel;
@property (nonatomic , assign)NSInteger time;
@property (nonatomic , strong)UILabel *timeLab;

@property (nonatomic , strong)NSDictionary *dataDic;

@end

@implementation PosBuyVC



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];

    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(kScreenWidth/2-60, 0, 120, 50)];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.backgroundColor = [UIColor clearColor];
    titleText.textColor=kTextColor;
    [titleText setFont:[UIFont systemFontOfSize:17.0]];
    [titleText setText:[LangSwitcher switchLang:@"购买" key:nil]];
    self.navigationItem.titleView=titleText;

    UIButton *continBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"购买" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:18];
    [continBtn setBackgroundImage:kImage(@"Rectangle 3") forState:(UIControlStateNormal)];
    continBtn.frame = CGRectMake(0, SCREEN_HEIGHT - 50 - kNavigationBarHeight, SCREEN_WIDTH, 50);
    [continBtn addTarget:self action:@selector(continBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:continBtn];

    number = 1;

//    密码框
    AssetPwdView *pwdView =[[AssetPwdView alloc] init];
    pwdView.isPay = YES;
    self.pwdView = pwdView;
    pwdView.HiddenBlock = ^{
        self.pwdView.hidden = YES;
        [self.pwdView endEditing:YES];
        [self.view endEditing:YES];
        //        [self.pwdView removeFromSuperview];
    };
    CoinWeakSelf;
    self.pwdView.forgetBlock = ^{
        weakSelf.pwdView.hidden = YES;
        weakSelf.view2.hidden = YES;
        TLPwdRelatedVC *vc  = [[TLPwdRelatedVC alloc] initWithType:TLPwdTypeTradeReset];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        vc.success = ^{
            weakSelf.pwdView.hidden = NO;
            weakSelf.view2.hidden = NO;
        };

    };
    pwdView.hidden = YES;
    pwdView.frame = self.view.bounds;
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    [keyWindow addSubview:pwdView];

    [self getMySyspleList];
    [self LoadData];


}



- (void)initTableView {
    self.tableView = [[PosBuyTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavigationBarHeight) style:(UITableViewStyleGrouped)];
    self.tableView.refreshDelegate = self;
    self.tableView.backgroundColor = kBackgroundColor;
    self.tableView.moneyModel = self.moneyModel;
    [self.view addSubview:self.tableView];

}

//  +++++++++  ------------
-(void)refreshTableViewButtonClick:(TLTableView *)refreshTableview button:(UIButton *)sender selectRowAtIndex:(NSInteger)index
{
    self.numberLabel = [self.view viewWithTag:1212];
    UILabel *label = [self.view viewWithTag:456];
    UISlider *slider = [self.view viewWithTag:12345];
    NSString *increAmount = [CoinUtil convertToRealCoin:self.moneyModel.increAmount coin:self.moneyModel.symbol];
    if (sender.tag == 500) {

        if (number <= [_dataDic[@"min"] integerValue]) {
            return;
        }
        number -- ;
        self.numberLabel.text = [NSString stringWithFormat:@"%d", number];
        slider.value = number/1.00;
        label.text = [NSString stringWithFormat:@"(%.2f%@)",[increAmount floatValue] * number,self.moneyModel.symbol];
    }else if (sender.tag == 501)
    {
        if (number >= [_dataDic[@"max"] integerValue])
        {
            return;
        }
        number ++;
        self.numberLabel.text = [NSString stringWithFormat:@"%d", number];
        slider.value = number/1.00;
        label.text = [NSString stringWithFormat:@"(%.2f%@)",[increAmount floatValue] * number,self.moneyModel.symbol];

    }else if (sender.tag == 502)
    {
        RechargeCoinVC *coinVC = [RechargeCoinVC new];
        coinVC.currency = self.currencyModel;
        [self.navigationController pushViewController:coinVC animated:YES];
    }

}

//  滑动
-(void)refreshTableView:(TLTableView *)refreshTableview Slider:(UISlider *)slider
{
    UILabel *label = [self.view viewWithTag:456];
    self.numberLabel = [self.view viewWithTag:1212];
    number = slider.value;
    self.numberLabel.text = [NSString stringWithFormat:@"%d", number];
    NSString *increAmount = [CoinUtil convertToRealCoin:self.moneyModel.increAmount coin:self.moneyModel.symbol];
    label.text = [NSString stringWithFormat:@"(%.2f%@)",[increAmount floatValue] * number,self.moneyModel.symbol];
}

-(void)LoadData
{
    TLNetworking *http = [[TLNetworking alloc] init];
    http.showView = self.view;
    http.code = @"625513";
    http.parameters[@"productCode"] = self.moneyModel.code;
    http.parameters[@"userId"] = [TLUser user].userId;
    [http postWithSuccess:^(id responseObject) {
        
        self.tableView.dataDic = responseObject[@"data"];
        self.dataDic = responseObject[@"data"];
        [self.tableView reloadData];

    } failure:^(NSError *error) {


    }];

}

- (void)getMySyspleList {

    CoinWeakSelf;
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    if (![TLUser user].isLogin) {
        return;
    }
    [TLProgressHUD show];
    helper.code = @"802503";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.parameters[@"token"] = [TLUser user].token;
    helper.isList = YES;
    helper.isCurrency = YES;
    [helper modelClass:[CurrencyModel class]];
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        //去除没有的币种
        NSMutableArray <CurrencyModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
        [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            CurrencyModel *currencyModel = (CurrencyModel *)obj;
            //                if ([[CoinUtil shouldDisplayCoinArray] indexOfObject:currencyModel.currency ] != NSNotFound ) {

            [shouldDisplayCoins addObject:currencyModel];
            //                }
            //查询总资产
        }];

        //
        weakSelf.currencys = shouldDisplayCoins;
        for (int i = 0; i < self.currencys.count; i++) {

            if ([self.moneyModel.symbol isEqualToString:self.currencys[i].currency]) {
                self.currencyModel = self.currencys[i];
            }
        }
        weakSelf.tableView.currencys = self.currencyModel;
        [TLProgressHUD dismiss];
        [weakSelf.tableView reloadData];

    } failure:^(NSError *error) {
        [TLProgressHUD dismiss];

    }];



}



//购买
- (void)continBtnClick
{

    if ([[TLUser user].tradepwdFlag isEqualToString:@"0"]) {
        TLPwdType pwdType = TLPwdTypeSetTrade;
        TLPwdRelatedVC *pwdRelatedVC = [[TLPwdRelatedVC alloc] initWithType:pwdType];
        pwdRelatedVC.isWallet = NO;
        pwdRelatedVC.success = ^{
        };
        [self.navigationController pushViewController:pwdRelatedVC animated:YES];


    }else
    {

        //购买
        [self payMoney];
    }

}

- (void)hideinPut
{
    [self.inputFiled resignFirstResponder];
    if (![self.inputFiled.text isBlank]) {
        self.coinLab.text = [NSString stringWithFormat:@"%.2f",[self.moneyModel.expectYield floatValue]* [self.inputFiled.text floatValue]/360* [self.moneyModel.limitDays floatValue]];
    }

}

- (void)payMoney
{

//    if ([TLUser isBlankString:self.currencyModel.currency] == NO) {
//        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"正在加载,请稍等" key:nil]];
//        return;
//    }
    NSString *leftAmount = [CoinUtil convertToRealCoin:self.currencyModel.amountString coin:self.currencyModel.currency];
    NSString *rightAmount = [CoinUtil convertToRealCoin:self.currencyModel.frozenAmountString coin:self.currencyModel.currency];
    NSString *ritAmount = [leftAmount subNumber:rightAmount];
    NSString *str1 = [NSString stringWithFormat:@" %.2f ",[ritAmount doubleValue]];


    NSString *increAmount1 = [CoinUtil convertToRealCoin:self.moneyModel.increAmount coin:self.moneyModel.symbol];


    if ([increAmount1 floatValue] * number > [str1 floatValue]) {
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"余额不足,请充值" key:nil]];
        return;
    }

    [self.view endEditing:YES];
    //确认购买

    PayModel *payModel = [PayModel new];
    self.payModel = payModel;
    payModel.name = self.moneyModel.symbol;
    payModel.count = self.inputFiled.text;
    payModel.endTime = self.moneyModel.arriveDatetime;
    if (![self.inputFiled.text isBlank] ) {


        self.coinLab.text = [NSString stringWithFormat:@"%.2f",[self.moneyModel.expectYield floatValue]* [self.inputFiled.text floatValue]/360* [self.moneyModel.limitDays floatValue]];


    }
    payModel.getFree = self.coinLab.text;


    UIView * view2 = [UIView new];
    self.view2 = view2;
    self.view2.hidden = NO;

    view2.frame =CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    view2.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.45];

    //    view.alpha = 0.5;
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    [keyWindow addSubview:view2];
    UIView *whiteView = [UIView new];
    whiteView.layer.cornerRadius=5;
    whiteView.layer.shadowOpacity = 0.22;// 阴影透明度
    whiteView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    whiteView.layer.shadowRadius=3;// 阴影扩散的范围控制
    whiteView.layer.shadowOffset=CGSizeMake(1, 1);// 阴影的范围
    whiteView.frame = CGRectMake(24, SCREEN_HEIGHT/2 - 175, kScreenWidth - 48, 350);
    whiteView.backgroundColor = kWhiteColor;
    [view2 addSubview:whiteView];


    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn setBackgroundImage:kImage(@"红包 删除") forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(hideSelfbuy) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.mas_top).offset(15);
        make.right.equalTo(whiteView.mas_right).offset(-15);
        make.width.height.equalTo(@22.5);
    }];

    UILabel *sureLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
    sureLab.text = [LangSwitcher switchLang:@"购买产品" key:nil];
    sureLab.frame = CGRectMake(30, 40, 0, 14);
    [sureLab sizeToFit];
    [whiteView addSubview:sureLab];


    UILabel *nameLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:15];
    nameLab.frame = CGRectMake(sureLab.xx + 10, sureLab.frame.origin.y + 1, SCREEN_WIDTH - 48 - 25 - sureLab.frame.size.width, 14);
    [whiteView addSubview:nameLab];

    switch ([LangSwitcher currentLangType]) {
        case LangTypeEnglish:
            nameLab.text = self.moneyModel.nameEn;

            break;
        case LangTypeKorean:
            nameLab.text = self.moneyModel.nameKo;

            break;
        case LangTypeSimple:
            nameLab.text = self.moneyModel.nameZhCn;

            break;

        default:
            break;
    }


    UIView *line1 = [UIView new];
    line1.backgroundColor = kLineColor;
    line1.frame = CGRectMake(15, nameLab.yy + 15, SCREEN_WIDTH - 48 -30, 0.5);
    [whiteView addSubview:line1];

    UILabel *buycount = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
    buycount.text = [LangSwitcher switchLang:@"购买额度" key:nil];
    buycount.frame = CGRectMake(30, line1.yy + 25, 0, 14);
    [buycount sizeToFit];
    [whiteView addSubview:buycount];


    UILabel *buy = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#FF6400") font:16];
    buy.frame = CGRectMake(buycount.xx + 10, buycount.frame.origin.y, SCREEN_WIDTH - 48 - 25 - buycount.frame.size.width, 14);
    [whiteView addSubview:buy];
    self.numberLabel = [self.view viewWithTag:1212];

    NSString *increAmount = [CoinUtil convertToRealCoin:self.moneyModel.increAmount coin:self.moneyModel.symbol];

    NSString *price = [NSString stringWithFormat:@"%.2f %@",[increAmount floatValue]* [self.numberLabel.text floatValue],self.currencyModel.currency];
    NSString *currency = self.currencyModel.currency;

    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:price];
    [attriStr addAttribute:NSForegroundColorAttributeName value:kTextBlack range:NSMakeRange(price.length - currency.length, currency.length)];
    buy.attributedText = attriStr;



    UIView *line2 = [UIView new];
    line2.backgroundColor = kLineColor;
    line2.frame = CGRectMake(15, buy.yy + 15, SCREEN_WIDTH - 48 -30, 0.5);
    [whiteView addSubview:line2];


    UILabel *freeTime = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];

    freeTime.text = [LangSwitcher switchLang:@"本息到期日期" key:nil];
    freeTime.frame = CGRectMake(30, line2.yy + 25, 0, 14);
    [freeTime sizeToFit];
    [whiteView addSubview:freeTime];

    UILabel *timeLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:15];
    timeLab.frame = CGRectMake(freeTime.xx + 10, freeTime.frame.origin.y  + 1, SCREEN_WIDTH - 48 - 25 - freeTime.frame.size.width, 14);
    [whiteView addSubview:timeLab];
    timeLab.text = [self.moneyModel.arriveDatetime convertDate];

    UIView *line3 = [UIView new];
    line3.backgroundColor = kLineColor;
    line3.frame = CGRectMake(15, timeLab.yy + 15, SCREEN_WIDTH - 48 -30, 0.5);
    [whiteView addSubview:line3];


    UILabel *moneyMay = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
    moneyMay.text = [LangSwitcher switchLang:@"预计收入" key:nil];
    moneyMay.frame = CGRectMake(30, line3.yy + 25, 0, 14);
    [moneyMay sizeToFit];
    [whiteView addSubview:moneyMay];


    UILabel *money = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#FF6400") font:16];
    money.text = [NSString stringWithFormat:@"%.2f",[price floatValue] * [self.moneyModel.expectYield floatValue]];
    money.frame = CGRectMake(moneyMay.xx + 5, moneyMay.frame.origin.y + 1,  SCREEN_WIDTH - 48 - 25 - moneyMay.xx, 14);
    [whiteView addSubview:money];


    UIView *line4 = [UIView new];
    line4.backgroundColor = kLineColor;
    line4.frame = CGRectMake(15, money.yy + 15, SCREEN_WIDTH - 48 -30, 0.5);
    [whiteView addSubview:line4];

    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setBackgroundColor:kAppCustomMainColor forState:UIControlStateNormal];
    [sureButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [view2 addSubview:sureButton];

    [sureButton setTitle:[LangSwitcher switchLang:@"确认付款" key:nil] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(payMoneyNow) forControlEvents:UIControlEventTouchUpInside];

    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line4.mas_bottom).offset(20);
        make.left.equalTo(whiteView.mas_left).offset(20);
        make.right.equalTo(whiteView.mas_right).offset(-20);
        make.height.equalTo(@50);

    }];
}



- (void)hideSelfbuy
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view2.hidden = YES;
    }];

}


- (void)payMoneyNow
{

    //确认付款
    self.view2.hidden = YES;
    self.pwdView.hidden = NO;
    self.pwdView.password.textField.enabled = YES;
    CoinWeakSelf;

    self.pwdView.passwordBlock = ^(NSString *password) {
        if ([password isEqualToString:@""]) {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入支付密码" key:nil]];
            return ;
        }
        [weakSelf.pwdView.password clearText];

        TLNetworking *http = [[TLNetworking alloc] init];
        http.showView = weakSelf.view;
        http.code = @"625520";
        http.parameters[@"code"] = weakSelf.moneyModel.code;

        weakSelf.numberLabel = [weakSelf.view viewWithTag:1212];
        http.parameters[@"investFen"] = @([weakSelf.numberLabel.text integerValue]);
        http.parameters[@"tradePwd"] = password;
        http.parameters[@"userId"] = [TLUser user].userId;
        [http postWithSuccess:^(id responseObject) {

            NSNotification *notification =[NSNotification notificationWithName:@"LOADDATA" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];

            [weakSelf showBuySucess];
            weakSelf.pwdView.hidden = YES;

        } failure:^(NSError *error) {
            weakSelf.pwdView.hidden = NO;
            [weakSelf.pwdView.password clearText];

            return ;

        }];



    };

}

- (void)showBuySucess
{
    UIView * view3 = [UIView new];
    self.view3 = view3;
    self.view3.hidden = NO;

    view3.frame =CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    view3.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.45];

    //    view.alpha = 0.5;
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    [keyWindow addSubview:view3];
    UIView *whiteView = [UIView new];

    [view3 addSubview:whiteView];

    whiteView.frame = CGRectMake(24, 194, kScreenWidth - 48, 300);
    whiteView.layer.cornerRadius=5;
    whiteView.layer.shadowOpacity = 0.22;// 阴影透明度
    whiteView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    whiteView.layer.shadowRadius=3;// 阴影扩散的范围控制
    whiteView.layer.shadowOffset=CGSizeMake(1, 1);// 阴影的范围
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

    UIImageView *bgImage = [[UIImageView alloc] init];
    bgImage.image = kImage(@"打勾 大");
    [whiteView addSubview:bgImage];

    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(whiteView.mas_top).offset(35);
        make.centerX.equalTo(whiteView.mas_centerX);
        make.width.height.equalTo(@(kHeight(60)));
    }];

    UILabel *sureLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:20];
    [whiteView addSubview:sureLab];
    sureLab.text = [LangSwitcher switchLang:@"购买成功" key:nil];
    [sureLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImage.mas_bottom).offset(18);

        make.centerX.equalTo(whiteView.mas_centerX);

    }];

    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setBackgroundColor:kClearColor forState:UIControlStateNormal];
    [sureButton setTitleColor:kTextColor forState:UIControlStateNormal];
    [whiteView addSubview:sureButton];
    sureButton.titleLabel.font = FONT(13);
    [sureButton setTitle:[LangSwitcher switchLang:@"查看购买记录" key:nil] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(payMoneyNowRecode) forControlEvents:UIControlEventTouchUpInside];

    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sureLab.mas_bottom).offset(18);
        make.centerX.equalTo(whiteView.mas_centerX);

        make.width.equalTo(@150);
        make.height.equalTo(@32);

    }];

    sureButton.layer.borderWidth = 0.5;
    sureButton.layer.borderColor = kPlaceholderColor.CGColor;
    sureButton.layer.cornerRadius = 4;
    sureButton.clipsToBounds = YES;
    self.time = 5;

    UILabel *timeLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kPlaceholderColor font:12];
    self.timeLab = timeLab;
    [whiteView addSubview:timeLab];
    NSString * t  = [NSString stringWithFormat:@"%ld",self.time];
    timeLab.text = [NSString stringWithFormat:@"%@%@",t,[LangSwitcher switchLang:@"秒钟自动跳转" key:nil]];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sureButton.mas_bottom).offset(18);

        make.centerX.equalTo(whiteView.mas_centerX);

    }];
    self.timeOut = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timeOut forMode:NSRunLoopCommonModes];
}

-(void)hideSelf
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view3.hidden = YES;
    }];

}

- (void)timeAction{

    self.time --;
    NSString * t  = [NSString stringWithFormat:@"%ld",self.time];
    _timeLab.text = [NSString stringWithFormat:@"%@%@",t,[LangSwitcher switchLang:@"秒钟自动跳转" key:nil]];

    if (self.time == 0) {

        [self.timeOut invalidate];
        self.timeOut = nil;
        self.view3.hidden = YES;
        PosMyInvestmentDetailsVC *VC = [PosMyInvestmentDetailsVC new];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
- (void)payMoneyNowRecode
{
    [self.timeOut invalidate];
    self.timeOut = nil;
    self.view3.hidden = YES;
    PosMyInvestmentDetailsVC *VC = [PosMyInvestmentDetailsVC new];
    [self.navigationController pushViewController:VC animated:YES];

}




- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = item;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;


}

//如果仅设置当前页导航透明，需加入下面方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = kHexColor(@"#0848DF");
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

@end
