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
        _invitationView = [[InvitationView alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT, SCREEN_WIDTH - 60, SCREEN_WIDTH + 40)];
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
    [self getShareUrl];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-75, kStatusBarHeight+5, 150, 44)];
    label.text = [LangSwitcher switchLang:@"我的红包" key:nil];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    self.backbButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.backbButton.frame = CGRectMake(15, kStatusBarHeight+5, 44, 44);
    [self.backbButton setImage:kImage(@"返回1") forState:(UIControlStateNormal)];
//    [self.backbButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    
    [self.backbButton addTarget:self action:@selector(buttonMethodClick) forControlEvents:(UIControlEventTouchUpInside)];
    // Do any additional setup after loading the view.
    RedEnvelopeShoreView *shoreView = [[RedEnvelopeShoreView alloc]initWithFrame:self.view.frame];
    self.shoreVie = shoreView;
    [shoreView addSubview:label];
    [shoreView addSubview:self.backbButton];

    shoreView.content = self.content;
    shoreView.detailedLabel.text = self.content;
    [shoreView.shoreButton addTarget:self action:@selector(shoreButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:shoreView];

    RedEnvelopeHeadView *headView = [[RedEnvelopeHeadView alloc]initWithFrame:CGRectMake(0, kStatusBarHeight+55, SCREEN_WIDTH, 44)];
    headView.nameLabel.text = [LangSwitcher switchLang:@"分享" key:nil];
    headView.recordButton.hidden = YES;
    headView.delegate = self;
    [shoreView addSubview:headView];

    [self.view addSubview:self.invitationView];
   
    
}

- (void)buttonMethodClick
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    } failure:^(NSError *error) {
        
    }];
    
    
}
-(void)shoreButtonClick
{
    self.shoreVie.headImage.hidden = YES;
    self.shoreVie.detailedLabel.hidden = YES;
    self.shoreVie.shoreButton.hidden = YES;
    self.shoreVie.nameLabel.hidden = YES;
    self.shoreVie.stateLabel.hidden = YES;
    
    _invitationView.frame = CGRectMake(30, kHeight(300), 173,173+60);
    
    
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
    popView.isClickBGDismiss = ![_invitationView isKindOfClass:[ZJAnimationPopView class]];
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
        
        [self addIconImage];
        

        NSLog(@"显示完成");
    };
    // 2.7 移除完成回调
    popView.dismissComplete = ^{
        weakSelf.shoreVie.headImage.hidden = NO;
        weakSelf.shoreVie.detailedLabel.hidden = NO;
        weakSelf.shoreVie.shoreButton.hidden = NO;
        weakSelf.shoreVie.nameLabel.hidden = NO;
        weakSelf.shoreVie.stateLabel.hidden = NO;

        [ self removeIcon];
        NSLog(@"移除完成");
        
    };
    // 4.显示弹框
    [popView pop];
}

- (void)removeIcon
{
    
    
}

- (void)addIconImage
{
    
 
    
    
    self.headImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - kHeight(70)/2, kHeight(170), kHeight(70), kHeight(70))];
    self.headImage.image = kImage(@"圆 按钮");
    [self.popView addSubview:self.headImage];
    
    UIImageView *Image = [[UIImageView alloc]init];
    [Image sd_setImageWithURL: [NSURL URLWithString: [[TLUser user].photo convertImageUrl]] placeholderImage:kImage(@"头像")];
    Image.layer.cornerRadius = 30;
    Image.clipsToBounds = YES;
    [_headImage addSubview:Image];
    [Image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@5);
        make.bottom.right.equalTo(@-5);
    }];
    
    UILabel *introduce = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#FBDDA9") font:14];
    introduce.frame = CGRectMake(kScreenWidth/2-35, self.headImage.yy +2, kHeight(70), kHeight(22));
    introduce.textAlignment = NSTextAlignmentCenter;
    [self.popView addSubview:introduce];
    introduce.text = [TLUser user].nickname;

    UILabel *introduce2 = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:16];
    introduce2.frame = CGRectMake(kWidth(120), introduce.yy , kWidth(150), kHeight(22));
    introduce2.textAlignment = NSTextAlignmentCenter;
    introduce2.text = [LangSwitcher switchLang:@"给您发了一个红包" key:nil];

    [self.popView addSubview:introduce2];
    [introduce2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(introduce.yy));
        make.centerX.equalTo(self.popView.mas_centerX);
        
    }];
    UILabel *introduce3 = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:14];
    
//    introduce3.frame = CGRectMake(kWidth(120), kHeight(456), kScreenWidth - kWidth(120), kHeight(22));
    introduce3.text = [LangSwitcher switchLang:@"扫描二维码领取Theia红包" key:nil];

    introduce3.textAlignment = NSTextAlignmentCenter;
    [self.popView addSubview:introduce3];
    [introduce3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kHeight(456)));
        make.centerX.equalTo(self.popView.mas_centerX);
        
    }];
    UILabel *introduce4 = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:14];
    UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareQr)];
    [introduce4 addGestureRecognizer:ta];
    introduce4.userInteractionEnabled = YES;
    
//    introduce4.frame = CGRectMake(kWidth(120), kHeight(456), kScreenWidth - kWidth(120), kHeight(22));
    introduce4.text = [LangSwitcher switchLang:@"截图分享二维码" key:nil];
    
    introduce4.textAlignment = NSTextAlignmentCenter;
    [self.popView addSubview:introduce4];
    [introduce4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.popView.mas_bottom).offset(-50-(kBottomInsetHeight));
        make.centerX.equalTo(self.popView.mas_centerX);


    }];

}

- (void)shareQr
{
    
    CGSize s = self.view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
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
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.shoreVie.content = self.content;
    self.shoreVie.detailedLabel.text = self.content;
    [self.navigationController setNavigationBarHidden:YES animated:animated];

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
