//
//  WalletAddressDetailVC.m
//  Coin
//
//  Created by shaojianfei on 2018/6/12.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "WalletAddressDetailVC.h"
#import "CoinUtil.h"
#import "WalletAdressTableView.h"
#import "NSString+Extension.h"
#import "NSString+Check.h"
#import <Masonry/Masonry.h>
@interface WalletAddressDetailVC ()
@property (nonatomic , strong) UILabel *titleLable;

@property (nonatomic , strong) UILabel *contentLab;

@property (nonatomic , strong) UIButton *addressButton;
@property (nonatomic , strong) UIButton *privateButton;

@property (nonatomic , copy) NSString *privates;

@property (nonatomic , copy) NSString *address;


@end

@implementation WalletAddressDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.title = [LangSwitcher switchLang:[NSString stringWithFormat:@"%@私钥",self.currentModel.symbol] key:nil];
    [self  initSubViews];
    // Do any additional setup after loading the view.
}


- (void)initSubViews
{
    
    self.titleLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    
    self.titleLable.text = [LangSwitcher switchLang:@"注意 ! 拥有私钥就能完全控制该地址的资产 , 不要分享给任何人 " key:nil];
    [self.view addSubview:self.titleLable];
    self.titleLable.numberOfLines = 0;
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);

        make.top.equalTo(@30);
    }];
    
    self.contentLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kBlackColor font:16];
    
    self.contentLab.text = [LangSwitcher switchLang:[NSString stringWithFormat:@"以下是%@的地址和私钥 , 点击可复制 ",self.currentModel.symbol] key:nil];
    [self.view addSubview:self.contentLab];
    self.contentLab.textAlignment = NSTextAlignmentCenter;
    self.contentLab.numberOfLines = 0;
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);

        make.top.equalTo(self.titleLable.mas_bottom).offset(30);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    [self.view addSubview:contentView];
    contentView.backgroundColor = kWhiteColor;
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLab.mas_bottom).offset(15);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.equalTo(@200);


    }];
    
    UILabel *address = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:13];
    address.text = [LangSwitcher switchLang:@"地址" key:nil];
    [contentView addSubview:address];
    [address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top).offset(25);
        make.left.equalTo(@15);
        make.width.equalTo(@50);

    }];
    
    UILabel *private = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:13];
    private.text = [LangSwitcher switchLang:@"私钥" key:nil];
    [contentView addSubview:private];
    [private mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(address.mas_bottom).offset(50);
        make.left.equalTo(@15);
        make.width.equalTo(@50);

    }];
    
    self.addressButton = [UIButton buttonWithTitle:@"" titleColor:kTextColor backgroundColor:kClearColor titleFont:14];
    self.addressButton.titleLabel.lineBreakMode = 0;
    [self.addressButton addTarget:self action:@selector(addressButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    self.addressButton.titleLabel.text = self.currentModel.address;
    
    [self.addressButton setTitle:self.currentModel.address forState:UIControlStateNormal];
    [contentView addSubview:self.addressButton];
    
    [self.addressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(address.mas_top);
        make.left.equalTo(address.mas_right).offset(20);
        make.right.equalTo(contentView.mas_right).offset(-15);
        make.height.equalTo(@50);
    }];
    
    self.privateButton = [UIButton buttonWithTitle:@"" titleColor:kTextColor backgroundColor:kClearColor titleFont:12];
    NSString *privates;
//    = [[NSUserDefaults standardUserDefaults] objectForKey:KWalletPrivateKey];
//    NSString *word = [[NSUserDefaults standardUserDefaults] objectForKey:KWalletWord];
//    NSString *adress = [[NSUserDefaults standardUserDefaults] objectForKey:KWalletAddress];
    TLDataBase *db = [TLDataBase sharedManager];
    if ([db.dataBase open]) {
         NSString *sql = [NSString stringWithFormat:@"SELECT %@private from THAWallet where userId = '%@'",[self.currentModel.symbol lowercaseString],[TLUser user].userId];
        FMResultSet *set = [db.dataBase executeQuery:sql];
        while ([set next]) {
            privates = [set stringForColumn:[NSString stringWithFormat:@"%@private",self.currentModel.symbol]];
        }
        
        
        NSLog(@"导入钱包交易密码%d",access);
    }
    [db.dataBase close];

    self.privates = privates;
    [self.privateButton setTitle:privates forState:UIControlStateNormal];
    self.privateButton.titleLabel.lineBreakMode = 0;

    [self.privateButton addTarget:self action:@selector(privateButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:self.privateButton];
    
    [self.privateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(private.mas_top);
        make.left.equalTo(private.mas_right).offset(20);
        make.right.equalTo(contentView.mas_right).offset(-15);
        make.height.equalTo(@50);

    }];
    
}

- (void)addressButtonClick
{
    
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    NSString *address ;
    if (self.currentModel.address) {
        address = self.currentModel.address;
    }
    pasteBoard.string = address;
    
    if (pasteBoard == nil) {
        
        [TLAlert alertWithError:@"复制失败, 请重新复制"];
        
    } else {
        
        [TLAlert alertWithSucces:[LangSwitcher switchLang:@"复制成功" key:nil]];
    }
    
}

- (void)privateButtonClick
{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    NSString *address ;
    if (self.privates) {
        address = self.privates;
    }
    pasteBoard.string = address;
    
    if (pasteBoard == nil) {
        
        [TLAlert alertWithError:@"复制失败, 请重新复制"];
        
    } else {
        
        [TLAlert alertWithSucces:[LangSwitcher switchLang:@"复制成功" key:nil]];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    
    　　if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        
        　　}
    [super viewWillDisappear:animated];
    
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
