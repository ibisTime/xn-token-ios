//
//  TIMTabBarController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/7.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TIMTabBarController.h"

@implementation TIMTabBarController


- (void)viewDidLoad
{
    [super viewDidLoad];
    //会话
    ConversationListViewController *convVC = [[ConversationListViewController alloc] init];
    NavigationViewController *convNVC = [[NavigationViewController alloc] initWithRootViewController:convVC];
    convNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"会话" image:kIconConversationNormal selectedImage:kIconConversationHover];
    
    //联系人
    ContactListViewController *contVC = [[ContactListViewController alloc] init];
    NavigationViewController *contNVC = [[NavigationViewController alloc] initWithRootViewController:contVC];
    contNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"联系人" image:kIconContactsNormal selectedImage:kIconContactsHover];
    
//#if kTestChatAttachment
//    TestChatAttachmentViewController *setupVC = [[TestChatAttachmentViewController alloc] init];
//#else
    //设置
    SettingViewController *setupVC = [[SettingViewController alloc] initWith:[IMAPlatform sharedInstance].host];
//    
//#endif
    NavigationViewController *setupNVC = [[NavigationViewController alloc] initWithRootViewController:setupVC];
    setupNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:kIconSetupNormal selectedImage:kIconSetupHover];
    
    
    self.tabBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    [self setViewControllers:@[convNVC, contNVC, setupNVC]];
}


- (void)pushToChatViewControllerWith:(IMAUser *)user
{
    NavigationViewController *curNav = (NavigationViewController *)[[self viewControllers] objectAtIndex:self.selectedIndex];
    if (self.selectedIndex == 0)
    {
        // 选的中会话tab
        // 先检查当前栈中是否聊天界面
        NSArray *array = [curNav viewControllers];
        for (UIViewController *vc in array)
        {
            if ([vc isKindOfClass:[IMAChatViewController class]])
            {
                // 有则返回到该界面
                IMAChatViewController *chat = (IMAChatViewController *)vc;
                [chat configWithUser:user];
                //                chat.hidesBottomBarWhenPushed = YES;
                [curNav popToViewController:chat animated:YES];
                return;
            }
        }
#if kTestChatAttachment
        // 无则重新创建
        ChatViewController *vc = [[CustomChatUIViewController alloc] initWith:user];
#else
        ChatViewController *vc = [[IMAChatViewController alloc] initWith:user];
#endif
        
        if ([user isC2CType])
        {
            TIMConversation *imconv = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:user.userId];
            if ([imconv getUnReadMessageNum] > 0)
            {
                [vc modifySendInputStatus:SendInputStatus_Send];
            }
        }
        
        vc.hidesBottomBarWhenPushed = YES;
        [curNav pushViewController:vc withBackTitle:@"返回" animated:YES];
    }
    else
    {
        NavigationViewController *chatNav = (NavigationViewController *)[[self viewControllers] objectAtIndex:0];
        
#if kTestChatAttachment
        // 无则重新创建
        ChatViewController *vc = [[CustomChatUIViewController alloc] initWith:user];
#else
        ChatViewController *vc = [[IMAChatViewController alloc] initWith:user];
#endif
        vc.hidesBottomBarWhenPushed = YES;
        [chatNav pushViewController:vc withBackTitle:@"返回" animated:YES];
        
        [self setSelectedIndex:0];
        
        if (curNav.viewControllers.count != 0)
        {
            [curNav popToRootViewControllerAnimated:YES];
        }
        
    }
}

@end
