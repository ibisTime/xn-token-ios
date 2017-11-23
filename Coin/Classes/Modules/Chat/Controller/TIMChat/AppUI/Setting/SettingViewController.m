//
//  SetupController.m
//  TIMChat
//
//  Created by wilderliao on 16/2/16.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "SettingViewController.h"

#import "BlackListViewController.h"

#import "NotifySetupController.h"

#import "TLSSDK/TLSHelper.h"

#import "QALSDK/QalSDKProxy.h"

@interface HostInfoView : UIView
{
@protected
    UIView          *_hostContentBack;
    UIImageView     *_hostIcon;
    UILabel         *_hostName;
    UILabel         *_hostID;
    
@protected
    __weak IMAHost  *_host;
}

- (void)update;
@end


@implementation HostInfoView

- (instancetype)initWithHost:(IMAHost *)host
{
    if (self = [super init])
    {
        _host = host;
        [self configOwnViews];
    }
    return self;
}

- (void)update
{
    [self configOwnViews];
}

- (void)addOwnViews
{
    _hostContentBack = [[UIView alloc] init];
    _hostContentBack.backgroundColor = kWhiteColor;
    [self addSubview:_hostContentBack];
    
    _hostIcon = [[UIImageView alloc] init];
    _hostIcon.userInteractionEnabled = YES;
    [_hostContentBack addSubview:_hostIcon];
    
    _hostName = [[UILabel alloc] init];
    _hostName.userInteractionEnabled = YES;
    _hostName.font = kAppLargeTextFont;
    [_hostContentBack addSubview:_hostName];
    
    _hostID = [[UILabel alloc] init];
    _hostID.font = kAppMiddleTextFont;
    _hostID.textColor = kGrayColor;
    _hostID.userInteractionEnabled = YES;
    [_hostContentBack addSubview:_hostID];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickHost:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    
}

- (void)onClickHost:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        MyProfileViewController *vc = [[MyProfileViewController alloc] initWith:_host];
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
    }
}

- (void)configOwnViews
{
    if (_host)
    {
        [_hostIcon sd_setImageWithURL:[_host showIconUrl] placeholderImage:kDefaultUserIcon];
        
        _hostName.text = [_host showTitle];
        
        _hostID.text = [NSString stringWithFormat:@"帐号ID：%@", [_host userId]];
    }
}

- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.bounds;
    
    rect = CGRectInset(rect, 0, (rect.size.height - 60)/2);
    _hostContentBack.frame = rect;
    
    [_hostIcon sizeWith:CGSizeMake(60 - 2 * kDefaultMargin, 60 - 2 * kDefaultMargin)];
    [_hostIcon layoutParentVerticalCenter];
    [_hostIcon alignParentLeftWithMargin:20];
    
    [_hostName sizeWith:CGSizeMake(rect.size.width, 28)];
    [_hostName alignTop:_hostIcon];
    [_hostName layoutToRightOf:_hostIcon margin:kDefaultMargin];
    [_hostName scaleToParentRightWithMargin:kDefaultMargin];
    
    [_hostID sameWith:_hostName];
    [_hostID layoutBelow:_hostName];
    [_hostID scaleToBelowOf:_hostIcon];
}

@end

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)dealloc
{
    [[IMAPlatform sharedInstance].contactMgr removeContactChangedObser:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    HostInfoView *info = (HostInfoView *)_tableView.tableHeaderView;
    [info update];
}

- (void)addIMListener
{
    [[IMAPlatform sharedInstance].contactMgr addContactChangedObserver:self handler:@selector(onBlackListChanged:) forEvent:EIMAContact_BlackListEvents];
}

- (void)onBlackListChanged:(NSNotification *)notify
{
    dispatch_async(dispatch_get_main_queue(), ^{
        IMAContactChangedNotifyItem *item = (IMAContactChangedNotifyItem *) notify.object;
        
        
        switch (item.type)
        {
            case EIMAContact_BlackListAddIn:
            case EIMAContact_BlackListMoveOut:
            {
                RichCellMenuItem *item = [self getItemWithKey:@"黑名单"];
                
                if (item)
                {
                    item.value = [NSString stringWithFormat:@"%d人", (int)[[IMAPlatform sharedInstance].contactMgr.blackList count]];
                    NSIndexPath *index = [self getIndexOfKey:@"黑名单"];
                    if (index)
                    {
                        [self.tableView beginUpdates];
                        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
                        [self.tableView endUpdates];
                    }
                }
            }
                break;
                
            default:
                break;
        }
    });
    
}


- (void)onExit
{
    [[HUDHelper sharedInstance] syncLoading:@"正在退出"];
    [[IMAPlatform sharedInstance] logout:^{
        [[HUDHelper sharedInstance] syncStopLoadingMessage:@"退出成功" delay:2 completion:^{
            [[AppDelegate sharedAppDelegate] enterLoginUI];
        }];
        
    } fail:^(int code, NSString *err) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:IMALocalizedError(code, err) delay:2 completion:^{
            [[AppDelegate sharedAppDelegate] enterLoginUI];
        }];
    }];
}

