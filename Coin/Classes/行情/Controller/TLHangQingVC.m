//
//  TLHangQingVC.m
//  Coin
//
//  Created by  tianlei on 2017/11/06.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLHangQingVC.h"

#import "CoinHeader.h"
#import "AppConfig.h"

#import "QuotationView.h"

#import "BannerModel.h"
#import "NoticeModel.h"

#import "SystemNoticeVC.h"

@interface TLHangQingVC ()
//滚动视图
@property (nonatomic, strong) QuotationView *quotationView;

@property (nonatomic,strong) NSMutableArray <BannerModel *>*bannerRoom;
//图片
@property (nonatomic,strong) NSMutableArray *bannerPics;
//系统消息
@property (nonatomic,strong) NSMutableArray <NoticeModel *>*notices;

@end

@implementation TLHangQingVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self requestNoticeList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"行情";

    [self initScrollView];

    //查询虚拟币行情
    [self queryCoinQuotation];
    
    //    [self getBanner];
}

#pragma mark - Init

- (void)initScrollView {
    
    CoinWeakSelf;
    
    self.quotationView = [[QuotationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kBottomInsetHeight - kTabBarHeight)];

    self.quotationView.quotationBlock = ^(QuotationEventType quototionType, NSInteger index) {
        
        [weakSelf quotationEventWithType:quototionType index:index];
    };
    
    [self.view addSubview:self.quotationView];
}

#pragma mark - Events
- (void)quotationEventWithType:(QuotationEventType)type index:(NSInteger)index {
    
    switch (type) {
        case QuotationEventTypeHTML:
        {
            [TLAlert alertWithInfo:@"正在研发中, 敬请期待"];

        }break;
            
        case QuotationEventTypeNotice:
        {
            SystemNoticeVC *noticeVC = [SystemNoticeVC new];
            
            [self.navigationController pushViewController:noticeVC animated:YES];
            
        }break;
            
        case QuotationEventTypeCoinDetail:
        {
            if (!(self.bannerRoom[index].url && self.bannerRoom[index].url.length > 0)) {
                return ;
            }
            
            //        TLWebVC *webVC = [TLWebVC new];
            //
            //        webVC.url = weakSelf.bannerRoom[index].url;
            //
            //        [weakSelf.navigationController pushViewController:webVC animated:YES];
            
        }break;
            
        case QuotationEventTypeGuideDetail:
        {
            [TLAlert alertWithInfo:@"正在研发中, 敬请期待"];
            
            switch (index) {
                case 0:
                {
                    
                }break;
                    
                case 1:
                {
                    
                }break;
                    
                case 2:
                {
                    
                }break;
                    
                case 3:
                {
                    
                }break;
                    
                default:
                    break;
            }
            
        }break;
            
        default:
            break;
    }
}

#pragma mark - Data
- (void)getBanner {
    
    //广告图
    __weak typeof(self) weakSelf = self;
    
    TLNetworking *http = [TLNetworking new];
    //806052
    http.code = @"805806";
    http.parameters[@"type"] = @"2";
    http.parameters[@"location"] = @"market";
    
    [http postWithSuccess:^(id responseObject) {
        
        weakSelf.bannerRoom = [BannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //组装数据
        weakSelf.bannerPics = [NSMutableArray arrayWithCapacity:weakSelf.bannerRoom.count];
        
        //取出图片
        [weakSelf.bannerRoom enumerateObjectsUsingBlock:^(BannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [weakSelf.bannerPics addObject:[obj.pic convertImageUrl]];
        }];
        
        weakSelf.quotationView.bannerView.imgUrls = weakSelf.bannerPics;
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)requestNoticeList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"804040";
    if ([TLUser user].token) {
        
        helper.parameters[@"token"] = [TLUser user].token;
    }
    helper.parameters[@"channelType"] = @"4";
    
    helper.parameters[@"pushType"] = @"41";
    helper.parameters[@"toKind"] = @"C";    //C端
    //    1 立即发 2 定时发
    //    pageDataHelper.parameters[@"smsType"] = @"1";
    helper.parameters[@"start"] = @"1";
    helper.parameters[@"limit"] = @"20";
    helper.parameters[@"status"] = @"1";
    helper.parameters[@"fromSystemCode"] = [AppConfig config].systemCode;
    
    [helper modelClass:[NoticeModel class]];
    
    //消息数据
    [helper refresh:^(NSMutableArray <NoticeModel *>*objs, BOOL stillHave) {
        
        weakSelf.notices = objs;
        
        weakSelf.quotationView.notices = objs;
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)queryCoinQuotation {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625290";
    
    http.parameters[@"coin"] = @"ETH";
    
    [http postWithSuccess:^(id responseObject) {
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
