//
//  ZMAuthVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/26.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "ZMAuthVC.h"
//#import <ZMCert/ZMCert.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "ZMAuthResultVC.h"

#import "TLTextField.h"
#import "NSString+Check.h"
#import "AppMacro.h"

#define IsZMCertVideo false

@interface ZMAuthVC ()

@property (nonatomic, strong) TLTextField *realName;    //真实姓名
@property (nonatomic, strong) TLTextField *idCard;      //身份证

@end

@implementation ZMAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(realNameAuth:) name:@"RealNameAuthResult" object:nil];
    
}

#pragma mark - Init
- (void)initSubviews {
    
    BOOL isRealNameExist = [[TLUser user].realName valid];

    CGFloat leftMargin = 15;
    
    self.realName = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) leftTitle:@"姓名" titleWidth:105 placeholder:@"请输入姓名"];
    
    self.realName.returnKeyType = UIReturnKeyNext;
    
    self.realName.enabled = !isRealNameExist;

    STRING_NIL_NULL([TLUser user].realName);
    
    self.realName.text = [TLUser user].realName;
    
    [self.realName addTarget:self action:@selector(next:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.view addSubview:self.realName];
    
    self.idCard = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.realName.yy + 1, kScreenWidth, 50) leftTitle:@"身份证号码" titleWidth:105 placeholder:@"请输入身份证号码"];
    
    STRING_NIL_NULL([TLUser user].idNo);
    
    self.idCard.text = [TLUser user].idNo;
    
    [self.view addSubview:self.idCard];
    
    
    UIColor *bgColor = isRealNameExist ? kPlaceholderColor: kAppCustomMainColor;

    UIButton *confirmBtn = [UIButton buttonWithTitle:@"人脸识别" titleColor:kWhiteColor backgroundColor:bgColor titleFont:15.0 cornerRadius:45/2.0];
    
    confirmBtn.frame = CGRectMake(leftMargin, self.idCard.yy + 40, kScreenWidth - 2*leftMargin, 45);
    
    confirmBtn.enabled = !isRealNameExist;

    [confirmBtn addTarget:self action:@selector(confirmIDCard:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmBtn];
    
    
}

#pragma mark - Notification

