//
//  IMASubGroup.m
//  TIMAdapter
//
//  Created by AlexiChen on 16/1/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMASubGroup.h"

@implementation IMASubGroup

- (instancetype)initDefaultSubGroup
{
    if (self = [super init])
    {
        _isFold = YES;
        _friends = [[CLSafeMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)subGroupName
{
    if (self = [super init])
    {
        _name = subGroupName;
        _isFold = YES;
        _friends = [[CLSafeMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWith:(TIMFriendGroupWithProfiles *)group
{
    if (self = [super init])
    {
        _name = group.name;
        _isFold = YES;
        _friends = [[CLSafeMutableArray alloc] init];
        for (TIMUserProfile *u in group.profiles)
        {
            IMAUser *user = [[IMAUser alloc] initWithUserInfo:u];
            [self.friends addObject:user];
        }
    }
    return self;
}


- (BOOL)isDefaultSubGroup
{
    return [NSString isEmpty:_name];
}

- (NSArray *)items
{
    return _friends.safeArray;
}

- (NSInteger)itemsCount
{
    return [_friends count];
}

//- (void)setIsFold:(BOOL)isFold

// 显示的标题
- (NSString *)showTitle
{
    if ([NSString isEmpty:_name])
    {
        return @"我的好友";
    }
    return _name;
}

// 显示图像的地址
- (NSURL *)showIconUrl
{
    return nil;
}

- (BOOL)isEqual:(id)object
{
    BOOL isEqual = [super isEqual:object];
    if (!isEqual)
    {
        if ([object isKindOfClass:[IMASubGroup class]])
        {
            IMASubGroup *sg = (IMASubGroup *)object;
            if ([sg.name isEqualToString:self.name])
            {
                isEqual = YES;
            }
            else
            {
                // 默认分组
                isEqual = [NSString isEmpty:sg.name] && [NSString isEmpty:self.name];
            }
        }
    }
    return isEqual;
}

- (void)setIsFold:(BOOL)isFold
{
    if (_isFold != isFold)
    {
        _isFold = isFold;
        
        [[IMAPlatform sharedInstance].contactMgr saveSubGroupStateInfoToLocal];
    }
}

- (void)syncFoldOf:(IMASubGroup *)sg
{
    _isFold = sg.isFold;
}

@end
