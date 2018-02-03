//
//  InviteFriendVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "InviteFriendVC.h"

#import "BannerModel.h"
//#import "RechargeActivityModel.h"

#import "APICodeMacro.h"

#import "ShareView.h"
#import "TLBannerView.h"

#import "HistoryInviteVC.h"
#import "TLUserLoginVC.h"
#import "TLNavigationController.h"
#import "WebVC.h"
#import "SGQRCodeGenerateManager.h"
#import "NSString+CGSize.h"
#import "UILabel+Extension.h"
#import "UIBarButtonItem+convience.h"
#import <UIScrollView+TLAdd.h>
#import "NSString+Extension.h"
#import "AppConfig.h"

@interface InviteFriendVC ()

@property (nonatomic, strong) UIView *centerView;
//轮播图
@property (nonatomic,strong) TLBannerView *bannerView;
//
@property (nonatomic,strong) NSMutableArray <BannerModel *>*bannerRoom;
//图片
@property (nonatomic,strong) NSMutableArray *bannerPics;
//说明
@property (nonatomic, copy) NSString *remark;
//分享链接
@property (nonatomic, copy) NSString *shareUrl;
//活动规则
@property (nonatomic, strong) UILabel *activityRuleLbl;
//滚动图
@property (nonatomic, strong) UIScrollView *scrollView;
//邀请人数
@property (nonatomic, strong) UILabel *numLbl;
//收益
@property (nonatomic, strong) UILabel *profitLbl;

@property (nonatomic, copy) NSString *shareBaseUrl;


@end

@implementation InviteFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [LangSwitcher switchLang:@"邀请好友" key:nil];
    
    [UIBarButtonItem addRightItemWithTitle:[LangSwitcher switchLang:@"推荐历史" key:nil] titleColor:kTextColor frame:CGRectMake(0, 0, 70, 30) vc:self action:@selector(historyFriends)];
    
    //scrollview
    [self initScrollView];
    //banner图
    [self initBannerView];
    //
    [self initSubviews];
    //获取banner图
    [self getBanner];
    //获取活动规则
    [self requestActivityRule];
    //获取邀请人数和收益
    [self requestInviteNumber];
    //获取分享链接
    [self getShareUrl];
}

#pragma mark- 分享二维码, 注意分享链接的改变
- (void)shareQRCode {
    
//  http://h5域名手机号
    WebVC *vc = [[WebVC alloc] init];
    if (self.shareBaseUrl) {
        
//        vc.url = [NSString stringWithFormat:@"%@/user/qrcode.html?m=%@",self.shareBaseUrl,[TLUser user].secretUserId];
        
        vc.url = [NSString stringWithFormat:@"%@/user/qrcode.html?inviteCode=%@",self.shareBaseUrl,[TLUser user].secretUserId];
        vc.title = [LangSwitcher switchLang:@"点击分享" key:nil];
        vc.canSendWX = YES;

    }
    [self.navigationController pushViewController:vc animated:YES];
//    return;
//    
//    //背景
//    UIButton *maskView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    maskView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
//    [[UIApplication sharedApplication].keyWindow addSubview:maskView];
//    [maskView addTarget:self
//                 action:@selector(removeFromWindow:)
//       forControlEvents:UIControlEventTouchUpInside];
//    //
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:self.shareUrl
//                                                              imageViewWidth:140];
//    [maskView addSubview:imageView];
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerX.equalTo(maskView.mas_centerX);
//        make.centerY.equalTo(maskView.mas_centerY).offset(-20);
//        
//    }];
    
    
}

- (void)removeFromWindow:(UIButton *)btn {
    [btn removeFromSuperview];
    
}

#pragma mark - Init
- (void)initScrollView {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.scrollView adjustsContentInsets];
    
    [self.view addSubview:self.scrollView];
    
}

- (void)initBannerView {
    
    CoinWeakSelf;
    
    //顶部轮播
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (340.0/750)*SCREEN_WIDTH)];
    
    bannerView.selected = ^(NSInteger index) {
        
        if (!(weakSelf.bannerRoom[index].url && weakSelf.bannerRoom[index].url.length > 0)) {
            return ;
        }
        
        WebVC *webVC = [WebVC new];
        
        webVC.url = weakSelf.bannerRoom[index].url;
        
        [weakSelf.navigationController pushViewController:webVC animated:YES];
        
    };
    
    [self.scrollView addSubview:bannerView];
    
    self.bannerView = bannerView;
}

