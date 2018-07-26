//
//  TLGestureVC.m
//  Coin
//
//  Created by shaojianfei on 2018/7/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLGestureVC.h"
#import "ZLGestureLockViewController.h"

@interface TLGestureVC ()

@end

@implementation TLGestureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [LangSwitcher switchLang:@"手势密码" key:nil];
   
//    [self presentViewController:vc animated:YES completion:nil];
    // Do any additional setup after loading the view.
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