- (void)realNameAuth:(NSNotification *)notification {
    
    [TLUser user].realName = self.realName.text;
    
    [TLUser user].idNo = self.idCard.text;
    
    [[TLUser user] updateUserInfo];
    
    if ([notification.object isEqualToString:@"1"]) {
        
        [TLAlert alertWithSucces:@"认证成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        });

    } else {
    
        [TLAlert alertWithError:@"认证失败, 请重新认证"];
    }
    
}

#pragma mark - Events

- (void)next:(UITextField *)sender {
    
    [self.idCard becomeFirstResponder];
}

- (void)confirmIDCard:(UIButton *)sender {
    
    if (![self.realName.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入姓名"];
        return;
    }
    
    if (![self.idCard.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入身份证号码"];
        return;
    }
    
    if (self.idCard.text.length != 18) {
        
        [TLAlert alertWithInfo:@"请输入18位身份证号码"];
        return;
    }
    
    [self.view endEditing:YES];
    
    //芝麻认证
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805195";
    http.parameters[@"idNo"] = self.idCard.text;
    http.parameters[@"realName"] = self.realName.text;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"returnUrl"] = @"Bcoin://certi.back";
    http.parameters[@"localCheck"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        if ([responseObject[@"errorCode"] isEqual:@"0"]) {
            
            NSString *bizNo = responseObject[@"data"][@"bizNo"];
            
            //不跳支付宝
//                        NSString *merchantID = responseObject[@"data"][@"merchantId"];
//            
//                        [self startAuthWithBizNo:bizNo merchantID:merchantID];
            
            //            [self doVerify:responseObject[@"data"][@"url"]];

            [TLUser user].tempBizNo = bizNo;

            NSString *urlStr = responseObject[@"data"][@"url"];
            
            [self doVerify:urlStr];

        } else {
            
            ZMAuthResultVC *authResultVC = [ZMAuthResultVC new];
            
            authResultVC.title = @"芝麻认证结果";
            
            authResultVC.result = NO;
            
            authResultVC.realName = self.realName.text;
            
            authResultVC.idCard = self.idCard.text;
            
            authResultVC.failureReason = responseObject[@"errorInfo"];
            
            [self.navigationController pushViewController:authResultVC animated:YES];
            
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 不跳支付宝
//- (void)startAuthWithBizNo:(NSString *)bizNo merchantID:(NSString *)merchantID {
//
//    ZMCertification *manager = [[ZMCertification alloc] init];
//    BaseWeakSelf;
//
//#if IsZMCertVideo
//    //  录制动作检测录像
//    [manager startVideoWithBizNO:bizNo
//                      merchantID:merchantID
//                       extParams:@{@"RecordVideo" : [NSNumber numberWithBool:YES]}
//                  viewController:self
//                        onFinish:^(BOOL isCanceled, BOOL isPassed, ZMStatusErrorType errorCode, NSString * _Nullable videoPath) {
//                            if (videoPath) {
//                                ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
//                                [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath]
//                                                                  completionBlock:^(NSURL *assetURL, NSError *error) {
//                                                                      if (error) {
//                                                                          NSLog(@"Save video fail:%@",error);
//                                                                      } else {
//                                                                          NSLog(@"Save video succeed.");
//                                                                      }
//                                                                  }];
//                            }
//
//                            ZMAuthResultVC *authResultVC = [ZMAuthResultVC new];
//
//                            authResultVC.title = @"芝麻认证结果";
//
//                            authResultVC.realName = self.realName.text;
//
//                            authResultVC.idCard = self.idCard.text;
//
//                            if (isCanceled) {
//
//                                authResultVC.result = NO;
//
//                                authResultVC.failureReason = @"用户取消了认证!";
//
//                            } else {
//
//                                if (isPassed) {
//
//                                    authResultVC.result = YES;
//
//                                } else {
//
//
//                                    authResultVC.result = NO;
//
//                                    authResultVC.failureReason = [NSString stringWithFormat:@"认证中出现问题--%zi", errorCode];
//                                }
//                            }
//
//                            [self.navigationController pushViewController:authResultVC animated:YES];
//
//                        }];
//#else
//    //  不进行动作检测视频录制
//    [manager startWithBizNO:bizNo
//                 merchantID:merchantID
//                  extParams:nil
//             viewController:self
//                   onFinish:^(BOOL isCanceled, BOOL isPassed, ZMStatusErrorType errorCode) {
//                       ZMAuthResultVC *authResultVC = [ZMAuthResultVC new];
//
//                       authResultVC.title = @"芝麻认证结果";
//
//                       authResultVC.realName = self.realName.text;
//
//                       authResultVC.idCard = self.idCard.text;
//
//                       if (isCanceled) {
//
//                           authResultVC.result = NO;
//
//                           authResultVC.failureReason = @"用户取消了认证!";
//
//                       } else {
//
//                           if (isPassed) {
//
//                               authResultVC.result = YES;
//
//                           } else {
//
//
//                               authResultVC.result = NO;
//
//                               authResultVC.failureReason = [NSString stringWithFormat:@"认证中出现问题--%zi", errorCode];
//                           }
//                       }
//
//                       [self.navigationController pushViewController:authResultVC animated:YES];
//                   }];
//#endif
//}

#pragma mark - 跳转到支付宝认证
- (void)doVerify:(NSString *)url {
    // 这里使用固定appid 20000067
    
//    NSString *urll = @"https://zmcustprod.zmxy.com.cn/certify/guide.htm?zhima_exterface_invoke_assign_target=0a6eed651503539484955299774875&zhima_exterface_invoke_assig_sign=HaUvFNg30SPE-AGj8cuS_HaKxBNbg8_3Fu6xZ2jTXZ8fhs_b7UbeHOYB1JXAvE75Kfm-3j2Cw0N1k5Q-G0qNO6ky5JcDL3JsfHlJ4CEBkFr_EtVroJ_PKSHTvC7_O-0y7ss1TLwlQ0QZmM3pKMLMX-bkHRzE_eyhttuxzqcty0E";
    
//    NSString *alipayUrl = [NSString stringWithFormat:@"alipayqr://platformapi/startapp?saId=10000007&qrcode=%@",url];
    
    NSString *alipayUrl = [NSString stringWithFormat:@"alipays://platformapi/startapp?appId=20000067&url=%@",
                           [self URLEncodedStringWithUrl:url]];
    
    if ([self canOpenAlipay]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alipayUrl]];
        
        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alipayUrl] options:@{} completionHandler:nil];
        
    } else {
        
        [TLAlert alertWithTitle:@"是否下载并安装支付宝完成认证?" msg:@"" confirmMsg:@"好的" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
            
        } confirm:^(UIAlertAction *action) {
            
            NSString *appstoreUrl = @"itms-apps://itunes.apple.com/app/id333206289";
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstoreUrl]];
            
            //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstoreUrl] options:@{} completionHandler:nil];
            
        }];
        
    }
}

- (NSString *)URLEncodedStringWithUrl:(NSString *)url {
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)url,NULL,(CFStringRef) @"!'();:@&=+$,%#[]|",kCFStringEncodingUTF8));
    
    return encodedString;
}

- (BOOL)canOpenAlipay {
    
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipays://"]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
