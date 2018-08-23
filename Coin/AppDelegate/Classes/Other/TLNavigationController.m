//
//  TLNavigationController.m
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLNavigationController.h"
//#import "TLUIHeader.h"
#import "UIColor+theme.h"
#import "AppColorMacro.h"
#import "LangSwitcher.h"
@interface TLNavigationController ()

@end

@implementation TLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"返回"];
//    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"返回"];
    
    if (@available(iOS 11.0, *)) {
        
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateNormal];//将title 文字的颜色改为透明
        
    }else {
        
        //隐藏返回按钮的文字
        
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
        
    }
    

    
    //
    UINavigationBar *navBar = [UINavigationBar appearance];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
//                                                         forBarMetrics:UIBarMetricsDefault];
//    [[UIBarButtonItem appearance] setBackButtonBackgroundVerticalPositionAdjustment:10 forBarMetrics:UIBarMetricsDefault];
//    [self.navigationItem.backBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    navBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"返回 白色"];
    [self.navigationController.navigationItem setHidesBackButton:YES];
    navBar.barTintColor = kHexColor(@"#0848DF");
    navBar.translucent = NO;
    navBar.tintColor = kWhiteColor;
    self.navigationController.navigationBar.titleTextAttributes=
  @{NSForegroundColorAttributeName:[UIColor whiteColor],
    NSFontAttributeName:[UIFont systemFontOfSize:16]};

//    __weak typeof (self)weakSelf = self;
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
//    }

}


- (void)popToLast {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:YES];
    
    // 修正push控制器tabbar上移问题
//    if (@available(iOS 11.0, *)){
//
//        // 修改tabBra的frame
//        CGRect frame = self.tabBarController.tabBar.frame;
//
//        frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
//
//        self.tabBarController.tabBar.frame = frame;
//
//    }
}

@end
