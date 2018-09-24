//
//  RedEnvelopeShoreVC.m
//  Coin
//
//  Created by QinBao Zheng on 2018/7/2.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "RedEnvelopeShoreVC.h"
#import "RedEnvelopeShoreView.h"
#import "RedEnvelopeHeadView.h"
#import "InvitationView.h"
#import "ZJAnimationPopView.h"
#import "UIImageView+WebCache.h"
#import "MySugarPacketsVC.h"
#import "TLMyRecordVC.h"
@interface RedEnvelopeShoreVC ()<RedEnvelopeHeadDelegate>
{
}
@property (nonatomic , strong)InvitationView *invitationView;
@property (nonatomic , strong)UIImageView *headImage;
@property (nonatomic , strong)UIButton *shoreButton;
@property (nonatomic , strong) UILabel *detailedLabel;
@property (nonatomic , strong) UIButton *backbButton;

@end

@implementation RedEnvelopeShoreVC

#pragma mark -- 二维码View懒加载
-(InvitationView *)invitationView
{
    if (!_invitationView) {
        _invitationView = [[InvitationView alloc]initWithFrame:CGRectMake(kScreenWidth/3, SCREEN_HEIGHT, SCREEN_WIDTH - 60, SCREEN_WIDTH + 40)];
        _invitationView.backgroundColor = kHexColor(@"#8F000000");
        _invitationView.layer.masksToBounds = YES;
        _invitationView.layer.cornerRadius = 10;
        CoinWeakSelf;
        _invitationView.codeblock = ^{
          
        };
    }
    return _invitationView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    //kHexColor(@"#777777")
    [self getShareUrl];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-75, kStatusBarHeight+5, 150, 44)];
    label.text = [LangSwitcher switchLang:@"Theia红包" key:nil];
    label.textColor = kTextBlack;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    self.navigationItem.titleView = label;

    RedEnvelopeShoreView *shoreView = [[RedEnvelopeShoreView alloc]initWithFrame:self.view.frame];
    self.shoreVie = shoreView;
//    [shoreView addSubview:label];
    CoinWeakSelf;
    shoreView.shareBlock = ^(NSInteger inter) {
        [weakSelf shareWithTag:inter];
    };
    
    shoreView.redPackBlock = ^{
        if ([_state isEqualToString:@"100"]) {
            NSInteger index = (NSInteger)[[self.navigationController viewControllers] indexOfObject:self];
            if (index > 2) {
//                返回到红包记录页面
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }


        }else
        {
            MySugarPacketsVC *vc = [[MySugarPacketsVC alloc]init];
            vc.isSend = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }

//        UINavigationController * navigation = [[UINavigationController alloc]initWithRootViewController:vc];
//        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//        vc.modalPresentationStyle = UIModalTransitionStyleFlipHorizontal;
//        [self presentViewController:navigation animated:NO completion:nil];
//        MySugarPacketsVC *vc = [[MySugarPacketsVC alloc]init];
//        UINavigationController * navigation = [[UINavigationController alloc]initWithRootViewController:vc];
//        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//        vc.modalPresentationStyle = UIModalTransitionStyleFlipHorizontal;
//        [self presentViewController:navigation animated:NO completion:nil];
    };
//    [shoreView addSubview:self.backbButton];

