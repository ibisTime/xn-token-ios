//
//  PoliteInstructionsVC.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/12.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "PoliteInstructionsVC.h"
#import "UIButton+SGImagePosition.h"
#import "ZJAnimationPopView.h"
#import "BouncedPasteView.h"
@interface PoliteInstructionsVC ()
@property (nonatomic ,strong) UIImageView *bgView;

@property (nonatomic ,strong) ZJAnimationPopView *popView;

@property (nonatomic ,strong)BouncedPasteView *bouncedView;

@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, copy) NSString *h5String;

@end

@implementation PoliteInstructionsVC

-(BouncedPasteView *)bouncedView
{
    if (!_bouncedView) {
        _bouncedView = [[BouncedPasteView alloc]initWithFrame:CGRectMake(kWidth(25), SCREEN_HEIGHT + kNavigationBarHeight , SCREEN_WIDTH - kWidth(50), _bouncedView.pasteButton.yy + kHeight(30))];
        kViewRadius(_bouncedView, 4);
        [_bouncedView.pasteButton addTarget:self action:@selector(pasteButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _bouncedView;
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
//打开微信,去粘贴
-(void)pasteButtonClick
{
    [TLAlert alertWithSucces:[LangSwitcher switchLang:@"复制成功!" key:nil]];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
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
//http://m.thadev.hichengdai.com/user/register.html?inviteCode=U201807030441369491006&lang=ZH_CN
   NSString * address = [NSString stringWithFormat:@"%@/user/register.html?inviteCode=%@&lang=%@",self.h5String,[TLUser user].secretUserId,lang];
    pasteboard.string = address;
}

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
    [self getShareUrl];
    //    self.title = [LangSwitcher switchLang:@"邀请有礼" key:nil];
    self.nameLable = [[UILabel alloc]init];
    self.nameLable.text = [LangSwitcher switchLang:@"邀请有礼" key:nil];
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable.font = Font(18);
    self.nameLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.nameLable;

    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
//    UIButton *RightButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    self.navigationItem.rightBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:RightButton]];
//    [RightButton setImage:kImage(@"more 白色") forState:(UIControlStateNormal)];
//    [RightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:(UIControlEventTouchUpInside)];


    [self initUI];
//    [self.view addSubview:self.bouncedView];



    // Do any additional setup after loading the view.
}

-(void)rightButtonClick
{
    _bouncedView.frame = CGRectMake(kWidth(25), kHeight(140), SCREEN_WIDTH - kWidth(50), _bouncedView.pasteButton.yy + kHeight(30));
    [self showPopAnimationWithAnimationStyle:8];
}

#pragma mark -- 显示弹框
- (void)showPopAnimationWithAnimationStyle:(NSInteger)style
{
    ZJAnimationPopStyle popStyle = (style == 8) ? ZJAnimationPopStyleCardDropFromLeft : (ZJAnimationPopStyle)style;
    ZJAnimationDismissStyle dismissStyle = (ZJAnimationDismissStyle)style;
    // 1.初始化
    _popView = [[ZJAnimationPopView alloc] initWithCustomView:_bouncedView popStyle:popStyle dismissStyle:dismissStyle];

    // 2.设置属性，可不设置使用默认值，见注解
    // 2.1 显示时点击背景是否移除弹框
    _popView.isClickBGDismiss = YES;
    // 2.2 显示时背景的透明度
    _popView.popBGAlpha = 0.5f;
    // 2.3 显示时是否监听屏幕旋转
    _popView.isObserverOrientationChange = YES;
    // 2.4 显示时动画时长
    //    popView.popAnimationDuration = 0.8f;
    // 2.5 移除时动画时长
    //    popView.dismissAnimationDuration = 0.8f;

    // 2.6 显示完成回调
    _popView.popComplete = ^{
        NSLog(@"显示完成");
    };
    // 2.7 移除完成回调
    _popView.dismissComplete = ^{
        NSLog(@"移除完成");
    };
    // 4.显示弹框
    [_popView pop];
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.popView dismiss];
    
}

- (void)initUI
{
    UIImageView *bgView = [[UIImageView alloc] init];
    self.bgView = bgView;
    bgView.userInteractionEnabled = YES;
    bgView.contentMode = UIViewContentModeScaleToFill;

    bgView.image = kImage(@"邀请bg");
    [self.view addSubview:bgView];
    bgView.frame = CGRectMake(0, -kNavigationBarHeight, kScreenWidth, kScreenHeight + kNavigationBarHeight);

    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - kWidth(38), kHeight(kNavigationBarHeight + 16), kWidth(76), kHeight(103))];
    iconImage.image = kImage(@"logoo");
    //    iconImage.backgroundColor = [UIColor redColor];
    [bgView addSubview:iconImage];

    UIImageView *titleBackImage = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(70), kHeight(197 - 64 + kNavigationBarHeight),SCREEN_WIDTH - kWidth(105), kHeight(52))];
    titleBackImage.image = kImage(@"文字背景");
    [bgView addSubview:titleBackImage];


    UILabel *introduceLabel = [UILabel labelWithFrame:CGRectMake(kWidth(23), kHeight(2), SCREEN_WIDTH - kWidth(186), kHeight(36)) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(16) textColor:kHexColor(@"#FFFFFF")];

    introduceLabel.text = [LangSwitcher switchLang:@"全球首款跨链生态钱包" key:nil];
    [titleBackImage addSubview:introduceLabel];


    UIImageView *textBackImage = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(40), titleBackImage.yy + kHeight(30), SCREEN_WIDTH - kWidth(80), kHeight(354))];
    textBackImage.image = kImage(@"长框");
    [bgView addSubview:textBackImage];


