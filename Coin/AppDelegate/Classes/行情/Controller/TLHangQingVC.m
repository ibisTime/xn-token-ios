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
#import "QuotationModel.h"
#import "GuideModel.h"

#import "SystemNoticeVC.h"
#import "WebVC.h"
#import "QuotationListVC.h"
#import "GuideDetailVC.h"

#import "NSNumber+Extension.h"

@interface TLHangQingVC ()
//滚动视图
@property (nonatomic, strong) QuotationView *quotationView;

@property (nonatomic,strong) NSMutableArray <BannerModel *>*bannerRoom;
//图片
@property (nonatomic,strong) NSMutableArray *bannerPics;
//系统消息
@property (nonatomic,strong) NSMutableArray <NoticeModel *>*notices;
//行情列表
@property (nonatomic, strong) NSArray <QuotationModel *>*quotations;
//新手指导
@property (nonatomic, strong) NSMutableArray <GuideModel *>*guides;
//定时器
@property (nonatomic, strong) NSTimer *timer;
//上一个行情(ETH)
@property (nonatomic, strong) QuotationModel *ethQuotation;
//上一个行情(BTC)
@property (nonatomic, strong) QuotationModel *btcQuotation;

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
    //查询以太币和比特币行情
    [self queryCoinQuotation];
    //获取banner图
    [self getBanner];
    //获取新手指导
    [self requestNoviceGuide];
    //定时器刷起来
    [self startTimer];
}

#pragma mark - Init

- (void)initScrollView {
    
    CoinWeakSelf;
    
    self.quotationView = [[QuotationView alloc] init];
    
    self.quotationView.quotationBlock = ^(QuotationEventType quototionType, NSInteger index) {
        
        [weakSelf quotationEventWithType:quototionType index:index];
    };
    
    [self.view addSubview:self.quotationView];
    [self.quotationView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - Events
- (void)quotationEventWithType:(QuotationEventType)type index:(NSInteger)index {
    
    switch (type) {
        case QuotationEventTypeHTML:
        {
            if (!(self.bannerRoom[index].url && self.bannerRoom[index].url.length > 0)) {
                return ;
            }
            
            WebVC *webVC = [WebVC new];
            
            webVC.url = self.bannerRoom[index].url;
            
            [self.navigationController pushViewController:webVC animated:YES];
            
        }break;
            
        case QuotationEventTypeNotice:
        {
            SystemNoticeVC *noticeVC = [SystemNoticeVC new];
            
            [self.navigationController pushViewController:noticeVC animated:YES];
            
        }break;
            
        case QuotationEventTypeCoinDetail:
        {
            
            QuotationListVC *listVC = [QuotationListVC new];
            
            listVC.quototationType = index == 0 ? QuotationListTypeETH: QuotationListTypeBTC;
            
            [self.navigationController pushViewController:listVC animated:YES];
            
        }break;
            
        case QuotationEventTypeGuideDetail:
        {
            
            GuideDetailVC *detailVC = [GuideDetailVC new];
            
            detailVC.guide = self.guides[index];
            
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }break;
            
        default:
            break;
    }
}

- (void)startTimer {
    
    //开启定时器,实时刷新
    self.timer = [NSTimer timerWithTimeInterval:30 target:self selector:@selector(queryCoinQuotation) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
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
    
    [http postWithSuccess:^(id responseObject) {
        
        self.quotations = [QuotationModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        
        [self.quotations enumerateObjectsUsingBlock:^(QuotationModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.coin isEqualToString:@"ETH"]) {
                
                UILabel *priceLbl = [self.quotationView viewWithTag:1400];
                
                UILabel *diffPriceLbl = [self.quotationView viewWithTag:1410];
                
                UILabel *diffPreLbl = [self.quotationView viewWithTag:1420];
                
                [self calculationPriceDiffWithPriceLabel:priceLbl diffPriceLabel:diffPriceLbl riseLabel:diffPreLbl lastQuotation:self.ethQuotation nowQuotation:obj];
                
                self.ethQuotation = obj;
                
            } else if ([obj.coin isEqualToString:@"BTC"]) {
                
                UILabel *priceLbl = [self.quotationView viewWithTag:1401];
                
                UILabel *diffPriceLbl = [self.quotationView viewWithTag:1411];
                
                UILabel *diffPreLbl = [self.quotationView viewWithTag:1421];
                
                [self calculationPriceDiffWithPriceLabel:priceLbl diffPriceLabel:diffPriceLbl riseLabel:diffPreLbl lastQuotation:self.btcQuotation nowQuotation:obj];
                
                self.btcQuotation = obj;
                
            } else {
                
                
            }
        }];
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)calculationPriceDiffWithPriceLabel:(UILabel *)priceLabel diffPriceLabel:(UILabel *)diffPricelabel riseLabel:(UILabel *)riseLabel lastQuotation:(QuotationModel *)lastQuotation nowQuotation:(QuotationModel *)nowQuotation {
    
    priceLabel.text = [nowQuotation.mid convertToRealMoneyWithNum:4];
    
    if (lastQuotation) {
        
        CGFloat diffPrice = [[nowQuotation.mid subNumber:lastQuotation.mid] doubleValue];
        
        CGFloat rate = 100*diffPrice/([lastQuotation.mid doubleValue]*1.0);
        
        //差价
        if (diffPrice >= 0) {
            
            priceLabel.textColor = kThemeColor;
            
            diffPricelabel.textColor = kThemeColor;
            
            diffPricelabel.text = [NSString stringWithFormat:@"+%.2lf", diffPrice];
            
            riseLabel.text = [NSString stringWithFormat:@"+%.2lf%%", rate];
            
            riseLabel.textColor = kThemeColor;
            
        } else {
            
            priceLabel.textColor = kRiseColor;
            
            diffPricelabel.textColor = kRiseColor;
            
            diffPricelabel.text = [NSString stringWithFormat:@"%.2lf", diffPrice];
            
            riseLabel.text = [NSString stringWithFormat:@"%.2lf%%", rate];
            
            riseLabel.textColor = kRiseColor;
        }
        
    } else {
        
        priceLabel.textColor = kThemeColor;
        
        diffPricelabel.text = @"+0.00";
        
        diffPricelabel.textColor = kThemeColor;
        
        riseLabel.text = @"+0%";
        riseLabel.textColor = kThemeColor;
    }
}

- (void)requestNoviceGuide {
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"801005";
    helper.start = 1;
    helper.limit = 20;
    
    helper.parameters[@"status"] = @"1";
    helper.parameters[@"orderColumn"] = @"order_no";
    helper.parameters[@"orderDir"] = @"asc";
    
    [helper modelClass:[GuideModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        self.guides = objs;
        
        self.quotationView.guides = objs;
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
