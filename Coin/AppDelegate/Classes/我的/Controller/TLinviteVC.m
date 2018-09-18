//
//  TLinviteVC.m
//  Coin
//
//  Created by shaojianfei on 2018/8/8.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLinviteVC.h"
#import "TLQrCodeVC.h"
#import "RedEnvelopeVC.h"
#import "TLPwdRelatedVC.h"
#import "UIButton+SGImagePosition.h"
#import "PoliteInstructionsVC.h"
#import "NewHtmlVC.h"
#import "AppDelegate.h"
#import <WeiboSDK.h>
@interface TLinviteVC ()<WBMediaTransferProtocol>

@property (nonatomic ,strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UILabel *nameLable;

@property (nonatomic, strong) NSString *h5String;
@property (nonatomic, strong) WBMessageObject *messageObject;
@property (nonatomic, strong) UIAlertController *actionSheetController;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIButton *integralBtn;
@end

@implementation TLinviteVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if ([TLUser user].isLogin) {
      BOOL is =  [[TLUser user] chang];

    }
   
}


//如果仅设置当前页导航透明，需加入下面方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = kHexColor(@"#0848DF");
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = [LangSwitcher switchLang:@"邀请有礼" key:nil];
    self.nameLable = [[UILabel alloc]init];
    self.nameLable.text = [LangSwitcher switchLang:@"邀请有礼" key:nil];
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable.font = Font(18);
    self.nameLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.nameLable;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upInfo) name:@"upsecuees" object:nil];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    UIButton *RightButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:RightButton]];
    [RightButton setImage:kImage(@"more 白色") forState:(UIControlStateNormal)];
    [RightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:(UIControlEventTouchUpInside)];

    [self initUI];

    [self getShareUrl];
    
    // Do any additional setup after loading the view.
}

