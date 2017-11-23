//
//  NotifySetupController.m
//  MyDemo
//
//  Created by wilderliao on 15/12/2.
//  Copyright © 2015年 sofawang. All rights reserved.
//

#import "NotifySetupController.h"

@implementation NotifySetupController

- (instancetype)init:(TIMAPNSConfig *)config
{
    if (self = [super init])
    {
        [self configState:config];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"消息通知设置";
    
    [self setupSubviewEnable:_configState.openPush];
}

- (void)configOwnViews
{
    _dataDictionary ? [_dataDictionary removeAllObjects] :(_dataDictionary = [NSMutableDictionary dictionary]);
    

    __weak NotifySetupController *ws = self;
    //开启通知section
    RichCellMenuItem *notifySwitch = [[RichCellMenuItem alloc] initWith:@"开启通知" value:nil type:ERichCell_Switch action:^(RichCellMenuItem *menu, UITableViewCell *cell){
        [ws onNotifySwitch:menu cell:cell];
    }];
    notifySwitch.tipMargin = 20;
    notifySwitch.tipColor = kBlackColor;
    notifySwitch.switchValue = _configState.openPush;
    [_dataDictionary setObject:@[notifySwitch] forKey:@" 开启通知"];
    
    //C2C消息设置
    RichCellMenuItem *c2cOpenSound = [[RichCellMenuItem alloc] initWith:@"开启声音" value:nil type:ERichCell_Switch action:^(RichCellMenuItem *menu, UITableViewCell *cell){
        [ws onC2CSoundConfig:menu cell:cell];
    }];
    c2cOpenSound.tipMargin = 20;
    c2cOpenSound.tipColor = kBlackColor;
    c2cOpenSound.switchValue = _configState.c2cOpenSound;
    
    RichCellMenuItem *c2cOpenShake = [[RichCellMenuItem alloc] initWith:@"开启震动" value:nil type:ERichCell_Switch action:^(RichCellMenuItem *menu, UITableViewCell *cell){
        [ws onC2CShakeConfig:menu cell:cell];
    }];
    c2cOpenShake.tipMargin = 20;
    c2cOpenShake.tipColor = kBlackColor;
    c2cOpenShake.switchValue = _configState.c2cOpenShake;
    [_dataDictionary setObject:@[c2cOpenSound, c2cOpenShake] forKey:@"C2C消息设置"];
    
    //Group消息设置
    RichCellMenuItem *groupOpenSound = [[RichCellMenuItem alloc] initWith:@"开启声音" value:nil type:ERichCell_Switch action:^(RichCellMenuItem *menu, UITableViewCell *cell){
        [ws onGroupSoundConfig:menu cell:cell];
    }];
    groupOpenSound.tipMargin = 20;
    groupOpenSound.tipColor = kBlackColor;
    groupOpenSound.switchValue = _configState.groupOpenSound;
    
    RichCellMenuItem *groupOpenShake = [[RichCellMenuItem alloc] initWith:@"开启震动" value:nil type:ERichCell_Switch action:^(RichCellMenuItem *menu, UITableViewCell *cell){
        [ws onGroupShakeConfig:menu cell:cell];
    }];
    groupOpenShake.tipMargin = 20;
    groupOpenShake.tipColor = kBlackColor;
    groupOpenShake.switchValue = _configState.groupOpenShake;
    [_dataDictionary setObject:@[groupOpenSound, groupOpenShake] forKey:@"Group消息设置"];
}

- (void)onNotifySwitch:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    __weak NotifySetupController *ws = self;
    __weak ConfigState *wc = _configState;
    
    uint32_t openPush = (!menu.switchValue) ? 1 : 2;
    [self setApns:openPush type:nil soundName:nil succ:^{
        
        menu.switchValue = !menu.switchValue;
        ((RichMenuTableViewCell *)cell).onSwitch.on = menu.switchValue;
        
        wc.openPush = menu.switchValue;
        [ws setupSubviewEnable:menu.switchValue];
    }];
}