- (void)initSubviews {

    self.view.backgroundColor = kWhiteColor;
    
    CGFloat leftMargin = 15;
    
    // 此处巨坑
//    UIImageView *inviteIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 170)];
//    inviteIV.image = kImage(@"邀请好友图片");
//    [self.scrollView addSubview:inviteIV];
    
    //提成收益
    UIView *profitView = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, self.bannerView.yy + 15, kScreenWidth - 2*leftMargin, 100)];
    [self.scrollView addSubview:profitView];
    profitView.backgroundColor = [UIColor colorWithHexString:@"#fff9eb"];
    profitView.layer.shadowOffset = CGSizeMake(4, 4);
    profitView.layer.shadowOpacity = 1.0f;
    profitView.layer.shadowColor = kBackgroundColor.CGColor;
    
    //
    UIButton *profitViewLeftBtn = [[UIButton alloc] init];
    [profitView addSubview:profitViewLeftBtn];
    [profitViewLeftBtn addTarget:self action:@selector(historyFriends) forControlEvents:UIControlEventTouchUpInside];
    [profitViewLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.bottom.equalTo(profitView);
        make.width.equalTo(profitView.mas_width).dividedBy(2);
        
    }];

    
    //邀请人数
    UILabel *personTextLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kThemeColor font:12.0];
    
    personTextLbl.text = [LangSwitcher switchLang:@"成功邀请（人）" key:nil];
    
    personTextLbl.textAlignment = NSTextAlignmentCenter;
    
    [profitView addSubview:personTextLbl];
    [personTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(profitView.mas_centerX).offset(-profitView.width/4.0);
        make.top.equalTo(@25);
        
    }];
    
    self.numLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:16.0];
    
    self.numLbl.textAlignment = NSTextAlignmentCenter;

    [profitView addSubview:self.numLbl];
    [self.numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(personTextLbl.mas_bottom).offset(18);
        make.centerX.equalTo(profitView.mas_centerX).offset(-profitView.width/4.0);
        
    }];
    
    //收益
    UILabel *countTextLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kThemeColor font:12.0];
    
    countTextLbl.text = [LangSwitcher switchLang:@"提成收益（ETH）" key:nil];

    countTextLbl.textAlignment = NSTextAlignmentCenter;
    
    [profitView addSubview:countTextLbl];
    [countTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(profitView.mas_centerX).offset(profitView.width/4.0);
        make.top.equalTo(@25);
        
    }];
    
    self.profitLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:16.0];
    
    self.profitLbl.textAlignment = NSTextAlignmentCenter;
    
    [profitView addSubview:self.profitLbl];
    [self.profitLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(personTextLbl.mas_bottom).offset(18);
        make.centerX.equalTo(profitView.mas_centerX).offset(profitView.width/4.0);
        
    }];
    
    //推荐按钮
    CGFloat btnMargin = 40;
    CGFloat btnWidth = (SCREEN_WIDTH - 3*btnMargin)/2.0;
    CGFloat btnHeight = 40;
    CGFloat font = 16;
    
    //左边按钮
   UIButton *leftBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"分享链接" key:nil] titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:font cornerRadius:btnHeight/2.0];
    [self.scrollView addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(inviteFriend) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.frame = CGRectMake(btnMargin,  profitView.yy + 20, btnWidth, btnHeight);
    
   //右边按钮
   UIButton *rightBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"分享二维码" key:nil] titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:font cornerRadius:btnHeight/2.0];
    [self.scrollView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(shareQRCode) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(leftBtn.xx + btnMargin,  leftBtn.top, btnWidth, btnHeight);


    
//    //我要推荐
//    UIButton *recommendBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"我要推荐" key:nil] titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:kWidth(18) cornerRadius:24];
//    [recommendBtn addTarget:self action:@selector(inviteFriend) forControlEvents:UIControlEventTouchUpInside];
//    recommendBtn.frame = CGRectMake(40, profitView.yy + 20, kScreenWidth - 80, 48);
//    [self.scrollView addSubview:recommendBtn];
    
    CGFloat iconTopCommon = leftBtn.yy;
    //活动规则
    [self.scrollView addSubview:self.centerView];
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"活动规则")];
    iconIV.frame = CGRectMake(0, iconTopCommon + kHeight(36), 105, 12);
    iconIV.centerX = self.view.centerX;
    [self.scrollView addSubview:iconIV];
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:kWidth(15)];
    
    textLbl.text = [LangSwitcher switchLang:@"活动规则" key:nil];
    textLbl.textAlignment = NSTextAlignmentCenter;
    textLbl.frame = CGRectMake(0, iconTopCommon + kHeight(35), 100, kWidth(15));
    textLbl.centerX = self.view.centerX;
    [self.scrollView addSubview:textLbl];
    
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(0, textLbl.yy + kHeight(24), kScreenWidth, 100)];
    
    blueView.tag = 2200;
    
    [self.scrollView addSubview:blueView];
    
    //活动规则
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, 0, kScreenWidth - 2*leftMargin, 100)];
    
    bgView.tag = 1200;
    
    bgView.backgroundColor = [UIColor colorWithHexString:@"#fff9eb"];
    
    bgView.layer.shadowOffset = CGSizeMake(4, 4);
    
    bgView.layer.shadowOpacity = 1.0f;
    
    bgView.layer.shadowColor = kBackgroundColor.CGColor;
    
    [blueView addSubview:bgView];
    
    UILabel *promptLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kThemeColor font:13.0];
    
    promptLbl.backgroundColor = kClearColor;
    
    promptLbl.numberOfLines = 0;
    
    promptLbl.frame = CGRectMake(leftMargin + 3, 10, bgView.width - 2*leftMargin, 70);
    
    [bgView addSubview:promptLbl];
    
    self.activityRuleLbl = promptLbl;
    
}