- (void)upInfo
{
    [self.integralBtn setTitle:@"" forState:UIControlStateNormal];
    NSString *str = [NSString stringWithFormat:@"%@%@%@",[LangSwitcher switchLang:@"您拥有积分" key:nil],[TLUser user].jfAmount,[LangSwitcher switchLang:@"点    马上提币" key:nil]];
    NSString *str1 = [LangSwitcher switchLang:@"您拥有积分" key:nil];
    NSString *str2 = [NSString stringWithFormat:@"%@",[TLUser user].jfAmount];
    NSString *str3 = [LangSwitcher switchLang:@"点" key:nil];
    NSString *str4 = [LangSwitcher switchLang:@"马上提币" key:nil];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:kHexColor(@"#A2A5C4")
                    range:NSMakeRange(0, str1.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:kHexColor(@"#00F7FE")
                    range:NSMakeRange(str1.length, str2.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:kHexColor(@"#A2A5C4")
                    range:NSMakeRange(str1.length + str2.length, str3.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:kHexColor(@"#00F7FE")
                    range:NSMakeRange(str.length - str4.length, str4.length)];
    [self.integralBtn setAttributedTitle:attrStr forState:(UIControlStateNormal)];
    
}

-(void)rightButtonClick
{
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *showAllInfoAction = [UIAlertAction actionWithTitle:[LangSwitcher switchLang:@"邀请有礼说明" key:nil] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PoliteInstructionsVC *vc = [PoliteInstructionsVC new];
        [self.navigationController pushViewController:vc animated:YES];

    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[LangSwitcher switchLang:@"取消" key:nil] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [showAllInfoAction setValue:kHexColor(@"#333333") forKey:@"_titleTextColor"];
    [actionSheetController addAction:showAllInfoAction];
    [actionSheetController addAction:cancelAction];

    self.actionSheetController = actionSheetController;
    [self presentViewController:actionSheetController animated:YES completion:nil];
    UIWindow *alertWindow = (UIWindow *)[UIApplication sharedApplication].windows.lastObject;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAlert)];
    [alertWindow addGestureRecognizer:tap];
}

- (void)hideAlert
{
    UIWindow *alertWindow = (UIWindow *)[UIApplication sharedApplication].windows.lastObject;
    [alertWindow removeGestureRecognizer:self.tap];
    [self.actionSheetController dismissViewControllerAnimated:YES completion:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.actionSheetController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)initUI
{
    UIImageView *bgView = [[UIImageView alloc] init];
    self.bgView = bgView;
    bgView.userInteractionEnabled = YES;
    bgView.contentMode = UIViewContentModeScaleToFill;
    
    bgView.image = kImage(@"邀请bg");
    [self.view addSubview:bgView];
    bgView.frame = CGRectMake(0, -kNavigationBarHeight, kScreenWidth, kScreenHeight);
    
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - kWidth(38), kHeight(kNavigationBarHeight + 16), 76, 103)];
    iconImage.contentMode = UIViewContentModeScaleToFill;
    iconImage.image = kImage(@"logoo");
    [bgView addSubview:iconImage];

    UIImageView *titleBackImage = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(70), kHeight(197 - 64 + kNavigationBarHeight),SCREEN_WIDTH - kWidth(105), kHeight(52))];
    titleBackImage.image = kImage(@"文字背景");
    [bgView addSubview:titleBackImage];


    UILabel *introduceLabel = [UILabel labelWithFrame:CGRectMake(kWidth(23), kHeight(2), SCREEN_WIDTH - kWidth(186), kHeight(36)) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(16) textColor:kHexColor(@"#FFFFFF")];

    introduceLabel.text = [LangSwitcher switchLang:@"全球首款跨链生态钱包" key:nil];
    [titleBackImage addSubview:introduceLabel];


    UIImageView *textBackImage = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(40), kHeight(211 + kNavigationBarHeight), SCREEN_WIDTH - kWidth(80), kHeight(201))];
    textBackImage.image = kImage(@"长框");
    textBackImage.userInteractionEnabled = YES;
    [bgView addSubview:textBackImage];

    UILabel *numberUsersLabel = [UILabel labelWithFrame:CGRectMake(kWidth(15), kHeight(44), SCREEN_WIDTH - kWidth(110), kHeight(22)) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(16) textColor:kHexColor(@"#FFFFFF")];
    numberUsersLabel.text = [NSString stringWithFormat:@"%@ %@ %@",[LangSwitcher switchLang:@"您已成功邀请" key:nil],[TLUser user].jfInviteNumber,[LangSwitcher switchLang:@"名用户" key:nil]];
    [textBackImage addSubview:numberUsersLabel];

    UILabel *ThankYouLabel = [UILabel labelWithFrame:CGRectMake(kWidth(15), kHeight(110), SCREEN_WIDTH - kWidth(110), kHeight(22)) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(16) textColor:kHexColor(@"#FFFFFF")];
    ThankYouLabel.text = [LangSwitcher switchLang:@"感谢您的付出!" key:nil];
    [textBackImage addSubview:ThankYouLabel];

    UIButton *integralBtn = [UIButton buttonWithTitle:@"" titleColor:kHexColor(@"#A2A5C4") backgroundColor:kClearColor titleFont:13];
    self.integralBtn = integralBtn;
    [integralBtn addTarget:self action:@selector(coinClick) forControlEvents:UIControlEventTouchUpInside];
    NSString *str = [NSString stringWithFormat:@"%@%@%@",[LangSwitcher switchLang:@"您拥有积分" key:nil],[TLUser user].jfAmount,[LangSwitcher switchLang:@"点    马上提币" key:nil]];
    NSString *str1 = [LangSwitcher switchLang:@"您拥有积分" key:nil];
    NSString *str2 = [NSString stringWithFormat:@"%@",[TLUser user].jfAmount];
    NSString *str3 =[LangSwitcher switchLang:@"点" key:nil] ;
    NSString *str4 = [LangSwitcher switchLang:@"马上提币" key:nil];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:kHexColor(@"#A2A5C4")
                    range:NSMakeRange(0, str1.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:kHexColor(@"#00F7FE")
                    range:NSMakeRange(str1.length, str2.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:kHexColor(@"#A2A5C4")
                    range:NSMakeRange(str1.length + str2.length, str3.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:kHexColor(@"#00F7FE")
                    range:NSMakeRange(str.length - str4.length, str4.length)];
    [integralBtn setAttributedTitle:attrStr forState:(UIControlStateNormal)];

    integralBtn.frame = CGRectMake(kWidth(15), kHeight(143), SCREEN_WIDTH - kWidth(110), kHeight(18));

    [integralBtn SG_imagePositionStyle:(SGImagePositionStyleRight) spacing:4 imagePositionBlock:^(UIButton *button) {
        [button setImage:[UIImage imageNamed:@"more 亮色"] forState:(UIControlStateNormal)];
    }];
    [textBackImage addSubview:integralBtn];


    UIButton *inviteButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"海报邀请" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:16.0];
    [inviteButton addTarget:self action:@selector(inviteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    inviteButton.frame = CGRectMake(SCREEN_WIDTH/4 - kWidth(60), SCREEN_HEIGHT - kHeight(95), kWidth(120), kHeight(40));
    [inviteButton setBackgroundImage:kImage(@"按钮背景") forState:(UIControlStateNormal)];
    [self.bgView addSubview:inviteButton];

     UIButton *sendInviteButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"红包邀请" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:16.0];
    [sendInviteButton addTarget:self action:@selector(sendinviteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [sendInviteButton setBackgroundImage:kImage(@"按钮背景") forState:(UIControlStateNormal)];
    sendInviteButton.frame = CGRectMake(SCREEN_WIDTH/4*3 - kWidth(60), SCREEN_HEIGHT - kHeight(95), kWidth(120), kHeight(40));
    [self.bgView addSubview:sendInviteButton];

    

}


- (void)inviteButtonClick
{
    TLQrCodeVC *vc = [TLQrCodeVC new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)sendinviteButtonClick
{
    
    RedEnvelopeVC *redEnvelopeVC = [RedEnvelopeVC new];

    [self.navigationController pushViewController:redEnvelopeVC animated:YES];
        
  

}

- (void)getShareUrl
{
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"660917";
    
    http.parameters[@"ckey"] = @"redPacketShareUrl";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.h5String = responseObject[@"data"][@"cvalue"];
        
      
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)coinClick
{
    //
    NSString *shareUrl;
    NSString *lang;
    LangType type = [LangSwitcher currentLangType];
    if (type == LangTypeSimple || type == LangTypeTraditional) {
        lang = @"ZH_CN";
    }else if (type == LangTypeKorean)
    {
        lang = @"KO";
        
        
    }else{
        lang = @"EN";
        
    }
    
    shareUrl = [NSString stringWithFormat:@"%@/luckDraw/luckDraw.html?userId=%@&lang=%@",self.h5String,[TLUser user].userId,lang];
    NewHtmlVC  *h5 = [NewHtmlVC new];
    h5.h5string = shareUrl;
//    [self sinaShare];
//    [TLWXManager shareSinaWeiboWithText:@"theia" image:self.bgImage.image];
//    [TLWXManager wxShareWebPageWithScene:WXSceneSession
//                                   title:@"theia"
//                                    desc:lang
//                                     url:self.h5String];
//    [TLWXManager manager].wxShare = ^(BOOL isSuccess, int errorCode) {
//
//        if (isSuccess) {
//
//            [TLAlert alertWithSucces:@"分享成功"];
//        } else {
//
//            [TLAlert alertWithError:@"分享失败"];
//        }
//    };
    
    [self.navigationController pushViewController:h5 animated:YES];
    
}

- (void)sinaShare {
    self.messageObject = [self messageToShare];
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"www.baidu.com";
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:_messageObject authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    if (![WeiboSDK sendRequest:request]) {
        NSLog(@"打开失败");
    }
}

- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];

    UIImage *image = kImage(@"头像");
  
    NSArray *imageArray = [NSArray arrayWithObjects:image, nil];
    WBImageObject *imageObject = [WBImageObject object];
    imageObject.imageData = UIImageJPEGRepresentation(image, 1.0);
    message.imageObject = imageObject;
    imageObject.delegate = self;
    message.imageObject = imageObject;
    return message;
}


- (void)buttonClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
