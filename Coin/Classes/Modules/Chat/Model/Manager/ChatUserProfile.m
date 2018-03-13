//
//  ChatUserProfile.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/31.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "ChatUserProfile.h"

@implementation ChatUserProfile

+ (instancetype)sharedUser {
    
    static ChatUserProfile *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[ChatUserProfile alloc] init];
    });
    
    return manager;
}

@end