- (void)addHeaderView
{
    HostInfoView *hostView = [[HostInfoView alloc] initWithHost:[IMAPlatform sharedInstance].host];
    
    [hostView setFrameAndLayout:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    _tableHeader = hostView;
    
    _tableView.tableHeaderView = _tableHeader;
}

- (void)addFooterView
{
    __weak SettingViewController *ws = self;
    UserActionItem *exitGroup = [[UserActionItem alloc] initWithTitle:@"退出登录" icon:nil action:^(id<MenuAbleItem> menu) {
        [ws onExit];
    }];
    exitGroup.normalBack = [UIImage imageWithColor:RGBOF(0xE84A4B) size:CGSizeMake(32, 32)];
    
    UserProfileFooterPanel *footer = [[UserProfileFooterPanel alloc] initWith:@[exitGroup]];
    [footer setFrameAndLayout:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    _tableFooter = footer;
    
    _tableView.tableFooterView = _tableFooter;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = _dataDictionary[@(section)];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)configOwnViews
{
    _dataDictionary = [NSMutableDictionary dictionary];
    
    __weak SettingViewController *ws = self;
    
    NSString *allowType = [[IMAPlatform sharedInstance].host.profile getAllowType];
    RichCellMenuItem *friendApply = [[RichCellMenuItem alloc] initWith:@"好友申请" value:allowType type:ERichCell_TextNext action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onEditFriendApply:menu cell:cell];
    }];
    friendApply.valueAlignment = NSTextAlignmentRight;
    friendApply.tipMargin = 20;
    friendApply.tipColor = kBlackColor;
    friendApply.valueColor = kGrayColor;
    
    RichCellMenuItem *blackFriend = [[RichCellMenuItem alloc] initWith:@"黑名单" value:[NSString stringWithFormat:@"%d人", (int)[[IMAPlatform sharedInstance].contactMgr.blackList count]] type:ERichCell_TextNext action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onCheckBlackList:menu cell:cell];
    }];
    blackFriend.valueAlignment = NSTextAlignmentRight;
    blackFriend.tipMargin = 20;
    blackFriend.tipColor = kBlackColor;
    blackFriend.valueColor = kGrayColor;
    
    RichCellMenuItem *notify = [[RichCellMenuItem alloc] initWith:@"消息通知" value:nil type:ERichCell_TextNext action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onNotifySet:menu cell:cell];
    }];
    notify.tipMargin = 20;
    notify.tipColor = kBlackColor;
    
    [_dataDictionary setObject:@[friendApply, blackFriend, notify] forKey:@(0)];
    
#if kAppStoreVersion
#else
    IMAPlatformConfig *cfg = [IMAPlatform sharedInstance].localConfig;
    
    RichCellMenuItem *testEnv = [[RichCellMenuItem alloc] initWith:@"测试环境" value:nil type:ERichCell_Switch action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onSwitchEnvironment:menu cell:cell];
    }];
    testEnv.tipMargin = 20;
    testEnv.tipColor = kBlackColor;
    testEnv.valueColor = kGrayColor;
    testEnv.switchValue = cfg.environment;
    
    RichCellMenuItem *consoleLog = [[RichCellMenuItem alloc] initWith:@"控制台日志" value:nil type:ERichCell_Switch action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onSwitchConsoleLog:menu cell:cell];
    }];
    consoleLog.tipMargin = 20;
    consoleLog.tipColor = kBlackColor;
    consoleLog.valueColor = kGrayColor;
    consoleLog.switchValue = cfg.enableConsoleLog;
    
    NSString *tip = [cfg getLogLevelTip];
    RichCellMenuItem *logLevel = [[RichCellMenuItem alloc] initWith:@"日志级别" value:tip type:ERichCell_TextNext action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onConsoleLevel:menu cell:cell];
    }];
    logLevel.tipMargin = 20;
    logLevel.tipColor = kBlackColor;
    logLevel.valueAlignment = NSTextAlignmentRight;
    logLevel.valueColor = kGrayColor;
    
    RichCellMenuItem *version = [[RichCellMenuItem alloc] initWith:@"SDK版本号" value:nil type:ERichCell_TextNext action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onVersionShow];
    }];
    version.tipMargin = 20;
    version.tipColor = kBlackColor;
    version.valueColor = kGrayColor;

    
    [_dataDictionary setObject:@[testEnv, consoleLog, logLevel, version] forKey:@(1)];
#endif
}

