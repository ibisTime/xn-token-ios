//
//  ChangeForwordVC.m
//  Coin
//
//  Created by shaojianfei on 2018/6/12.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "ChangeForwordVC.h"
#import "ResiseTextFiled.h"
#import "BuildSucessVC.h"
#import "TLTabBarController.h"
#import "AppColorMacro.h"
#import "TLUpdateVC.h"
@interface ChangeForwordVC ()<UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, strong) UILabel *numLabel;
//密码输入
@property (nonatomic, strong) UIView *blackView;

@property (nonatomic, strong) UILabel *warnLabel;


//用于存放黑色的点点
@property (nonatomic, strong) NSMutableArray *dotArray;
@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, strong) ResiseTextFiled *textFiled;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UITextField *test;
@property (nonatomic, assign) NSInteger inter;
@property (nonatomic, strong) NSMutableArray *oldPSWArray;
@property (nonatomic, strong) NSMutableArray *FirstPSWArray;
@end

@implementation ChangeForwordVC

- (void)viewDidLoad {
    self.title = [LangSwitcher switchLang:@"修改交易密码" key:nil];
    self.view.backgroundColor = kWhiteColor;
    [super viewDidLoad];
    self.inter = -1;
    
    [self initTextFliedButton];
    // Do any additional setup after loading the view.
}

- (void)initTextFliedButton
{
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 29, kScreenWidth, 44) textAligment:NSTextAlignmentLeft backgroundColor:kClearColor font:[UIFont systemFontOfSize:17] textColor:kTextColor];
    self.numLabel = nameLab;
    [self.view addSubview:nameLab];
    nameLab.text = [LangSwitcher switchLang:@"请输入交易密码" key:nil];
    self.buttonArray = [NSMutableArray arrayWithCapacity:6];
    self.dotArray = [NSMutableArray arrayWithCapacity:6];
    self.oldPSWArray = [NSMutableArray arrayWithCapacity:6];
    UITextField *test = [UITextField new] ;
    test.autocapitalizationType = UITextAutocapitalizationTypeNone;
    test.keyboardType = UIKeyboardTypeNumberPad;
    //输入框光标的颜色为灰色
    test.tintColor = kClearColor;
    
    self.test = test;
    
    self.test.textColor = kClearColor;
    test.delegate = self;
    [self.test addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    test.frame = CGRectMake(0, CGRectGetMaxY(self.numLabel.frame), kScreenWidth, 40);
    [self.view addSubview:test];
    int spac = 15*kScreenWidth/375;
    int offset = 30*kScreenWidth/375;
    for (int i = 0; i < 6; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(offset+i*spac + i*40, 0, 40, 40);
        btn.layer.cornerRadius = 5;
        self.btn = btn;
        btn.clipsToBounds = YES;
        btn.enabled =NO;
        [btn addTarget:self action:@selector(buttonClickPassword:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = kHexColor(@"#ededed");
        [self.test addSubview:btn];
        UIView *blackView = [[UIView alloc] init];
        blackView.backgroundColor = kBlackColor;
        blackView.layer.cornerRadius = 6;
        blackView.clipsToBounds = YES;
        blackView.hidden = YES;
        blackView.tag = 20180607+i;
        
        blackView.frame = CGRectMake(14, 14, 12, 12);
        self.blackView = blackView;
        [self.btn addSubview:blackView];
        [self.buttonArray addObject:btn];
        [self.dotArray addObject:blackView];
    }
    
    self.warnLabel = [[UILabel alloc] init];
    self.warnLabel.numberOfLines = 0;
    
    self.warnLabel.textColor = kAppCustomMainColor;
    self.warnLabel.font = [UIFont systemFontOfSize:14];
    self.warnLabel.text = [LangSwitcher switchLang:@"注意!  THA不储存用户密码,   无法提供找回或重置功能。  如果忘记密码,   用户只能通过自己备份的钱包私钥,   重新导入后设置新密码" key:nil];
    [self.view addSubview:self.warnLabel];
    [self.warnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.test.mas_bottom).offset(60);
        
    }];
    
    
}

- (void)buttonClickPassword: (UIButton *)button
{
    [self.test becomeFirstResponder];
    
    [self.test endEditing:YES];
    //    self.test.enabled = NO;
    
}

