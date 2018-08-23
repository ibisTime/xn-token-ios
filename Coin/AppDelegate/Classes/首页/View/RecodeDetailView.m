//
//  RecodeDetailView.m
//  Coin
//
//  Created by shaojianfei on 2018/8/18.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "RecodeDetailView.h"
#import "UILable+convience.h"
#import "AppColorMacro.h"
#import "UIButton+Custom.h"
#import <Masonry/Masonry.h>
#import "NSString+Date.h"
#import "TLUser.h"
#import "CoinModel.h"
#import "CoinUtil.h"
#import "NSString+Extension.h"
#import "TLtakeMoneyModel.h"

@interface RecodeDetailView()
@property (nonatomic ,strong) UILabel *nameLab;
@property (nonatomic ,strong) UILabel *stateLab;
@property (nonatomic ,strong) UILabel *desLab;
@property (nonatomic ,strong) UILabel *timeLab;
@property (nonatomic ,strong) UILabel *freeLable;
@property (nonatomic ,strong) UILabel *totalLable;
@property (nonatomic ,strong) UILabel *freeTime;

@property (nonatomic ,strong) UILabel *leaveLable;

@property (nonatomic ,strong) UIButton *moreButton;

@property (nonatomic ,strong) UIView *bottomView;

@property (nonatomic ,strong) UIView *blueView;

@property (nonatomic ,strong) UILabel *orderLable;

@property (nonatomic ,strong) UILabel *leftLable;

@property (nonatomic ,strong) UILabel *beiginLable;

@property (nonatomic ,strong) UILabel *leftLableDetail;

@property (nonatomic ,strong) UILabel *beiginLableDetail;

@property (nonatomic ,strong) UILabel *beiginTime;

@property (nonatomic ,strong) UILabel *beiginTimeLab;

@property (nonatomic ,strong) UILabel *endTime;

@property (nonatomic ,strong) UILabel *endTimeLab;

@property (nonatomic ,strong) UILabel *buyLab;

@property (nonatomic ,strong) UILabel *buycount;


@end
@implementation RecodeDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        [self initRateView];
        
        //
        [self initSubvies];
        //汇率
        
    }
    return self;
}
- (void)initSubvies
{
    
    
    UIImageView *bgBiew = [[UIImageView alloc] init];
    [self addSubview:bgBiew];
    bgBiew.image = kImage(@"Combined Shape");
    bgBiew.contentMode = UIViewContentModeScaleToFill;
    bgBiew.userInteractionEnabled = YES;
    [bgBiew mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);

//        make.width.equalTo(@(kScreenWidth-30));

        make.height.equalTo(@(kHeight(563)));
    }];
    self.nameLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:16];
   
    self.stateLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    //    self.stateLab.font = Font(26);
    //    self.stateLab.numberOfLines = 0;
    //    [self.stateLab sizeToFit];
    self.desLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    self.timeLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
   

    self.freeLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    self.freeTime = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];

    self.totalLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    self.orderLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
    
    self.leftLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];

    
    self.leftLableDetail = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
    self.beiginLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    
    self.beiginLableDetail = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
    
    self.beiginTime = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    
    self.beiginTimeLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
    
    self.endTime = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    
    self.endTimeLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
    self.buyLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    
    self.buycount = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
    
    [bgBiew addSubview:self.nameLab];
    [bgBiew addSubview:self.stateLab];
    [bgBiew addSubview:self.timeLab];
    [bgBiew addSubview:self.desLab];
    [bgBiew addSubview:self.freeLable];
    [bgBiew addSubview:self.freeTime];

    [bgBiew addSubview:self.orderLable];
    [bgBiew addSubview:self.totalLable];

    [bgBiew addSubview:self.leftLable];
    [bgBiew addSubview:self.leftLableDetail];
    [bgBiew addSubview:self.beiginLable];
    [bgBiew addSubview:self.beiginLableDetail];
    [bgBiew addSubview:self.beiginTime];
    [bgBiew addSubview:self.beiginTimeLab];
    [bgBiew addSubview:self.endTime];
    [bgBiew addSubview:self.endTimeLab];
