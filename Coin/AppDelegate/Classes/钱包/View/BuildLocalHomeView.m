//
//  BuildLocalHomeView.m
//  Coin
//
//  Created by shaojianfei on 2018/7/20.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "BuildLocalHomeView.h"
#import "UILabel+Extension.h"
#import "UILable+convience.h"
#import "AppColorMacro.h"
#import "LangSwitcher.h"
#import <Masonry/Masonry.h>
#import "UIButton+Custom.h"
#import "UIButton+EnLargeEdge.h"



@interface BuildLocalHomeView()



@property (nonatomic ,strong) UILabel *topLable;

@property (nonatomic ,strong) UILabel *bottomLable;

@property (nonatomic ,strong) UIView *topView;

@property (nonatomic ,strong) UIView *bottomView;

@property (nonatomic ,strong) UIImageView *goodImage;

@property (nonatomic ,strong) UIImageView *goodSmallImage;


@property (nonatomic ,strong) UIImageView *badImage;

@property (nonatomic ,strong) UIImageView *badSmallImage;

@property (nonatomic ,strong) UIButton *buildButton;

@property (nonatomic ,strong) UIButton *importButton;

@end
@implementation BuildLocalHomeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //
        [self initSubvies];
        //汇率
        
    }
    return self;
}
- (void)initSubvies
{
    
    self.goodImage = [[UIImageView alloc] init];
    self.goodImage.image = kImage(@"优点");
    [self addSubview:self.goodImage];
    [self.goodImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.left.equalTo(@15);
        make.height.equalTo(@22);
        make.width.equalTo(@22);

        
    }];
    
    self.topLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:16];
    self.topLable.text = [LangSwitcher switchLang:@"优点" key:nil];
    [self addSubview:self.topLable];
    [self.topLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.left.equalTo(@50);
        
    }];
    
    self.topView = [[UIView alloc] init];
    [self addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLable.mas_bottom).offset(10);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.equalTo(@(kHeight(50)));


    }];
    
    
    self.topView.layer.borderWidth = 0.3;
    self.topView.layer.borderColor = kHexColor(@"#ABC0D9").CGColor;
    self.topView.layer.cornerRadius = 4;
    self.topView.clipsToBounds = YES;
    
    self.goodSmallImage = [[UIImageView alloc] init];
    self.goodSmallImage.image = kImage(@"红");
    [self.topView addSubview:self.goodSmallImage];
    [self.goodSmallImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@18);
        make.left.equalTo(@20);
        make.height.equalTo(@12);
        make.width.equalTo(@6);
        
        
    }];
   UILabel *content = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:16];
    content.text = [LangSwitcher switchLang:@"只有用户保存私钥" key:nil];
    [self.topView addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.equalTo(@50);
        
    }];
    
    self.bottomLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:16];
    self.bottomLable.text = [LangSwitcher switchLang:@"缺点" key:nil];
    [self addSubview:self.bottomLable];
    [self.bottomLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(10);
        make.left.equalTo(@50);
        
    }];
    
    self.badImage = [[UIImageView alloc] init];
    self.badImage.image = kImage(@"缺点");
    [self addSubview:self.badImage];
    [self.badImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(10);
        make.left.equalTo(@20);
        make.height.equalTo(@22);
        make.width.equalTo(@22);
        
        
    }];
    
    
    self.bottomView = [[UIView alloc] init];
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.badImage.mas_bottom).offset(20);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.equalTo(@(kHeight(57)));
        
        
    }];
    
    
    self.bottomView.layer.borderWidth = 0.3;
    self.bottomView.layer.borderColor = kHexColor(@"#ABC0D9").CGColor;
    self.bottomView.layer.cornerRadius = 4;
    self.bottomView.clipsToBounds = YES;
    
    
    self.badSmallImage = [[UIImageView alloc] init];
    self.badSmallImage.image = kImage(@"绿");
    [self.bottomView addSubview:self.badSmallImage];
    [self.badSmallImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@20);
        make.height.equalTo(@12);
        make.width.equalTo(@6);
        
        
    }];
    
    UILabel *content1 = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:16];
    content1.text = [LangSwitcher switchLang:@"有矿工费" key:nil];
    [self.bottomView addSubview:content1];
    [content1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.left.equalTo(@50);
    }];
    
    UIImageView *bottmImage = [[UIImageView alloc] init];
    bottmImage.image = kImage(@"绿");
    [self.bottomView addSubview:bottmImage];
    [bottmImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.badSmallImage.mas_bottom).offset(13);
        make.left.equalTo(@20);
        make.height.equalTo(@12);
        make.width.equalTo(@6);
    }];
    
    UILabel *content2 = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:16];
    content2.text = [LangSwitcher switchLang:@"转账速度慢" key:nil];
    [self.bottomView addSubview:content2];
    [content2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(content1.mas_bottom).offset(10);
        make.left.equalTo(@50);
        
    }];
    
    self.buildButton = [UIButton buttonWithImageName:nil cornerRadius:6];
    NSString *text =  [LangSwitcher switchLang:@"创建钱包" key:nil];
    //     = NSLocalizedString(@"创建钱包", nil);
    
    [self.buildButton setTitle:text forState:UIControlStateNormal];
    self.buildButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.buildButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.buildButton addTarget:self action:@selector(buildWallet) forControlEvents:UIControlEventTouchUpInside];
    [self.buildButton setBackgroundColor:kHexColor(@"#FF6953") forState:UIControlStateNormal];
    [self addSubview:self.buildButton];
    [self.buildButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_bottom).offset(20);
        make.right.equalTo(self.mas_right).offset(-15);
        make.left.equalTo(self.mas_left).offset(15);
        make.height.equalTo(@40);
        
    }];
    
    
    self.importButton = [UIButton buttonWithImageName:nil cornerRadius:6];
    NSString *text2 =  [LangSwitcher switchLang:@"导入钱包" key:nil];
    
    //    NSString *text2 = NSLocalizedString(@"导入钱包", nil);
    [self.importButton setTitle:text2 forState:UIControlStateNormal];
    self.importButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.importButton setTitleColor:kHexColor(@"#FF6953") forState:UIControlStateNormal];
    [self.importButton addTarget:self action:@selector(importWallet) forControlEvents:UIControlEventTouchUpInside];
    [self.importButton setBackgroundColor:kWhiteColor forState:UIControlStateNormal];
