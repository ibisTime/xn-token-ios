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
#import "GetTheVC.h"
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
        _invitationView = [[InvitationView alloc]initWithFrame: CGRectMake(kScreenWidth/2 - (SCREEN_WIDTH - 40)/520*760/2/2/3*2 - 20, 60 + 16 + 27.5, (SCREEN_WIDTH - 40)/520*760/2/3*2 , (SCREEN_WIDTH - 40)/520*760/2/3*2 )];
    }
    return _invitationView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    //kHexColor(@"#777777")
    [self getShareUrl];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.backgroundColor = kWhiteColor;
    [self.view addSubview:backView];
    
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
            GetTheVC *vc = [[GetTheVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }

    };

    [self.view addSubview:shoreView];

    RedEnvelopeHeadView *headView = [[RedEnvelopeHeadView alloc]initWithFrame:CGRectMake(0, kStatusBarHeight+55, SCREEN_WIDTH, 44)];
    headView.nameLabel.text = [LangSwitcher switchLang:@"分享" key:nil];
    headView.recordButton.hidden = YES;
    headView.delegate = self;
    [shoreView addSubview:headView];

    [self.shoreVie.backImg addSubview:self.invitationView];
   
    
}


- (void)shareWithTag: (NSInteger)inter
{
//    (kWidth(20), kHeight(116-30), kWidth(335), kHeight(434))
    
    switch (inter) {
        case 0:
        {
            
            UIGraphicsBeginImageContextWithOptions(self.shoreVie.backImg.bounds.size, NO, [[UIScreen mainScreen] scale]);
            [self.shoreVie.backImg.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [TLWXManager wxShareImgWith:@"" scene:0 desc:nil image:viewImage];

            
        }
            break;
        case 1:
        {
            UIGraphicsBeginImageContextWithOptions(self.shoreVie.backImg.bounds.size, NO, [[UIScreen mainScreen] scale]);
            [self.shoreVie.backImg.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [TLWXManager wxShareImgWith:@"" scene:1 desc:nil image:viewImage];

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
        
//        [self shoreButtonClick];
    } failure:^(NSError *error) {
        
    }];
    
    
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
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.translucent = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = item;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    [self navigationTransparentClearColor];

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
