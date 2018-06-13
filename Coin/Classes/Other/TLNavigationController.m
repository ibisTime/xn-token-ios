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
    
   
    
    //
    UINavigationBar *navBar = [UINavigationBar appearance];
    NSString *text = [LangSwitcher switchLang:@"返回" key:nil];
    [self.navigationItem.backBarButtonItem setTitle:text];
    
    navBar.backIndicatorImage = [UIImage imageNamed:@"返回"];
    navBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"返回"];
    navBar.barTintColor = [UIColor whiteColor];
    navBar.translucent = NO;
    navBar.tintColor = kAppCustomMainColor;
    [navBar setTitleTextAttributes:@{
                                     NSForegroundColorAttributeName : [UIColor textColor]
                                     }];

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