- (void)onC2CSoundConfig:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    __weak ConfigState *wc = _configState;
    
    NSString *fileName = [self selectFileName:!menu.switchValue shakeSwitchOn:_configState.c2cOpenShake];
    
    [self setApns:0 type:@"c2cSound" soundName:fileName succ:^{
        
        menu.switchValue = !menu.switchValue;
        ((RichMenuTableViewCell *)cell).onSwitch.on = menu.switchValue;
        
        wc.c2cOpenSound = menu.switchValue;
    }];
}

- (void)onC2CShakeConfig:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    __weak ConfigState *wc = _configState;
    
    NSString *fileName = [self selectFileName:_configState.c2cOpenSound shakeSwitchOn:!menu.switchValue];
    
    [self setApns:0 type:@"c2cSound" soundName:fileName succ:^{
        
        menu.switchValue = !menu.switchValue;
        ((RichMenuTableViewCell *)cell).onSwitch.on = menu.switchValue;
        
        wc.c2cOpenShake = menu.switchValue;
    }];
}

- (void)onGroupSoundConfig:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    __weak ConfigState *wc = _configState;
    
    NSString *fileName = [self selectFileName:!menu.switchValue shakeSwitchOn:_configState.groupOpenShake];
    
    [self setApns:0 type:@"groupSound" soundName:fileName succ:^{
        
        menu.switchValue = !menu.switchValue;
        ((RichMenuTableViewCell *)cell).onSwitch.on = menu.switchValue;
        
        wc.groupOpenSound = menu.switchValue;
    }];
}

- (void)onGroupShakeConfig:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    __weak ConfigState *wc = _configState;
    
    NSString *fileName = [self selectFileName:_configState.groupOpenSound shakeSwitchOn:!menu.switchValue];
    
    [self setApns:0 type:@"groupSound" soundName:fileName succ:^{
        
        menu.switchValue = !menu.switchValue;
        ((RichMenuTableViewCell *)cell).onSwitch.on = menu.switchValue;
        
        wc.groupOpenShake = menu.switchValue;
    }];
}

- (void)configState:(TIMAPNSConfig *)config
{
    _configState = [[ConfigState alloc] init];
    
    //设置默认值
    if (config == nil)
    {
        _configState.openPush = NO;
        _configState.c2cOpenSound = NO;
        _configState.c2cOpenShake = NO;
        _configState.groupOpenSound = NO;
        _configState.groupOpenShake = NO;
//        _configState.videoOpenSound = NO;
//        _configState.videoOpenShake = NO;
        return;
    }
    
    _configState.openPush = (config.openPush==1) ? YES : NO;
    
    if ([config.c2cSound isEqualToString:@"00.caf"] || config.c2cSound.length==0)
    {
        _configState.c2cOpenSound = NO;
        _configState.c2cOpenShake = NO;
    }
    else if ([config.c2cSound isEqualToString:@"01.caf"])
    {
        _configState.c2cOpenSound = NO;
        _configState.c2cOpenShake = YES;
    }
    else if ([config.c2cSound isEqualToString:@"10.caf"])
    {
        _configState.c2cOpenSound = YES;
        _configState.c2cOpenShake = NO;
    }
    else if ([config.c2cSound isEqualToString:@"11.caf"])
    {
        _configState.c2cOpenSound = YES;
        _configState.c2cOpenShake = YES;
    }
    
    if ([config.groupSound isEqualToString:@"00.caf"] || config.groupSound.length==0)
    {
        _configState.groupOpenSound = NO;
        _configState.groupOpenShake = NO;
    }
    else if ([config.groupSound isEqualToString:@"01.caf"])
    {
        _configState.groupOpenSound = NO;
        _configState.groupOpenShake = YES;
    }
    else if ([config.groupSound isEqualToString:@"10.caf"])
    {
        _configState.groupOpenSound = YES;
        _configState.groupOpenShake = NO;
    }
    else if ([config.groupSound isEqualToString:@"11.caf"])
    {
        _configState.groupOpenSound = YES;
        _configState.groupOpenShake = YES;
    }
    
//    if ([config.videoSound isEqualToString:@"00.caf"] || config.videoSound.length==0) {
//        _configState.videoOpenSound = NO;
//        _configState.videoOpenShake = NO;
//    }
//    else if ([config.videoSound isEqualToString:@"01.caf"]) {
//        _configState.videoOpenSound = NO;
//        _configState.videoOpenShake = YES;
//    }
//    else if ([config.videoSound isEqualToString:@"10.caf"]) {
//        _configState.videoOpenSound = YES;
//        _configState.videoOpenShake = NO;
//    }
//    else if ([config.videoSound isEqualToString:@"11.caf"]) {
//        _configState.videoOpenSound = YES;
//        _configState.videoOpenShake = YES;
//    }
    
}

