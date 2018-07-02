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
@interface RedEnvelopeShoreVC ()<RedEnvelopeHeadDelegate>
{
    ZJAnimationPopView *popView;
}
@property (nonatomic , strong)InvitationView *invitationView;
@end

@implementation RedEnvelopeShoreVC

#pragma mark -- 二维码View懒加载
-(InvitationView *)invitationView
{
    if (!_invitationView) {
        _invitationView = [[InvitationView alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT, SCREEN_WIDTH - 60, SCREEN_WIDTH + 40)];
        _invitationView.backgroundColor = RGB(245, 248, 253);
        _invitationView.layer.masksToBounds = YES;
        _invitationView.layer.cornerRadius = 10;
    }
    return _invitationView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    RedEnvelopeShoreView *shoreView = [[RedEnvelopeShoreView alloc]initWithFrame:self.view.frame];
    [shoreView.shoreButton addTarget:self action:@selector(shoreButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:shoreView];

    RedEnvelopeHeadView *headView = [[RedEnvelopeHeadView alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, SCREEN_WIDTH, 44)];
    headView.nameLabel.text = @"分享";
    headView.recordButton.hidden = YES;
    headView.delegate = self;
    [shoreView addSubview:headView];

    [self.view addSubview:self.invitationView];
    NSDictionary *dic = @{@"code":_code};
    NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

-(void)shoreButtonClick
{
    NSLog(@"123");
    _invitationView.frame = CGRectMake(30, 100, SCREEN_WIDTH - 60, SCREEN_WIDTH + 40);
    [self showPopAnimationWithAnimationStyle:2];
}

#pragma mark -- 显示弹框
- (void)showPopAnimationWithAnimationStyle:(NSInteger)style
{
    ZJAnimationPopStyle popStyle = (style == 8) ? ZJAnimationPopStyleCardDropFromLeft : (ZJAnimationPopStyle)style;
    ZJAnimationDismissStyle dismissStyle = (ZJAnimationDismissStyle)style;
    // 1.初始化
    popView = [[ZJAnimationPopView alloc] initWithCustomView:_invitationView popStyle:popStyle dismissStyle:dismissStyle];

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
    popView.popComplete = ^{
        NSLog(@"显示完成");
    };
    // 2.7 移除完成回调
    popView.dismissComplete = ^{
        NSLog(@"移除完成");
    };
    // 4.显示弹框
    [popView pop];
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