//    shoreView.content = self.content;
//    shoreView.detailedLabel.text = self.content;
    [shoreView.shoreButton addTarget:self action:@selector(shoreButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:shoreView];

    RedEnvelopeHeadView *headView = [[RedEnvelopeHeadView alloc]initWithFrame:CGRectMake(0, kStatusBarHeight+55, SCREEN_WIDTH, 44)];
    headView.nameLabel.text = [LangSwitcher switchLang:@"分享" key:nil];
    headView.recordButton.hidden = YES;
    headView.delegate = self;
    [shoreView addSubview:headView];

    [self.view addSubview:self.invitationView];
   
    
}
- (void)shareWithTag: (NSInteger)inter
{
//    (kWidth(20), kHeight(116-30), kWidth(335), kHeight(434))
    
    switch (inter) {
        case 0:
        {
            
            UIGraphicsBeginImageContextWithOptions(self.shoreVie.backImg.bounds.size, NO, [[UIScreen mainScreen] scale]);
//            UIGraphicsBeginImageContextWithOptions(self.shoreVie.backImg.bounds.size), NO, [self.shoreVie.backImg scale]);
            [self.shoreVie.backImg.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [TLWXManager wxShareImgWith:@"" scene:0 desc:nil image:viewImage];
//            [[TLWXManager manager] setWxShare:^(BOOL isSuccess, int errorCode) {
//
//                if (isSuccess) {
//
//                    [TLAlert alertWithInfo:@"分享成功"];
//
//                } else {
//
//                    [TLAlert alertWithInfo:@"分享失败"];
//
//                }
//
//            }];
            
        }
            break;
        case 1:
        {
            UIGraphicsBeginImageContextWithOptions(self.shoreVie.backImg.bounds.size, NO, [[UIScreen mainScreen] scale]);
            [self.shoreVie.backImg.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [TLWXManager wxShareImgWith:@"" scene:1 desc:nil image:viewImage];
//            [[TLWXManager manager] setWxShare:^(BOOL isSuccess, int errorCode) {
//                
//                if (isSuccess) {
//                    
//                    [TLAlert alertWithInfo:@"分享成功"];
//                    
//                } else {
//                    
//                    [TLAlert alertWithInfo:@"分享失败"];
//                    
//                }
//                
//            }];
        }
            break;
        case 2:
        {
           UIGraphicsBeginImageContextWithOptions(self.shoreVie.backImg.bounds.size, NO, [[UIScreen mainScreen] scale]);
            [self.shoreVie.backImg.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [TLWBManger sinaShareWithImage:viewImage];
        }
            break;
        case 3:
        {
            [TLAlert alertWithSucces:[LangSwitcher switchLang:@"保存成功!" key:nil]];
            UIGraphicsBeginImageContextWithOptions(self.shoreVie.backImg.bounds.size, NO, [[UIScreen mainScreen] scale]);
            [self.shoreVie.backImg.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
            
        }
            break;
            
        default:
            break;
    }
    
    
//    CGRectMake(kWidth(20), kHeight(116-30), kWidth(335), kHeight(434))
    
}

- (void)buttonMethodClick
{
    
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getShareUrl
{
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"660917";
    
    http.parameters[@"ckey"] = @"redPacketShareUrl";
    
    [http postWithSuccess:^(id responseObject) {
        
        _invitationView.h5String = responseObject[@"data"][@"cvalue"];
        
        NSDictionary *dic = @{@"code":_code};
        NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:dic];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        [self shoreButtonClick];
    } failure:^(NSError *error) {
        
    }];
    
    
}
-(void)shoreButtonClick
{
    
    
    _invitationView.frame = CGRectMake(kScreenWidth/2 - 210/2, kHeight(130), 173,173+60);
    
    
    [self showPopAnimationWithAnimationStyle:2];
    
   
}

#pragma mark -- 显示弹框
- (void)showPopAnimationWithAnimationStyle:(NSInteger)style
{
    ZJAnimationPopStyle popStyle = (style == 8) ? ZJAnimationPopStyleCardDropFromLeft : (ZJAnimationPopStyle)style;
    ZJAnimationDismissStyle dismissStyle = (ZJAnimationDismissStyle)style;
    // 1.初始化
  ZJAnimationPopView *popView = [[ZJAnimationPopView alloc] initWithCustomView:_invitationView popStyle:popStyle dismissStyle:dismissStyle];
    self.popView = popView;
    // 2.设置属性，可不设置使用默认值，见注解
    // 2.1 显示时点击背景是否移除弹框
    popView.isClickBGDismiss = [_invitationView isKindOfClass:[ZJAnimationPopView class]];
//    popView.isClickBGDismiss = YES;
    // 2.2 显示时背景的透明度
    //    popView.popBGAlpha = 0.5f;
    // 2.3 显示时是否监听屏幕旋转
    popView.isObserverOrientationChange = YES;
    // 2.4 显示时动画时长
    //    popView.popAnimationDuration = 0.8f;
    // 2.5 移除时动画时长
    //    popView.dismissAnimationDuration = 0.8f;

    // 2.6 显示完成回调
    CoinWeakSelf;
    popView.popComplete = ^{
//        [weakSelf.popView addSubview:weakSelf.shoreVie.headImage];
        
//        [self addIconImage];


        NSLog(@"显示完成");
    };
    // 2.7 移除完成回调
    popView.dismissComplete = ^{
        weakSelf.shoreVie.headImage.hidden = NO;
        weakSelf.shoreVie.detailedLabel.hidden = NO;
        weakSelf.shoreVie.shoreButton.hidden = NO;
        weakSelf.shoreVie.nameLabel.hidden = NO;
        weakSelf.shoreVie.stateLabel.hidden = NO;

//        [ self removeIcon];
        NSLog(@"移除完成");
        
    };
    // 4.显示弹框
    [popView pop:self.shoreVie.backImg];
//    [popView pop];
}


- (void)shareQr
{
    
    CGSize s = [UIApplication sharedApplication].keyWindow.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image: didFinishSavingWithError: contextInfo:), nil);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    error ? [TLAlert alertWithError:[LangSwitcher switchLang:@"保存失败" key:nil]] : [TLAlert alertWithSucces:[LangSwitcher switchLang:@"保存成功" key:nil]];
}

-(void)RedEnvelopeHeadButton:(NSInteger)tag
{
    [self.navigationController popViewControllerAnimated:YES];

}



- (void)viewWillAppear:(BOOL)animated{

    self.shoreVie.content = self.content;
    self.shoreVie.detailedLabel.text = self.content;
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;


}

//如果仅设置当前页导航透明，需加入下面方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

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