- (NSString *)selectFileName:(BOOL)soundOn shakeSwitchOn:(BOOL)shakeOn
{
    if (!soundOn && !shakeOn)
    {
        return @"00.caf";
    }
    else if (!soundOn && shakeOn)
    {
        return @"01.caf";
    }
    else if (soundOn && !shakeOn)
    {
        return @"10.caf";
    }
    else if (soundOn && shakeOn)
    {
        return @"11.caf";
    }
    else
    {
        return nil;
    }
}

- (void)saveObject:(BOOL)obj key:(NSString*)key
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:obj] forKey:key];
}

//openPush:0-不进行设置 1-开启推送 2-关闭推送
- (void)setApns:(uint32_t)openPush type:(NSString *)type soundName:(NSString *)name succ:(TIMSucc)succ
{
    TIMAPNSConfig * apnsConfig = [[TIMAPNSConfig alloc] init];
    apnsConfig.openPush = openPush;
    if ([type isEqualToString:@"c2cSound"])
    {
        apnsConfig.c2cSound = name;
    }
    if ([type isEqualToString:@"groupSound"])
    {
        apnsConfig.groupSound = name;
    }
    if ([type isEqualToString:@"videoSound"])
    {
        apnsConfig.videoSound = name;
    }
    
    [[HUDHelper sharedInstance] syncLoading:@"正在设置"];
    
    [[TIMManager sharedInstance] setAPNS:apnsConfig succ:^()
     {
         [[HUDHelper sharedInstance] syncStopLoading];
         if (succ)
         {
             succ();
         }
     } fail:^(int code, NSString *err)
     {
         DebugLog(@"setAPNS fail %d %@",code , err);
         [[HUDHelper sharedInstance] syncStopLoadingMessage:@"设置失败"];
     }];
}

- (void)setupSubviewEnable:(BOOL)isEnable
{
    NSArray *keys = [_dataDictionary allKeys];
    
    for(NSString *key in keys)
    {
        NSArray *items = (NSArray *)[_dataDictionary objectForKey:key];
        for (RichCellMenuItem *item in items)
        {
            if ([item.tip isEqualToString:@"开启通知"])
            {
                continue;
            }
            item.switchIsEnable = isEnable;
        }
    }
    [_tableView reloadData];
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *keys = [_dataDictionary allKeys];
    NSString *key = keys[section];
    NSArray *array = _dataDictionary[key];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (RichCellMenuItem *)itemOf:(NSIndexPath *)indexPath;
{
    NSArray *keys = [_dataDictionary allKeys];
    NSString *key = keys[indexPath.section];
    NSArray *array = _dataDictionary[key];
    RichCellMenuItem *item = [array objectAtIndex:indexPath.row];
    return item;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray *keys = [_dataDictionary allKeys];
    return keys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerViewId = @"TextTableViewHeaderFooterView";
    TextTableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
    if (!headerView)
    {
        headerView = [[TextTableViewHeaderFooterView alloc] initWithReuseIdentifier:headerViewId];
    }
    
    NSArray *array = [_dataDictionary allKeys];
    
    headerView.tipLabel.text = array[section];
    
    return headerView;
}

@end

@implementation ConfigState

@end