- (void)onChangeAllowTypeTo:(TIMFriendAllowType)type
{
    IMAHost *host = [IMAPlatform sharedInstance].host;
    if (type == host.profile.allowType)
    {
        [[HUDHelper sharedInstance] tipMessage:@"与当前验证方式相同"];
        return;
    }
    else
    {
        __weak SettingViewController *ws = self;
        
        [host asyncSetAllowType:type succ:^{
            RichCellMenuItem *item = [ws getItemWithKey:@"好友申请"];
            if (item)
            {
                item.value = [host.profile getAllowType];
                NSIndexPath *index = [ws getIndexOfKey:@"好友申请"];
                if (index)
                {
                    [ws.tableView beginUpdates];
                    [ws.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
                    [ws.tableView endUpdates];
                }
            }
        } fail:nil];
    }
}

- (void)onEditFriendApply:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    NSDictionary *dic = [TIMUserProfile allowTypeTips];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    
    __weak SettingViewController *ws = self;
    NSArray *array = [dic allKeys];
    for (NSString *key in array)
    {
        [sheet bk_addButtonWithTitle:key handler:^{
            TIMFriendAllowType type = (TIMFriendAllowType)[(NSNumber *)[dic valueForKey:key] integerValue];
            [ws onChangeAllowTypeTo:type];
        }];
    }
    
    [sheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [sheet showInView:self.view];
}

- (void)onSwitchEnvironment:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"切换环境，下次启动时才生效。" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        RichMenuTableViewCell *rcell = (RichMenuTableViewCell *)cell;
        if (buttonIndex == 1)
        {
            [[IMAPlatform sharedInstance].localConfig chageEnvTo:rcell.onSwitch.on];
        }
        //无论点击确定还是取消，switch按钮都回归原状(因为当前无法生效，需要下次才生效)
        rcell.onSwitch.on = !rcell.onSwitch.on;
        menu.switchValue = rcell.onSwitch.on;
    }];
    [alert show];
}

- (void)onSwitchConsoleLog:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"修改控制台日志，下次启动时才生效。" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        RichMenuTableViewCell *rcell = (RichMenuTableViewCell *)cell;
        if (buttonIndex == 1)
        {
            IMAPlatformConfig *cfg = [IMAPlatform sharedInstance].localConfig;
            [cfg chageEnableConsoleTo:rcell.onSwitch.on];
        }
        rcell.onSwitch.on = !rcell.onSwitch.on;
        menu.switchValue = rcell.onSwitch.on;
    }];
    [alert show];
}


- (void)onConsoleLevel:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    __weak SettingViewController *ws = self;
    UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"修改日志级别，下次启动时才生效。" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        RichMenuTableViewCell *rcell = (RichMenuTableViewCell *)cell;
        if (buttonIndex == 1)
        {
            NSDictionary *dic = [IMAPlatformConfig logLevelTips];
            
            UIActionSheet *sheet = [[UIActionSheet alloc] init];
            
            IMAPlatformConfig *cfg = [IMAPlatform sharedInstance].localConfig;
            NSArray *array = [dic allKeys];
            for (NSString *key in array)
            {
                [sheet bk_addButtonWithTitle:key handler:^{
                    NSInteger level = (NSInteger)[(NSNumber *)[dic valueForKey:key] integerValue];
                    [cfg chageLogLevelTo:level];
                    menu.value = [cfg getLogLevelTip];
                    [rcell configWith:menu];
                }];
            }
            
            [sheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
            [sheet showInView:ws.view];
        }
    }];
    [alert show];
}

- (void)onVersionShow
{
    NSString *imVersion = [[TIMManager sharedInstance] GetVersion];
    NSString *tlsVersion = [[TLSHelper getInstance] getSDKVersion];
    NSString *qalVersion = [[QalSDKProxy sharedInstance] getSDKVer];
    
    NSString *myMessage = [NSString stringWithFormat:@"IMSDK Version:%@\r\nTLSSDK Version:%@\r\nQALSDK Version:%@",imVersion, tlsVersion,qalVersion];
    UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"SDK版本号" message:myMessage cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
    [alert show];
}

- (void)onCheckBlackList:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    BlackListViewController *vc = [[BlackListViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:vc];
}

- (void)onNotifySet:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    [[HUDHelper sharedInstance] syncLoading:@"正在获取APNS设置"];
    
    [[TIMManager sharedInstance] getAPNSConfig:^(TIMAPNSConfig *config){
        
        [[HUDHelper sharedInstance] syncStopLoading];
        
        NotifySetupController *vc = [[NotifySetupController alloc] init:config];
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
        
    } fail:^(int code, NSString *err){
        DebugLog(@"%d%@", code, err);
        [[HUDHelper sharedInstance] syncStopLoadingMessage:@"获取APNS配置失败"];
    }];
}

@end