//    self.importButton.layer.borderColor = (kHexColor(@"#FF6953").CGColor);
//    self.importButton.layer.borderWidth = 1;
    self.importButton.clipsToBounds = YES;
    [self addSubview:self.importButton];
    [self.importButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buildButton.mas_bottom).offset(20);
        make.right.equalTo(self.mas_right).offset(-15);
        make.left.equalTo(self.mas_left).offset(15);
        make.height.equalTo(@40);
        
    }];
}


//创建钱包
- (void)buildWallet
{
    if (self.buildBlock) {
        self.buildBlock();
    }
    
//    self.navigationController.navigationBar.hidden = NO;
//
//    RevisePassWordVC *vc = [[RevisePassWordVC alloc] init];
//    vc.title =  [LangSwitcher switchLang:@"创建钱包" key:nil];
//
//    //    vc.title =  NSLocalizedString(@"创建钱包", nil);
//    [self.navigationController pushViewController:vc animated:YES];
    //    [self presentViewController:vc animated:YES completion:nil];
    
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
//    
//}
//导入钱包
- (void)importWallet
{
    NSLog(@"111");
    if (self.importBlock) {
        self.importBlock();
    }
//    self.navigationController.navigationBar.hidden = NO;
//
//    //    RevisePassWordVC *vc = [[RevisePassWordVC alloc] init];
//    //    vc.title =  [LangSwitcher switchLang:@"创建钱包" key:nil];
//    //    [self.navigationController pushViewController:vc animated:YES];
//    WalletImportVC *vc = [[WalletImportVC alloc] init];
//    vc.title =  [LangSwitcher switchLang:@"导入钱包" key:nil];
//
//    //    vc.title = NSLocalizedString(@"导入钱包", nil);
//    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
