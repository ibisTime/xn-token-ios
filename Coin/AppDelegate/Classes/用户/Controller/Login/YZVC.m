//
//  YZVC.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/19.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "YZVC.h"
#import <MSAuthSDK/MSAuthVCFactory.h>
#import <MSAuthSDK/MSAuthSDK.h>
#import <SecurityGuardSDK/JAQ/SecurityVerification.h>
@interface YZVC ()<MSAuthProtocol>

@end

@implementation YZVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)verifyDidFinishedWithError:(NSError *)error SessionId:(NSString *)sessionId {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
            NSLog(@"验证失败 %@", error);
        } else {
            NSLog(@"验证通过 %@", sessionId);
        }
        [self.navigationController popViewControllerAnimated:YES];
        //将sessionid传到经过app服务器做二次验证
    });
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
