//
//  AppDelegate.h
//  Coin
//
//  Created by  tianlei on 2017/10/31.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : BaseAppDelegate <UIApplicationDelegate>

- (void)pushToChatViewControllerWith:(IMAUser *)user;

//+ (id)sharedAppDelegate;

@end

