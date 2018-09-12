//
//  TLQrCodeVC.m
//  Coin
//
//  Created by shaojianfei on 2018/8/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLQrCodeVC.h"
#import "SGQRCodeGenerateManager.h"
#import "AppConfig.h"
#import "UIButton+SGImagePosition.h"
#import <QuartzCore/QuartzCore.h>
@interface TLQrCodeVC ()
{
    NSString *address ;
}


@property (nonatomic ,strong) UIImageView *bgView;

@property (nonatomic ,strong) UIImageView *bgView1;

@property (nonatomic, strong) UIImageView *bgImage;


@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UILabel *nameLable;

@property (nonatomic, copy) NSString *h5String;

@end

@implementation TLQrCodeVC

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
    
//    self.title = [LangSwitcher switchLang:@"邀请有礼" key:nil];
    [self getShareUrl];
    UIImageView *bgView = [[UIImageView alloc] init];
    self.bgView = bgView;
    bgView.userInteractionEnabled = YES;
    bgView.contentMode = UIViewContentModeScaleToFill;

    bgView.image = kImage(@"邀请bg");
    [self.view addSubview:bgView];
    bgView.frame = CGRectMake(0, -kNavigationBarHeight, kScreenWidth, kScreenHeight);

    self.nameLable = [[UILabel alloc]init];
    self.nameLable.text = [LangSwitcher switchLang:@"邀请有礼" key:nil];
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable.font = Font(18);
    self.nameLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.nameLable;

    self.view.backgroundColor  =[UIColor whiteColor];

    // Do any additional setup after loading the view.
}