//    滑动试图
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kWidth(40), titleBackImage.yy + kHeight(40) - kNavigationBarHeight, SCREEN_WIDTH - kWidth(80), kHeight(354) - 20)];
//    scrollView.userInteractionEnabled = YES;
    scrollView.backgroundColor = kClearColor;
//    scrollView.scrollEnabled = YES;
    [self.view addSubview:scrollView];

    UILabel *InviteFriendsLabel = [UILabel labelWithFrame:CGRectMake(0, kHeight(20), SCREEN_WIDTH - kWidth(80), 22) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(16) textColor:kHexColor(@"#00F9FE")];
    InviteFriendsLabel.text = [LangSwitcher switchLang:@"- 邀请好友界面 -" key:nil];
    [scrollView addSubview:InviteFriendsLabel];

    UILabel *numberLabel1 = [UILabel labelWithFrame:CGRectMake(kWidth(20), kHeight(58), 20, 14) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#FFFFFF")];
    numberLabel1.text = [LangSwitcher switchLang:@"1," key:nil];
    [scrollView addSubview:numberLabel1];

    UILabel *introduceLabel1 = [UILabel labelWithFrame:CGRectMake(kWidth(20) + 20, kHeight(58), SCREEN_WIDTH - kWidth(120) - 20, 0) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#FFFFFF")];

    // 设置Label要显示的text
    [introduceLabel1  setAttributedText:[self ReturnsTheDistanceBetween:[LangSwitcher switchLang:@"新用户注册并登录可获得10积分奖励" key:nil]]];
    introduceLabel1.numberOfLines = 0;
    [introduceLabel1 sizeToFit];
    [scrollView addSubview:introduceLabel1];


    UILabel *numberLabel2 = [UILabel labelWithFrame:CGRectMake(kWidth(20), introduceLabel1.yy + kHeight(10), 20, 14) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#FFFFFF")];
    numberLabel2.text = [LangSwitcher switchLang:@"2," key:nil];
    [scrollView addSubview:numberLabel2];

    UILabel *introduceLabel2 = [UILabel labelWithFrame:CGRectMake(kWidth(20) + 20, introduceLabel1.yy + kHeight(10), SCREEN_WIDTH - kWidth(120) - 20, 0) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#FFFFFF")];
    [introduceLabel2  setAttributedText:[self ReturnsTheDistanceBetween:[LangSwitcher switchLang:@"每邀请1位好友注册并登录后获得好友币加宝收益7%额外奖励。（有效期3个月）" key:nil]]];
    introduceLabel2.numberOfLines = 0;
    [introduceLabel2 sizeToFit];
    [scrollView addSubview:introduceLabel2];



    UILabel *InviteFriendsLabel1 = [UILabel labelWithFrame:CGRectMake(0, kHeight(20) + introduceLabel2.yy, SCREEN_WIDTH - kWidth(80), 22) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(16) textColor:kHexColor(@"#00F9FE")];
    InviteFriendsLabel1.text = [LangSwitcher switchLang:@"- 被邀请人界面 -" key:nil];
    [scrollView addSubview:InviteFriendsLabel1];

    UILabel *numberLabel3 = [UILabel labelWithFrame:CGRectMake(kWidth(20), kHeight(58) + introduceLabel2.yy, 20, 14) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#FFFFFF")];
    numberLabel3.text = [LangSwitcher switchLang:@"1," key:nil];
    [scrollView addSubview:numberLabel3];

    UILabel *introduceLabel3 = [UILabel labelWithFrame:CGRectMake(kWidth(20) + 20, kHeight(58) + introduceLabel2.yy, SCREEN_WIDTH - kWidth(120) - 20, 0) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#FFFFFF")];
    [introduceLabel3  setAttributedText:[self ReturnsTheDistanceBetween:[LangSwitcher switchLang:@"每一位用户注册成功并登陆可获得奖励10积分" key:nil]]];
    introduceLabel3.numberOfLines = 0;
    [introduceLabel3 sizeToFit];
    [scrollView addSubview:introduceLabel3];


    UILabel *numberLabel4 = [UILabel labelWithFrame:CGRectMake(kWidth(20), introduceLabel3.yy + kHeight(10), 20, 14) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#FFFFFF")];
    numberLabel4.text = [LangSwitcher switchLang:@"2," key:nil];
    [scrollView addSubview:numberLabel4];

    UILabel *introduceLabel4 = [UILabel labelWithFrame:CGRectMake(kWidth(20) + 20, introduceLabel3.yy + kHeight(10), SCREEN_WIDTH - kWidth(120) - 20, 0) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#FFFFFF")];
//    introduceLabel4.text = [LangSwitcher switchLang:@"每一位用户成功注册并登陆后可获得购买加宝收益每次翻倍奖励。" key:nil];
    [introduceLabel4  setAttributedText:[self ReturnsTheDistanceBetween:[LangSwitcher switchLang:@"每一位用户成功注册并登录后可获得购买加宝收益首次翻倍奖励。" key:nil]]];
    introduceLabel4.numberOfLines = 0;
    [introduceLabel4 sizeToFit];
    [scrollView addSubview:introduceLabel4];

    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH - kWidth(80), introduceLabel4.yy + kHeight(20));

}

//设置行间距
-(NSMutableAttributedString *)ReturnsTheDistanceBetween:(NSString *)str
{
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为30
    [paragraphStyle  setLineSpacing:8];
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:str];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    return setString;
}

@end