- (void)setRemark:(NSString *)remark {
    
    _remark = remark;
    
    //注意事项
    //
    CGFloat height = ([_remark componentsSeparatedByString:@"\n"].count+1)*25;

    [self.activityRuleLbl labelWithTextString:_remark lineSpace:10];
    
    self.activityRuleLbl.height = height;
    
    UIView *blueView = [self.scrollView viewWithTag:2200];
    
    blueView.height = height + 40;
    
    UIView *bgView = [blueView viewWithTag:1200];
    
    bgView.height = height + 20;
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, blueView.yy);

}

#pragma mark - Events
- (void)historyFriends {
    
   

    CoinWeakSelf;
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        
        loginVC.loginSuccess = ^{
            
            [weakSelf historyFriends];
        };
        
        TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    }
    
    HistoryInviteVC *inviteVC = [HistoryInviteVC new];
    
    [self.navigationController pushViewController:inviteVC animated:YES];
}

- (void)inviteFriend {

    CoinWeakSelf;
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        
        loginVC.loginSuccess = ^{
            
            [weakSelf inviteFriend];
        };
        
        TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    }
    
    ShareView *shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                                                 shareBlock:^(BOOL isSuccess, int errorCode) {
        
        if (isSuccess) {
            
            [TLAlert alertWithSucces:[LangSwitcher switchLang:@"分享成功" key:nil]];
            
        } else {
            
            [TLAlert alertWithError:[LangSwitcher switchLang:@"分享失败" key:nil]];
        }
        
    }];
    shareView.shareTitle = [LangSwitcher switchLang:@"邀请好友" key:nil];
    shareView.shareDesc = [LangSwitcher switchLang:@"即将开启新币种push交易" key:nil];
    shareView.shareURL = self.shareUrl;
    [self.view addSubview:shareView];
    
}

#pragma mark - Data
- (void)getBanner {
    
    //广告图
    __weak typeof(self) weakSelf = self;
    
    TLNetworking *http = [TLNetworking new];
    //806052
    http.code = @"805806";
    http.parameters[@"type"] = @"2";
    http.parameters[@"location"] = @"activity";
    
    [http postWithSuccess:^(id responseObject) {
        
        weakSelf.bannerRoom = [BannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //组装数据
        weakSelf.bannerPics = [NSMutableArray arrayWithCapacity:weakSelf.bannerRoom.count];
        
        //取出图片
        [weakSelf.bannerRoom enumerateObjectsUsingBlock:^(BannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [weakSelf.bannerPics addObject:[obj.pic convertImageUrl]];
        }];
        
        weakSelf.bannerView.imgUrls = weakSelf.bannerPics;
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)requestInviteNumber {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805123";
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        //收益
        NSString *profit = responseObject[@"data"][@"inviteProfit"];
        
        self.profitLbl.text = [profit convertToSimpleRealCoin];
        //邀请人数
        NSNumber *inviteNum = responseObject[@"data"][@"inviteCount"];
        
        self.numLbl.text = [inviteNum stringValue];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)requestActivityRule {

    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_CKEY_CVALUE;
    http.parameters[SYS_KEY] = @"activity_rule";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.remark = responseObject[@"data"][@"cvalue"];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)getShareUrl {

    NSString *shareStr = [NSString stringWithFormat:@"%@%@", [AppConfig config].shareBaseUrl, [TLUser user].userId];

    self.shareUrl = shareStr;
    
    TLNetworking *http = [TLNetworking new];

    http.code = USER_CKEY_CVALUE;
    http.parameters[SYS_KEY] = @"reg_url";

    [http postWithSuccess:^(id responseObject) {

        NSString *url = responseObject[@"data"][@"cvalue"];
        self.shareBaseUrl = url;
//        NSString *shareStr = [NSString stringWithFormat:@"%@/?mobile=%@&kind=C", url, [TLUser user].secretUserId];
        
        //
        NSString *shareStr = [NSString stringWithFormat:@"%@/?inviteCode=%@", url, [TLUser user].secretUserId];

        //
        self.shareUrl = shareStr;

    } failure:^(NSError *error) {


    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