- (void)getShareUrl
{
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"660917";
    
    http.parameters[@"ckey"] = @"redPacketShareUrl";
    
    [http postWithSuccess:^(id responseObject) {
        self.h5String = responseObject[@"data"][@"cvalue"];
        [self initUI];
        [self initUI1];
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)initUI
{
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - kWidth(38), kHeight(kNavigationBarHeight + 16), kWidth(76), kHeight(103))];
    iconImage.image = kImage(@"logoo");
    //    iconImage.backgroundColor = [UIColor redColor];
    [_bgView addSubview:iconImage];

    UIImageView *titleBackImage = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(70), kHeight(197 - 64 + kNavigationBarHeight),SCREEN_WIDTH - kWidth(105), kHeight(52))];
    titleBackImage.image = kImage(@"文字背景");
    [_bgView addSubview:titleBackImage];


    UILabel *introduceLabel = [UILabel labelWithFrame:CGRectMake(kWidth(23), kHeight(2), SCREEN_WIDTH - kWidth(186), kHeight(36)) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(16) textColor:kHexColor(@"#FFFFFF")];

    introduceLabel.text = [LangSwitcher switchLang:@"全球首款跨链生态钱包" key:nil];
    [titleBackImage addSubview:introduceLabel];


    UILabel *InviteLinkLabel = [UILabel labelWithFrame:CGRectMake(kWidth(20), kHeight(499), 0, kHeight(16)) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(12) textColor:kHexColor(@"#A2A5C4")];
    InviteLinkLabel.text = [LangSwitcher switchLang:@"复制您的专属邀请链接" key:nil];
    [self.bgView addSubview:InviteLinkLabel];
    [InviteLinkLabel sizeToFit];
    if (InviteLinkLabel.width >= SCREEN_WIDTH - kWidth(72) - kWidth(40)) {
        InviteLinkLabel.frame = CGRectMake(kWidth(20), kHeight(499), SCREEN_WIDTH - kWidth(72) - kWidth(40), kHeight(16));
    }else
    {
        InviteLinkLabel.frame = CGRectMake(SCREEN_WIDTH/2 - InviteLinkLabel.width/2 - kWidth(36), kHeight(499), InviteLinkLabel.width, kHeight(16));
    }

    UIButton *copyButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"复制" key:nil] titleColor:kHexColor(@"#A2A5C4") backgroundColor:kClearColor titleFont:12];
    copyButton.frame = CGRectMake(InviteLinkLabel.xx + kWidth(12) , kHeight(494), kWidth(60), kHeight(26));
    kViewBorderRadius(copyButton, 2, 1, kHexColor(@"#A2A5C4"));
    [copyButton addTarget:self action:@selector(copyButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:copyButton];



    UIImageView *btnBack = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(-1), SCREEN_HEIGHT - kHeight(91), SCREEN_WIDTH + kWidth(2), kHeight(92))];
    btnBack.image = kImage(@"1-1");
    kViewBorderRadius(btnBack, 0.01, 1, kHexColor(@"#00F5FE"));
    [self.bgView addSubview:btnBack];

    NSArray *nameArray = @[@"保存本地",@"微信",@"朋友圈",@"微博"];
    NSArray *imgArray = @[@"保存本地 亮色",@"微信 亮色",@"朋友圈 亮色",@"微博 亮色"];

    for (int i = 0; i < 4; i ++) {
        UIButton *shareBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:nameArray[i] key:nil] titleColor:kHexColor(@"#05C8DB") backgroundColor:kClearColor titleFont:12];
        shareBtn.frame = CGRectMake(i % 4 * SCREEN_WIDTH/4, SCREEN_HEIGHT - kHeight(91), SCREEN_WIDTH/4, kHeight(91));
        [shareBtn SG_imagePositionStyle:(SGImagePositionStyleTop) spacing:8 imagePositionBlock:^(UIButton *button) {
            [button setImage:[UIImage imageNamed:imgArray[i]] forState:(UIControlStateNormal)];
        }];
        [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        shareBtn.tag = 100 + i;
        [self.bgView addSubview:shareBtn];
    }
    


    UIView *codeView = [UIView new];
    [self.bgView addSubview:codeView];
    codeView.backgroundColor = kBackgroundColor;
    codeView.frame = CGRectMake(SCREEN_WIDTH/2 - kWidth(90), kHeight(230) + kNavigationBarHeight, kWidth(180), kWidth(180));
    codeView.layer.cornerRadius=5;
    codeView.layer.shadowOpacity = 0.22;// 阴影透明度
    codeView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    codeView.layer.shadowRadius=3;// 阴影扩散的范围控制
    codeView.layer.shadowOffset=CGSizeMake(1, 1);// 阴影的范围

    [self.bgView addSubview:codeView];


    //二维码
    UIImageView *qrIV = [[UIImageView alloc] init];

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
    http://m.thadev.hichengdai.com/user/register.html?inviteCode=U201807030441369491006&lang=ZH_CN
     address = [NSString stringWithFormat:@"%@/user/register.html?inviteCode=%@&lang=%@",self.h5String,[TLUser user].secretUserId,lang];
        
    
    qrIV.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:address imageViewWidth:170];
    
    [codeView addSubview:qrIV];
    [qrIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(codeView.mas_top).offset(15);
        make.right.equalTo(codeView.mas_right).offset(-15);
        make.left.equalTo(codeView.mas_left).offset(15);
        make.bottom.equalTo(codeView.mas_bottom).offset(-15);
    }];

}


