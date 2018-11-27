//
//  ZHTabBarController.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLTabBarController.h"

#import "TLNavigationController.h"
#import "TLUserLoginVC.h"
#import "LangSwitcher.h"
#import "UIColor+theme.h"
#import "AppConfig.h"
#import "AppColorMacro.h"
#import "NSBundle+Language.h"
@interface TLTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation TLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    CoinWeakSelf;


    self.delegate = self;

    NSArray *titles = @[
                        [LangSwitcher switchLang:@"资产" key:nil],
                        [LangSwitcher switchLang:@"发现" key:nil],
                        [LangSwitcher switchLang:@"我的" key:nil]
                        ];
    NSArray *VCNames = @[@"TLWalletVC", @"HomeVC", @"TLMineVC"];
    
    NSArray *imageNames = @[@"icon_wallet_48", @"发现", @"我的"];
    NSArray *selectedImageNames = @[@"资产点击", @"发现点击", @"我的点击"];
    
    for (int i = 0; i < imageNames.count; i++) {
        
        if (i == 0 && [AppConfig config].isUploadCheck) {
            
            continue;
        }
       
        [self addChildVCWithTitle:titles[i]
                       controller:VCNames[i]
                      normalImage:imageNames[i]
                    selectedImage:selectedImageNames[i]];
    }
    
//    self.selectedIndex =[AppConfig config].isUploadCheck ? 1 : 2;
    
    //
    UIView *tabBarBgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    tabBarBgView.backgroundColor = [UIColor whiteColor];
    //        //判断点击的Controller是不是需要登录，如果是，那就登录
    
    self.tabBar.backgroundColor = [UIColor whiteColor];
}


