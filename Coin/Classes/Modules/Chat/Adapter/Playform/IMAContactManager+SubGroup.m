//
//  IMAContactManager+SubGroup.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/2.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAContactManager+SubGroup.h"

@implementation IMAContactManager (SubGroup)

#define kSubGroupConfig     @"kSubGroupConfig"


//static NSString *const kCurrentSubGroupListTime = @"kCurrentSubGroupListTime";
//
//- (NSInteger)currentSubGroupListTime
//{
////    [NSUserDefaults standardUserDefaults]
//}
//
//- (void)setCurrentSubGroupListTime
//{
//    objc_setAssociatedObject(self, (__bridge const void *)kPresentedTransitionKey, kPresentingTransitionKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}


- (void)createSubGroupList:(NSArray *)array
{
    NSString * log1 = [NSString stringWithFormat:@"array = %ld,fun = %s",(long)array.count, __func__];
    [[TIMManager sharedInstance] log:TIM_LOG_ERROR tag:@"ui crash" msg:log1];
    
    if (!_subGroupList)
    {
        _subGroupList = [[CLSafeMutableArray alloc] init];
    }
    else
    {
        [_subGroupList removeAllObjects];
    }
    
    for (TIMFriendGroupWithProfiles *group in array)
    {
        IMASubGroup *sg = [[IMASubGroup alloc] initWith:group];
        [_subGroupList addObject:sg];
    }
    
    // 从本地加载分组展开状态
     [self syncSubGroupStateInLocal];
    
    //刷新一下所有分组
    if (self.contactChangedCompletion)
    {
        IMAContactChangedNotifyItem *item = [[IMAContactChangedNotifyItem alloc] initWith:EIMAContact_SubGroupReloadAll];
        self.contactChangedCompletion(item);
    }
    
    
    // 更新会话列表中的内容
    [[IMAPlatform sharedInstance].conversationMgr updateOnAsyncLoadContactComplete];
    NSString * log2 = [NSString stringWithFormat:@"subGroupList.count = %ld,fun = %s",(long)_subGroupList.count, __func__];
    [[TIMManager sharedInstance] log:TIM_LOG_ERROR tag:@"ui crash" msg:log2];
}

- (void)syncSubGroupStateInLocal
{
    // 用帐号作存储名
    NSString *subGroupConfig = [self contactStateSaveKey];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:subGroupConfig];
    
    if (data)
    {
        NSArray *ja = [data objectFromJSONData];
        NSMutableArray *array = [NSObject loadItem:[IMASubGroup class] fromArrayDictionary:ja];
        
        for (IMASubGroup *sg in array)
        {
            NSInteger idx = [_subGroupList indexOfObject:sg];
            if (idx >= 0 && idx < _subGroupList.count)
            {
                IMASubGroup *sgr = [_subGroupList objectAtIndex:idx];
                [sgr syncFoldOf:sg];
            }
        }
        NSLog(@"subGroupList.count = %ld,fun = %s",(long)_subGroupList.count, __func__);
    }
    
}

- (NSString *)contactStateSaveKey
{
    return [NSString stringWithFormat:@"%@_SubGroupState", [[IMAPlatform sharedInstance].host userId]];
}

- (void)saveSubGroupStateInfoToLocal
{
    NSInteger count = _subGroupList.count;
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i++)
    {
        IMASubGroup *gr = [_subGroupList objectAtIndex:i];
        NSDictionary *dic = @{@"name" : gr.name, @"isFold" : @(gr.isFold)};
        [array addObject:dic];
    }
    
    
    if ([NSJSONSerialization isValidJSONObject:array])
    {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
        if(error)
        {
            DebugLog(@"[%@] save Json Error: %@", [self class], array);
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:[self contactStateSaveKey]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    else
    {
        DebugLog(@"[%@] Post Json is not valid: %@", [self class], array);
    }
}


- (IMASubGroup *)defaultAddToSubGroup
{
    // 返回我的好友分组
    IMASubGroup *temp = [[IMASubGroup alloc] initWithName:nil];
    NSInteger idx = [_subGroupList indexOfObject:temp];
    if (idx >= 0 && idx < _subGroupList.count)
    {
        return [_subGroupList objectAtIndex:idx];
    }
    return nil;
}

- (IMASubGroup *)subGroupOf:(IMAUser *)user
{
    for (NSInteger i = 0; i < _subGroupList.count; i++)
    {
        IMASubGroup *sg = [_subGroupList objectAtIndex:i];
        NSInteger index = [sg.friends indexOfObject:user];
        if (index >= 0 && index < sg.friends.count)
        {
            return sg;
        }
    }
    
    return nil;
}

// 异步请求分组列表
- (void)asyncSubGroupList
{
    // 获取分组列表
    NSArray *list = [[TIMFriendshipManager sharedInstance] getFriendGroup:nil];
    NSString * log1 = [NSString stringWithFormat:@"list.count = %ld,fun = %s",(long)list.count, __func__];
    [[TIMManager sharedInstance] log:TIM_LOG_ERROR tag:@"ui crash" msg:log1];
    [self createSubGroupList:list];
    NSString * log2 = [NSString stringWithFormat:@"subGroupList.count = %ld,fun = %s",(long)_subGroupList.count, __func__];
    [[TIMManager sharedInstance] log:TIM_LOG_ERROR tag:@"ui crash" msg:log2];
}
- (BOOL)isValidSubGroupName:(NSString *)sbName
{
    for (NSInteger i = 0; i < _subGroupList.count; i++)
    {
        IMASubGroup *sg = [_subGroupList objectAtIndex:i];
        if ([sg.name isEqualToString:sbName])
        {
            return NO;
        }
    }
    
    return YES;
}

- (void)asyncCreateSubGroup:(NSString *)sgName succ:(IMASubGroupCompletion)succ fail:(TIMFail)fail
{
    if ([NSString isEmpty:sgName])
    {
        DebugLog(@"参数sgName不能为空");
        return;
    }
    
    __weak IMAContactManager *ws = self;
    [[TIMFriendshipManager sharedInstance] createFriendGroup:@[sgName] users:nil succ:^(NSArray *array) {
        IMASubGroup *sub = [[IMASubGroup alloc] initWithName:sgName];
        [ws onAddNewSubGroup:sub];
        
        if (succ)
        {
            succ(sub);
        }
        
    } fail:^(int code, NSString *msg) {
        DebugLog(@"Fail:-->code=%d,msg=%@,fun=%s", code, msg,__func__);
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
        if (fail)
        {
            fail(code,msg);
        }
    }];
}

- (void)asyncDeleteSubGroup:(IMASubGroup *)sg succ:(TIMSucc)succ fail:(TIMFail)fail
{
    if (!sg)
    {
        DebugLog(@"分组不能为空");
        return;
    }
    
    if ([NSString isEmpty:sg.name]) {
        DebugLog(@"不能删除默认分组");
        return;
    }
    
    NSArray *groups = @[sg.name];
    __weak IMAContactManager *ws = self;
    [[TIMFriendshipManager sharedInstance] deleteFriendGroup:groups succ:^{
        [ws onDeleteSubGroup:sg];
        if (succ)
        {
            succ();
        }
    } fail:fail];
}

@end