//    [bgBiew addSubview:self.desLab];
    [bgBiew addSubview:self.leaveLable];
    [bgBiew addSubview:self.buyLab];
    [bgBiew addSubview:self.buycount];
    //    UIView *bottomView = [UIView new];
    //    self.bottomView = bottomView;
    //    bottomView.backgroundColor = kHexColor(@"#EFEFEF");
    //    bottomView.layer.cornerRadius = 5;
    //    bottomView.clipsToBounds = YES;
    //
    //    [self addSubview:bottomView];
    //
    //
    //
    //    UIView *blueView = [UIView new];
    //    self.blueView = blueView;
    //    blueView.backgroundColor = kAppCustomMainColor;
    //    blueView.layer.cornerRadius = 5;
    //    blueView.clipsToBounds = YES;
    
    //    [self addSubview:blueView];
    
   

    self.desLab.numberOfLines = 0;
    
    
    self.timeLab.numberOfLines = 0;
    
    self.moreButton = [UIButton buttonWithTitle:@"" titleColor:kClearColor backgroundColor:kClearColor titleFont:12];
    //    [self.moreButton setImage:kImage(@"更多") forState:UIControlStateNormal];
    
    [bgBiew addSubview:self.moreButton];
    self.leaveLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(28);
        make.centerX.equalTo(self.mas_centerX);
        
    }];
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLab.mas_bottom).offset(10);
        make.centerX.equalTo(self.mas_centerX);

    }];
    UIView *vi = [UIView new];
    vi.backgroundColor = kHexColor(@"#BAC1C8");
    
    [bgBiew addSubview:vi];
    [vi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset((kHeight(114)));
        make.right.equalTo(self.mas_right).offset(-30);
        make.left.equalTo(self.mas_left).offset(30);
        make.height.equalTo(@0.5);
        
    }];
    
    [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vi.mas_bottom).offset(45);
        make.left.equalTo(self.mas_left).offset(25);
        
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.desLab.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15);
        
    }];
   
    [self.freeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.timeLab.mas_bottom).offset(35);
        
    }];
    
    [self.freeTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-35);
        make.top.equalTo(self.timeLab.mas_bottom).offset(35);
        
    }];
    
    
    [self.totalLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.freeLable.mas_bottom).offset(35);
        
    }];
    
    [self.orderLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-35);
        make.top.equalTo(self.freeLable.mas_bottom).offset(35);
        
    }];
    
    [self.leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.totalLable.mas_bottom).offset(35);
        
    }];
    
    [self.leftLableDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-35);
        make.top.equalTo(self.totalLable.mas_bottom).offset(35);
        
    }];
    
    
    [self.buyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.leftLable.mas_bottom).offset(35);
        
    }];
    
    [self.buycount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-35);
        make.top.equalTo(self.leftLable.mas_bottom).offset(35);
        
    }];
    
    [self.beiginLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.buyLab.mas_bottom).offset(35);
        
    }];
    
    [self.beiginLableDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-35);
        make.top.equalTo(self.buyLab.mas_bottom).offset(35);
        
    }];
    
    [self.beiginTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.beiginLable.mas_bottom).offset(35);
        
    }];
    
    [self.beiginTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-35);
        make.top.equalTo(self.beiginLable.mas_bottom).offset(35);
        
    }];
    
    
    [self.endTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.beiginTime.mas_bottom).offset(35);
        
    }];
    
    [self.endTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-35);
        make.top.equalTo(self.beiginTime.mas_bottom).offset(35);
        
    }];
    
    
//    UIView *bottomView = [UIView new];
//    self.bottomView = bottomView;
//    bottomView.backgroundColor = kHexColor(@"#EFEFEF");
//    bottomView.layer.cornerRadius = 5;
//    bottomView.clipsToBounds = YES;
//
//    [bgBiew addSubview:bottomView];
//
    
//
//    UIView *blueView = [UIView new];
//    self.blueView = blueView;
//    blueView.backgroundColor = kAppCustomMainColor;
//    blueView.layer.cornerRadius = 5;
//    blueView.clipsToBounds = YES;
//
//    [bgBiew addSubview:blueView];
    //    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.stateLab.mas_bottom).offset(17);
    //        make.left.equalTo(self.mas_left).offset(30);
    //        make.right.equalTo(self.mas_right).offset(-60);
    //        make.height.equalTo(@8);
    //
    //
    //    }];
    //    [self.blueView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.stateLab.mas_bottom).offset(17);
    //        make.left.equalTo(self.mas_left).offset(30);
    //        //        make.right.equalTo(self.mas_right).offset(-30);
    //        make.height.equalTo(@8);
    //        make.width.equalTo(@((kScreenWidth - 60)/3));
    //
    //    }];
//
//    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.stateLab.mas_bottom).offset(17);
//        make.left.equalTo(self.mas_left).offset(30);
//        make.right.equalTo(self.mas_right).offset(-110);
//        make.height.equalTo(@8);
//
//
//    }];
//    [self.blueView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.stateLab.mas_bottom).offset(17);
//        make.left.equalTo(self.mas_left).offset(30);
//        //        make.right.equalTo(self.mas_right).offset(-30);
//        make.height.equalTo(@8);
//        make.width.equalTo(@((kScreenWidth - 60)/3));
//
//    }];
    