- (UIImage *)changImageColorWithImage:(UIImage *)image  color:(UIColor *)targetColor blendModel:(CGBlendMode)mode
{
    //获取画布
    UIGraphicsBeginImageContext(image.size);
    //画笔沾取颜色
    [targetColor setFill];
    
    CGRect drawRect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIRectFill(drawRect);
    [image drawInRect:drawRect blendMode:mode alpha:1];
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



- (void)addChildVCWithTitle:(NSString *)title
                 controller:(NSString *)controllerName
                normalImage:(NSString *)normalImageName
              selectedImage:(NSString *)selectedImageName
{
    Class vcClass = NSClassFromString(controllerName);
    UIViewController *vc = [[vcClass alloc] init];
//    vc.title = title;
    
    //获得原始图片
    UIImage *normalImage = [self getOrgImage:[UIImage imageNamed:normalImageName]];
    UIImage *selectedImage = [self getOrgImage:[UIImage imageNamed:selectedImageName]];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                             image:normalImage
                                                     selectedImage:selectedImage];
//    tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
//    tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 100);
    
    //title颜色
    [tabBarItem setTitleTextAttributes:@{
                                         NSForegroundColorAttributeName : kAppCustomMainColor
                                         } forState:UIControlStateSelected];
    [tabBarItem setTitleTextAttributes:@{
                                         NSForegroundColorAttributeName : [UIColor textColor]
                                         } forState:UIControlStateNormal];
    vc.tabBarItem = tabBarItem;
    TLNavigationController *navigationController = [[TLNavigationController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:navigationController];
    
}

- (UIImage *)getOrgImage:(UIImage *)image {
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}

#pragma mark 判断是否登录若没登录跳转到登录页面
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(nonnull UIViewController *)viewController {
//
//    //赋值更改前的index
//    self.currentIndex = tabBarController.selectedIndex;
//    return YES;
//
//}


- (BOOL)tabBarController:(UITabBarController*)tabBarController shouldSelectViewController:(UIViewController*)viewController

{
//    if (viewController ==self.viewControllers[2]) {
//        if([TLUser user].isLogin == NO) {
//
//            [TLAlert alertWithTitle:[LangSwitcher switchLang:@"提示" key:nil] msg:[LangSwitcher switchLang:@"您还未登录，是否前去登录" key:nil] confirmMsg:[LangSwitcher switchLang:@"确认" key:nil] cancleMsg:[LangSwitcher switchLang:@"取消" key:nil] cancle:^(UIAlertAction *action) {
//
//            } confirm:^(UIAlertAction *action) {
//                TheInitialVC *vc = [[TheInitialVC alloc]init];
//                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//                UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
//                [rootViewController presentViewController:nav animated:YES completion:nil];
//            }];
//
//
//            return NO;
//        }else
//        {
//            return YES;
//        }
//    }
    return YES;
    
    
}


//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
//
//    CoinWeakSelf;
//
//    NSInteger idx = tabBarController.selectedIndex;
//
//    if ([AppConfig config].isUploadCheck) {
//
//
//
//
//
//
////        //判断点击的Controller是不是需要登录，如果是，那就登录
////        if((idx == 0) && ![TLUser user].isLogin) {
////
////            TLUserLoginVC *loginVC = [TLUserLoginVC new];
////
////            loginVC.loginSuccess = ^{
////
////                weakSelf.selectedIndex = idx;
////
////            };
////
////            TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
////            [self presentViewController:nav animated:YES completion:nil];
////            self.selectedIndex = idx;
////
////        }
//
//    } else {
//
//        //判断点击的Controller是不是需要登录，如果是，那就登录
////        if((idx == 1 || idx == 2) && ![TLUser user].isLogin) {
////
////            TLUserLoginVC *loginVC = [TLUserLoginVC new];
////
////            loginVC.loginSuccess = ^{
////
////                weakSelf.selectedIndex = idx;
////
////            };
////
////            TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
////            [self presentViewController:nav animated:YES completion:nil];
//
////        if((idx == 0) && ![TLUser user].isLogin) {
////
////            TLUserLoginVC *loginVC = [TLUserLoginVC new];
////
////            loginVC.loginSuccess = ^{
////
////                weakSelf.selectedIndex = idx;
////
////            };
////
////            TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
////            [self presentViewController:nav animated:YES completion:nil];
////            self.selectedIndex = idx;
////
////        }
//
////        }
//
//    }
//
//}

#pragma mark - IM
//- (void)pushToChatViewControllerWith:(IMAUser *)user
//{
//    NavigationViewController *curNav = (NavigationViewController *)[[self viewControllers] objectAtIndex:self.selectedIndex];
//    if (self.selectedIndex == 2)
//    {
//        // 选的中会话tab
//        // 先检查当前栈中是否聊天界面
//        NSArray *array = [curNav viewControllers];
//        for (UIViewController *vc in array)
//        {
//            if ([vc isKindOfClass:[IMAChatViewController class]])
//            {
//                // 有则返回到该界面
//                IMAChatViewController *chat = (IMAChatViewController *)vc;
//                [chat configWithUser:user];
//                //                chat.hidesBottomBarWhenPushed = YES;
//                [curNav popToViewController:chat animated:YES];
//                return;
//            }
//        }
////#if kTestChatAttachment
////        // 无则重新创建
////        ChatViewController *vc = [[CustomChatUIViewController alloc] initWith:user];
////#else
//        ChatViewController *vc = [[IMAChatViewController alloc] initWith:user];
////#endif
//        
//        if ([user isC2CType])
//        {
//            TIMConversation *imconv = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:user.userId];
//            if ([imconv getUnReadMessageNum] > 0)
//            {
//                [vc modifySendInputStatus:SendInputStatus_Send];
//            }
//        }
//        
//        vc.hidesBottomBarWhenPushed = YES;
//        [curNav pushViewController:vc withBackTitle:@"返回" animated:YES];
//    }
//    else
//    {
//        NavigationViewController *chatNav = (NavigationViewController *)[[self viewControllers] objectAtIndex:0];
//        
////#if kTestChatAttachment
////        // 无则重新创建
////        ChatViewController *vc = [[CustomChatUIViewController alloc] initWith:user];
////#else
//        ChatViewController *vc = [[IMAChatViewController alloc] initWith:user];
////#endif
//        vc.hidesBottomBarWhenPushed = YES;
//        [chatNav pushViewController:vc withBackTitle:@"返回" animated:YES];
//        
//        [self setSelectedIndex:2];
//        self.currentIndex = 2;
//        
//        if (curNav.viewControllers.count != 2)
//        {
//            [curNav popToRootViewControllerAnimated:YES];
//        }
//        
//    }
//}
@end