- (void)initUI1
{
    UIImageView *bgView = [[UIImageView alloc] init];
    self.bgView1 = bgView;
    bgView.userInteractionEnabled = YES;
    bgView.contentMode = UIViewContentModeScaleToFill;

    bgView.image = kImage(@"邀请bg");
    [self.view addSubview:bgView];
    bgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, SCREEN_WIDTH, 44)];
    titleLabel.text = [LangSwitcher switchLang:@"邀请有礼" key:nil];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = Font(18);
    titleLabel.textColor = [UIColor whiteColor];
    [bgView addSubview:titleLabel];


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


    UIView *codeView = [UIView new];
    [self.bgView addSubview:codeView];
    codeView.backgroundColor = kBackgroundColor;
    codeView.frame = CGRectMake(SCREEN_WIDTH/2 - kWidth(90), kHeight(230) + kNavigationBarHeight, kWidth(180), kWidth(180));
    codeView.layer.cornerRadius=5;
    codeView.layer.shadowOpacity = 0.22;// 阴影透明度
    codeView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    codeView.layer.shadowRadius=3;// 阴影扩散的范围控制
    codeView.layer.shadowOffset=CGSizeMake(1, 1);// 阴影的范围
    [bgView addSubview:codeView];


    //二维码
    UIImageView *qrIV = [[UIImageView alloc] init];

    qrIV.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:address imageViewWidth:170];

    [codeView addSubview:qrIV];
    [qrIV mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(codeView.mas_top).offset(15);
        make.right.equalTo(codeView.mas_right).offset(-15);
        make.left.equalTo(codeView.mas_left).offset(15);
        make.bottom.equalTo(codeView.mas_bottom).offset(-15);
    }];

    UILabel *InviteFriendsLabel = [UILabel labelWithFrame:CGRectMake(kWidth(20), codeView.yy + kHeight(30), SCREEN_WIDTH - kWidth(40), 22) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(16) textColor:kHexColor(@"#00F9FE")];
    InviteFriendsLabel.text = [LangSwitcher switchLang:@"- 登录享豪礼 -" key:nil];
    [bgView addSubview:InviteFriendsLabel];

    UILabel *numberLabel1 = [UILabel labelWithFrame:CGRectMake(kWidth(60), InviteFriendsLabel.yy +  kHeight(16), 20, 14) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#FFFFFF")];
    numberLabel1.text = [LangSwitcher switchLang:@"1," key:nil];
    [bgView addSubview:numberLabel1];

    UILabel *introduceLabel1 = [UILabel labelWithFrame:CGRectMake(kWidth(60) + 20, InviteFriendsLabel.yy +  kHeight(16), SCREEN_WIDTH - kWidth(120) - 20, 0) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#FFFFFF")];

    // 设置Label要显示的text
    [introduceLabel1  setAttributedText:[self ReturnsTheDistanceBetween:[LangSwitcher switchLang:@"新用户注册并登陆可获得10原矿奖励" key:nil]]];
    introduceLabel1.numberOfLines = 0;
    [introduceLabel1 sizeToFit];
    [bgView addSubview:introduceLabel1];
    UILabel *numberLabel2 = [UILabel labelWithFrame:CGRectMake(kWidth(60), introduceLabel1.yy + kHeight(10), 20, 14) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#FFFFFF")];
    numberLabel2.text = [LangSwitcher switchLang:@"2," key:nil];
    [bgView addSubview:numberLabel2];

    UILabel *introduceLabel2 = [UILabel labelWithFrame:CGRectMake(kWidth(60) + 20, introduceLabel1.yy + kHeight(10), SCREEN_WIDTH - kWidth(120) - 20, 0) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#FFFFFF")];
    [introduceLabel2  setAttributedText:[self ReturnsTheDistanceBetween:[LangSwitcher switchLang:@"新用户可获得购买币加宝收益首次翻倍的奖励" key:nil]]];
    introduceLabel2.numberOfLines = 0;
    [introduceLabel2 sizeToFit];
    [bgView addSubview:introduceLabel2];
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

//@[@"保存本地",@"微信",@"朋友圈",@"微博"]
-(void)shareBtnClick:(UIButton *)sender
{
    switch (sender.tag - 100) {
        case 0:
        {
            [TLAlert alertWithSucces:[LangSwitcher switchLang:@"保存成功!" key:nil]];

            UIGraphicsBeginImageContextWithOptions(self.bgView1.bounds.size, NO, [[UIScreen mainScreen] scale]);
            [self.bgView1.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);

        }
            break;
        case 1:
        {

        }
            break;
        case 2:
        {

        }
            break;
        case 3:
        {

        }
            break;

        default:
            break;
    }
}

//复制
-(void)copyButtonClick
{
    [TLAlert alertWithSucces:[LangSwitcher switchLang:@"复制成功!" key:nil]];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = address;

}


- (void)inviteButtonClick
{
    
    
}

- (void)sendinviteButtonClick
{
    
    
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