//    [self.orderLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.blueView.mas_centerY);
//        make.right.equalTo(self.mas_right).offset(-15);
//
//    }];
   
    
//    [self.leaveLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.timeLab.mas_centerY);
//        make.left.equalTo(self.desLab.mas_left);
//        
//    }];
//    [self.leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.bottomView.mas_bottom).offset(15);
//        make.left.equalTo(self.nameLab.mas_left);
//
//    }];
//
//    [self.beiginLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.leftLable.mas_bottom).offset(12);
//        make.left.equalTo(self.leftLable.mas_left);
//
//    }];
//    [self.leftLableDetail mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.bottomView.mas_bottom).offset(15);
//        make.left.equalTo(self.leftLable.mas_right).offset(10);
//
//    }];
    
//    [self.beiginLableDetail mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.leftLable.mas_bottom).offset(12);
//        make.left.equalTo(self.beiginLable.mas_right).offset(10);
//
//    }];
    
    //    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.stateLab.mas_bottom).offset(8);
    //        make.right.equalTo(self.mas_right).offset(-10);
    //        make.centerY.equalTo(self.mas_centerY);
    //
    //    }];
    
   
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithRed:62/255.0 green:58/255.0 blue:57/255.0 alpha:0.16].CGColor;
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
    
}
-(void)setModel:(TLtakeMoneyModel *)model
{
    _model = model;
    self.nameLab.text = model.produceModel.name;
    CoinModel *coin = [CoinUtil getCoinModel:model.produceModel.symbol];
    self.stateLab.text =  [LangSwitcher switchLang:@"购买成功" key:nil];;
    [NSString stringWithFormat:@"%@%@",model.produceModel.limitDays,[LangSwitcher switchLang:@"天" key:nil]];
    
    if ([model.status isEqualToString:@"0"]) {
        
        self.stateLab.text =  [LangSwitcher switchLang:@"申购中" key:nil];;

    }else if ([model.status isEqualToString:@"1"])
    {
        self.stateLab.text =  [LangSwitcher switchLang:@"持有中" key:nil];;

        
    }else if ([model.status isEqualToString:@"2"])
    {
        self.stateLab.text =  [LangSwitcher switchLang:@"已到期" key:nil];;

        
    }else
    {
        self.stateLab.text =  [LangSwitcher switchLang:@"募集失败" key:nil];;

        
    }
    
    [NSString stringWithFormat:@"%@%@",model.produceModel.limitDays,[LangSwitcher switchLang:@"天" key:nil]];

  
    self.desLab.text =   [LangSwitcher switchLang:@"合约编号" key:nil];;
    self.timeLab.text = model.code;
    self.totalLable.text =  [LangSwitcher switchLang:@"产品期限" key:nil];

    self.freeLable.text =  [LangSwitcher switchLang:@"交易时间" key:nil];
    self.freeTime.text = [model.produceModel.createDatetime convertToDetailDate];
    self.buyLab.text =  [LangSwitcher switchLang:@"购买金额" key:nil];

    NSString *inv = [CoinUtil convertToRealCoin:model.investAmount coin:model.produceModel.symbol];
    self.buycount.text =  [NSString stringWithFormat:@"%.4f%@",[inv floatValue],model.produceModel.symbol];

    self.leaveLable.text = model.name;
    self.orderLable.text = [NSString stringWithFormat:@"%@%@",model.produceModel.limitDays,[LangSwitcher switchLang:@"天" key:nil]];
    self.leftLable.text = [LangSwitcher switchLang:@"年收益率" key:nil];
    self.beiginLable.text = [LangSwitcher switchLang:@"总收益" key:nil];
    NSString *inall = [CoinUtil convertToRealCoin:model.expectIncome coin:model.produceModel.symbol];

    self.leftLableDetail.text = [NSString stringWithFormat:@"%.2f%%",[model.produceModel.expectYield floatValue]*100];
    self.beiginLableDetail.text = [NSString stringWithFormat:@"%.2f%@",[inall floatValue],model.produceModel.symbol];
    self.beiginTime.text = [LangSwitcher switchLang:@"起息时间" key:nil];
    self.beiginTimeLab.text = [model.produceModel.incomeDatetime convertToDetailDate ];
    self.endTime.text = [LangSwitcher switchLang:@"到期时间" key:nil];
    self.endTimeLab.text = [model.produceModel.arriveDatetime convertToDetailDate ];


    
    
}


@end
