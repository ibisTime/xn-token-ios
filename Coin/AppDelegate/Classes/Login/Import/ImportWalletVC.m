//
//  ImportWalletVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/16.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "ImportWalletVC.h"

@interface ImportWalletVC ()<UITextFieldDelegate>

@end

@implementation ImportWalletVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navigationTransparentClearColor];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

-(void)initView
{
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = kImage(@"起始业背景");
    [self.view addSubview:backImage];
    
    UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(13, 175/2 - 64 + kNavigationBarHeight, SCREEN_WIDTH - 26, 20) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:HGboldfont(20) textColor:kWhiteColor];
    nameLabel.text = [LangSwitcher switchLang:@"恢复助记词钱包" key:nil];
    [backImage addSubview:nameLabel];
    
    UILabel *introduceLbl = [UILabel labelWithFrame:CGRectMake(13, 175/2 - 64 + kNavigationBarHeight + 40, SCREEN_WIDTH - 26, 0) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(12) textColor:kWhiteColor];
    introduceLbl.numberOfLines = 0;
    introduceLbl.attributedText = [UserModel ReturnsTheDistanceBetween:[LangSwitcher switchLang:@"请在下方表格中输入12个助记词以恢复钱包，在每个助记词输入完成后按“空格”键可以跳转到下个单词" key:nil]];
    [introduceLbl sizeToFit];
    [backImage addSubview:introduceLbl];
    
    
    
    for (int i = 0; i < 12; i ++) {
        UITextField *textFid = [[UITextField alloc]initWithFrame:CGRectMake(13  + i%3 * ((SCREEN_WIDTH - 41 )/3 + 7.5), - kNavigationBarHeight + introduceLbl.yy + 48 + i/3* (52), (SCREEN_WIDTH - 41)/3, 45)];
        textFid.font = FONT(14);
        if (i == 0) {
            [textFid becomeFirstResponder];
        }
        textFid.keyboardType = UIKeyboardTypeDefault;
        textFid.textColor = kWhiteColor;
        textFid.delegate = self;
        textFid.textAlignment = NSTextAlignmentCenter;
        kViewBorderRadius(textFid, 8, 1, kWhiteColor);
        textFid.tag = 100 + i;
        [self.view addSubview:textFid];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@" "]) {
        
        if (textField.tag != 111) {
            if ([textField.text isEqualToString:@""]) {
                [TLAlert alertWithInfo:@""]
            }
            UITextField *textFid = [self.view viewWithTag:textField.tag + 1];
            [textFid becomeFirstResponder];
        }
        
        return NO;
    }
    return YES;
//    if ([textField.text rangeOfString:@"."].location==NSNotFound) {
//        isHaveDian=NO;
//    }
//    if ([string length]>0)
//    {
//        unichar single=[string characterAtIndex:0];//当前输入的字符
//        if ((single >='0' && single<='9') || single=='.')//数据格式正确
//        {
//            if([textField.text length]==0){
//                if(single == '.'){
//                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
//                    return NO;
//                }
//            }
//            if (single=='.')
//            {
//                if(!isHaveDian)//text中还没有小数点
//                {
//                    isHaveDian=YES;
//                    return YES;
//                }else
//                {
//
//                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
//                    return NO;
//                }
//            }
//
//            return YES;
//        }else{
//            [textField.text stringByReplacingCharactersInRange:range withString:@""];
//            return NO;
//        }
//    }
//    else
//    {
//        return YES;
//    }
    
    
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
