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

@interface TLNavigationController ()

@end

@implementation TLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"返回"];
//    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"返回"];
    
    
//    [self.navigationItem.backBarButtonItem setTitle:@""];
    //
    self.navigationBar.backIndicatorImage = [UIImage imageNamed:@"返回"];
    self.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"返回"];
    
    //
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.barTintColor = [UIColor whiteColor];
    navBar.translucent = NO;
    navBar.tintColor = [UIColor textColor];
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
    
}

@end