-(void)textFieldDidChange:(UITextField *)textView
{
    
    
    NSLog(@"%@",textView.text);
    //    textView.text = @"";
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]){
        
        //        if (self.Type == PassWprdTypeMake) {
        if (self.inter < self.dotArray.count) {
            if (self.Type == CheckWprdTypeSecond) {
                self.blackView =  (UIView *)self.dotArray[self.inter];
                self.blackView.hidden = YES;
                
                [self.FirstPSWArray removeLastObject];
            }
            else{
                self.blackView =  (UIView *)self.dotArray[self.inter];
                self.blackView.hidden = YES;
                
                [self.oldPSWArray removeLastObject];
            }
            //                if (self.oldPSWArray.count == 6 && self.FirstPSWArray.count ==! 6) {
            //
            //                    [self.FirstPSWArray removeLastObject];
            //                }
            
            //            self.blackView =  (UIView *)self.dotArray[self.inter];
            //            self.blackView.hidden = YES;
            //            [self.FirstPSWArray removeLastObject];
            
            //        }else{
            //
            //      }
            
        }
        self.inter -= 1;
        
        
        return NO;
        
    }
    NSLog(@"%@",string);
    self.inter +=1;
    if (self.inter < self.dotArray.count) {
        
        if (self.Type == CheckWprdTypeSecond) {
            self.blackView =  (UIView *)self.dotArray[self.inter];
            self.blackView.hidden = NO;
            [self.FirstPSWArray addObject:string];
            if (self.FirstPSWArray.count == 6) {
                //校验密码
                [self setSecondPWD];
                
                
            }
            
        }
        else{
            self.blackView =  (UIView *)self.dotArray[self.inter];
            self.blackView.hidden = NO;
            //        if (self.Type == PassWprdTypeMake) {
            
            [self.oldPSWArray addObject:string];
            if (self.oldPSWArray.count == 6) {
                //再次输入密码
                [self setNewPWD];
                self.warnLabel.hidden = YES;
                
                
            }
            
            
        }
    }
    return YES;
    
}

- (void)setNewPWD
{
    self.FirstPSWArray = [NSMutableArray arrayWithCapacity:6];
    self.textFiled.text = nil;
    self.inter = -1;
    self.Type = CheckWprdTypeSecond;
    self.numLabel.text = [LangSwitcher switchLang:@"请确认交易密码" key:nil];
    for (int i = 0;i<self.dotArray.count ; i++) {
        self.blackView = self.dotArray[i];
        self.blackView.hidden = YES;
    }
    
}
- (void)setSecondPWD
{
    
    NSLog(@"%@",self.oldPSWArray);
    NSLog(@"%@",self.FirstPSWArray);
    if ([self.oldPSWArray isEqualToArray:self.FirstPSWArray]) {
        self.Type = CheckWprdTypeFirst;
#warning to do;   //支付密码设置完成 待储存
        if (self.IsImport == YES) {
            //导入
//            NSString *pwd = [self.FirstPSWArray componentsJoinedByString:@""];
//            [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:KUserPwd];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//
//            //导入钱包 设置的交易密码
//            TLUpdateVC *up = [[TLUpdateVC alloc] init];
//            TLTabBarController *tabBarCtrl = [[TLTabBarController alloc] init];
//
//            [UIApplication sharedApplication].keyWindow.rootViewController = up;
            
        }else{
            //创建
            NSString *pwd = [self.FirstPSWArray componentsJoinedByString:@""];
//            [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:KUserPwd];
            //
            [[NSUserDefaults standardUserDefaults] synchronize];
            TLDataBase *db = [TLDataBase sharedManager];
            if ([db.dataBase open]) {
                NSString *sql = [NSString stringWithFormat:@"UPDATE THAWallet SET PwdKey = '%@' WHERE userId = '%@'",pwd,[TLUser user].userId];
                BOOL sucess = [db.dataBase executeUpdate:sql];
                
                NSLog(@"导入钱包交易密码%d",sucess);
            }
            [db.dataBase close];
            [TLAlert alertWithMsg:[LangSwitcher switchLang:@"交易密码修改成功" key:nil]];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
//            BuildSucessVC *sucessVC = [BuildSucessVC new];
//            TLNavigationController *na = [[TLNavigationController alloc] initWithRootViewController:sucessVC];
//
//            [UIApplication sharedApplication].keyWindow.rootViewController = na;
        }
        
    }else{
        
        self.inter = -1;
        [self.oldPSWArray removeAllObjects];
        [self.FirstPSWArray removeAllObjects];
        self.textFiled.text = nil;
        self.numLabel.text = [LangSwitcher switchLang:@"请输入交易密码" key:nil];
        self.warnLabel.hidden = NO;
        
        for (int i = 0;i<self.dotArray.count ; i++) {
            self.blackView = self.dotArray[i];
            self.blackView.hidden = YES;
        }
        self.Type = CheckWprdTypeFirst;
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
