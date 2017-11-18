//
//  TLTransactionVC.m
//  Coin
//
//  Created by  tianlei on 2017/11/06.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLTransactionVC.h"
#import "TLUIHeader.h"

#import "TLTableView.h"
#import "CoinChangeView.h"
#import "TLBannerView.h"
#import "PublishTipView.h"
#import "TopLabelUtil.h"

#import "BannerModel.h"

#import "WebVC.h"

@interface TLTransactionVC ()<UITableViewDelegate, UITableViewDataSource, SegmentDelegate>

@property (nonatomic, strong) TLTableView *txTableView;
//发布
@property (nonatomic, strong) UIButton *publishBtn;
//发布界面
@property (nonatomic, strong) PublishTipView *tipView;
//banner
@property (nonatomic, strong) TLBannerView *bannerView;

@property (nonatomic,strong) NSMutableArray <BannerModel *>*bannerRoom;
//图片
@property (nonatomic,strong) NSMutableArray *bannerPics;
//切换
@property (nonatomic, strong) TopLabelUtil *labelUnil;

@end

@implementation TLTransactionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarUI];
    
    [self setUpUI];
    //banner
    [self getBanner];
    
}

#pragma mark- 交易搜索
- (void)search {
    
}

-(TopLabelUtil *)labelUnil {
    
    if (!_labelUnil) {
        
        _labelUnil = [[TopLabelUtil alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 120, 25, 240, 44)];
        _labelUnil.delegate = self;
        _labelUnil.backgroundColor = [UIColor clearColor];
        _labelUnil.titleNormalColor = kTextColor;
        _labelUnil.titleSelectColor = kThemeColor;
        _labelUnil.titleFont = Font(17.0);
        _labelUnil.lineType = LineTypeTitleLength;

        _labelUnil.titleArray = @[@"买币",@"卖币"];
    }
    return _labelUnil;
}

- (void)navBarUI {
    
    //1.左边切换
    CoinChangeView *coinChangeView = [[CoinChangeView alloc] init];
    coinChangeView.title = @"ETH";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:coinChangeView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        coinChangeView.title = @"ETH";

    });
    
    //2.右边搜索
    UIImage *searchImg = [UIImage imageNamed:@"交易_搜索"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:searchImg style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    
    //3.中间切换
    
    self.navigationItem.titleView = self.labelUnil;


}

- (void)setUpUI {
    
    CoinWeakSelf;
    
    self.txTableView = [TLTableView tableViewWithFrame:CGRectZero delegate:self dataSource:self];
    [self.view addSubview:self.txTableView];
    self.txTableView.backgroundColor = [UIColor orangeColor];
     
    [self.txTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
   //1.banner
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 140)];
    
    bannerView.selected = ^(NSInteger index) {
        
        if (!(self.bannerRoom[index].url && self.bannerRoom[index].url.length > 0)) {
            return ;
        }
        
        WebVC *webVC = [WebVC new];
        
        webVC.url = weakSelf.bannerRoom[index].url;
        
        [weakSelf.navigationController pushViewController:webVC animated:YES];
        
    };
    
    self.bannerView = bannerView;
    
    self.txTableView.tableHeaderView = bannerView;
    
    
   //2.发布
    self.publishBtn = [UIButton buttonWithImageName:@"发布"];
    
    [self.publishBtn addTarget:self action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.publishBtn];
    [self.publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-12);
        
    }];
    
    [self initTipView];
    
}

- (void)initTipView {
    
    CoinWeakSelf;
    
    NSArray *titles = @[@"发布购买", @"发布卖出"];
    
    _tipView = [[PublishTipView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) titles:titles];
    
    _tipView.publishBlock = ^(NSInteger index) {
        
        [weakSelf publishEventsWithIndex:index];

    };
}

#pragma mark - Events
- (void)clickPublish {
    
    [self.tipView show];
}

- (void)publishEventsWithIndex:(NSInteger)index {
 
    if (index == 0) {

    }
    else if (index == 1) {
        
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
    http.parameters[@"location"] = @"trade";
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellId"];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

#pragma mark - SegmentDelegate
-(void)segment:(TopLabelUtil *)segment didSelectIndex:(NSInteger)index {
    
    NSString *notiStr;
    
    if (index == 1) {
        
        notiStr = @"1";
        
    }else{
        notiStr = @"2";
    }
    
    [self.labelUnil dyDidScrollChangeTheTitleColorWithContentOfSet:(index-1)*kScreenWidth];

}

@end
