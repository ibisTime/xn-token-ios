//
//  WalletImportVC.m
//  Coin
//
//  Created by shaojianfei on 2018/6/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "WalletImportVC.h"
#import <Masonry.h>
#import "UILabel+Extension.h"
#import "UILable+convience.h"
#import "TLTextView.h"
#import "TLAlert.h"
#import "RevisePassWordVC.h"
@interface WalletImportVC ()<UITextViewDelegate>
@property (nonatomic ,strong) UILabel *nameLable;

@property (nonatomic ,strong) TLTextView *textView;
@property (nonatomic ,strong) UIButton *importButton;
@property (nonatomic ,strong) NSArray *wordArray;
@property (nonatomic ,strong) NSMutableArray *tempArray;
@property (nonatomic ,strong) NSMutableArray *UserWordArray;

@end

@implementation WalletImportVC

- (void)viewDidLoad {
    self.title = [LangSwitcher switchLang:@"导入钱包" key:nil];
    self.view.backgroundColor = kBackgroundColor;
    [self initSub];
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)initSub
{
    self.nameLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15];
    //    self.title = [LangSwitcher switchLang:@"我的" key:nil];
    [self.view addSubview:self.nameLable];
   
    self.nameLable.text = [LangSwitcher switchLang:@"请输入导入的钱包助记词 (12个英文单词)  , 按空格分离" key:nil];
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    // 行间距设置为30
    [paragraphStyle  setLineSpacing:10];
    
    NSString  *testString = self.nameLable.text ;
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:testString];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [testString length])];
    
    // 设置Label要显示的text
    [self.nameLable  setAttributedText:setString];
    self.nameLable.numberOfLines = 0;

    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(23);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);

    }];
    TLTextView *textView = [[TLTextView alloc] initWithFrame:CGRectMake(15, 90, kScreenWidth - 30, 245)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginEdit)];
    [textView addGestureRecognizer:tap];
    self.textView = textView;
    textView.backgroundColor = kWhiteColor;
    textView.textColor = kTextColor;
    textView.font = [UIFont systemFontOfSize:15];
    textView.placholder = [LangSwitcher switchLang:@"请输入导入的钱包助记词" key:nil];
    [self.view addSubview:self.textView];
//    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.nameLable.mas_bottom).offset(28);
//        make.left.equalTo(@15);
//        make.right.equalTo(@-15);
//        make.height.equalTo(@245);
//
//    }];
    self.importButton = [UIButton buttonWithImageName:nil cornerRadius:6];
    NSString *text2 = [LangSwitcher switchLang:@"立即导入" key:nil];
    [self.importButton setTitle:text2 forState:UIControlStateNormal];
    self.importButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.importButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.importButton addTarget:self action:@selector(importNow) forControlEvents:UIControlEventTouchUpInside];
    [self.importButton setBackgroundColor:kAppCustomMainColor forState:UIControlStateNormal];
    self.importButton.layer.borderColor = (kAppCustomMainColor.CGColor);
    self.importButton.layer.borderWidth = 1;
    self.importButton.clipsToBounds = YES;
    [self.view addSubview:self.importButton];
    [self.importButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.height.equalTo(@50);
        
    }];
    
}
- (void)importNow
{
    
    //验证
    self.wordArray = [NSArray array];
    self.wordArray = [self.textView.text componentsSeparatedByString:@" "];
    self.tempArray = [NSMutableArray array];

    for (NSString *str in self.wordArray) {
        if ([str  isEqual: @""]) {
//
        }else{
            
            [self.tempArray addObject:str];
        }
    }
    NSLog(@"%@",self.tempArray);
    if ([self.UserWordArray isEqualToArray:self.tempArray]) {
        
        //验证正确
//        [TLAlert alertWithMsg:@"导入成功"];
        RevisePassWordVC *vc = [[RevisePassWordVC alloc] init];
        vc.IsImport = YES;
        [self.navigationController pushViewController:vc animated:YES];
        //设置交易密码
    }else{
        
        //验证失败
//        [self.navigationController pushViewController:vc animated:YES];

//        [TLAlert alertWithMsg:@"助记词验证成功"];
        RevisePassWordVC *vc = [[RevisePassWordVC alloc] init];
        vc.IsImport = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
    
}
- (void)beginEdit
{
    
    [self.view endEditing:YES];
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
