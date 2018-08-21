//
//  TLTopMoneyView.m
//  Coin
//
//  Created by shaojianfei on 2018/8/16.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLTopMoneyView.h"
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
@interface  TLTopMoneyView()
@property (nonatomic ,strong) UILabel *nameLab;
@property (nonatomic ,strong) UILabel *stateLab;
@property (nonatomic ,strong) UILabel *desLab;
@property (nonatomic ,strong) UILabel *timeLab;
@property (nonatomic ,strong) UILabel *freeLable;
@property (nonatomic ,strong) UILabel *totalLable;

@property (nonatomic ,strong) UILabel *leaveLable;

@property (nonatomic ,strong) UIButton *moreButton;

@property (nonatomic ,strong) UIView *bottomView;

@property (nonatomic ,strong) UIView *blueView;

@property (nonatomic ,strong) UILabel *orderLable;

@property (nonatomic ,strong) UILabel *leftLable;

@property (nonatomic ,strong) UILabel *beiginLable;

@property (nonatomic ,strong) UILabel *leftLableDetail;

@property (nonatomic ,strong) UILabel *beiginLableDetail;

@property (nonatomic ,strong) UILabel *sumLable;


@property (nonatomic ,strong) UILabel *sumLableDetail;

@end
@implementation TLTopMoneyView
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
    self.nameLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#FF6400") font:24];
    [self addSubview:self.nameLab];
    
    self.stateLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:12];
    //    self.stateLab.font = Font(26);
    //    self.stateLab.numberOfLines = 0;
    [self addSubview:self.stateLab];
    //    [self.stateLab sizeToFit];
    self.desLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:18];
    self.timeLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:12];
    [self addSubview:self.timeLab];
    self.freeLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:18];
    
     self.totalLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:12];
    self.orderLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#007AFF") font:16];
     self.leftLableDetail = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
     self.beiginLableDetail = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
    self.leftLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
    self.beiginLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
    self.sumLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
    self.sumLableDetail = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
    [self addSubview:self.freeLable];
    [self addSubview:self.orderLable];
    [self addSubview:self.leftLable];
    [self addSubview:self.beiginLable];
    [self addSubview:self.leftLableDetail];
    [self addSubview:self.beiginLableDetail];
    [self addSubview:self.sumLable];
    [self addSubview:self.sumLableDetail];
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
    
    [self addSubview:self.desLab];
    self.desLab.numberOfLines = 0;
    
    
    self.timeLab.numberOfLines = 0;
    
    self.moreButton = [UIButton buttonWithTitle:@"" titleColor:kClearColor backgroundColor:kClearColor titleFont:12];
//    [self.moreButton setImage:kImage(@"更多") forState:UIControlStateNormal];
    
    [self addSubview:self.moreButton];
    self.leaveLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
    [self addSubview:self.leaveLable];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(20);
        make.left.equalTo(self.mas_left).offset(15);
        
    }];
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLab.mas_bottom).offset(6);
        make.left.equalTo(self.nameLab.mas_left).offset(15);
        
    }];
    
    UIView *bottomView = [UIView new];
    self.bottomView = bottomView;
    bottomView.backgroundColor = kHexColor(@"#EFEFEF");
    bottomView.layer.cornerRadius = 5;
    bottomView.clipsToBounds = YES;
    
    [self addSubview:bottomView];
    
    
    
    UIView *blueView = [UIView new];
    self.blueView = blueView;
    blueView.backgroundColor = kAppCustomMainColor;
    blueView.layer.cornerRadius = 5;
    blueView.clipsToBounds = YES;
    
    [self addSubview:blueView];
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
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stateLab.mas_bottom).offset(17);
        make.left.equalTo(self.mas_left).offset(30);
        make.right.equalTo(self.mas_right).offset(-110);
        make.height.equalTo(@8);
        
        
    }];
    [self.blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stateLab.mas_bottom).offset(17);
        make.left.equalTo(self.mas_left).offset(30);
        //        make.right.equalTo(self.mas_right).offset(-30);
        make.height.equalTo(@8);
        make.width.equalTo(@((kScreenWidth - 60)/3));
        
    }];
    
    [self.orderLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.blueView.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-5);
        
    }];
    [self.freeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLab.mas_centerY);
        make.left.equalTo(self.nameLab.mas_right).offset(56);
        
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stateLab.mas_centerY);
        make.left.equalTo(self.freeLable.mas_left);
        
    }];
    [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.freeLable.mas_centerY);
        make.left.equalTo(self.freeLable.mas_right).offset(56);
        
    }];
    
    [self.leaveLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLab.mas_centerY);
        make.left.equalTo(self.desLab.mas_left);

    }];
    [self.leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_bottom).offset(15);
        make.left.equalTo(self.nameLab.mas_left);
        
    }];
    
    [self.beiginLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftLable.mas_bottom).offset(12);
        make.left.equalTo(self.leftLable.mas_left);
        
    }];
    [self.leftLableDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_bottom).offset(15);
        make.left.equalTo(self.leftLable.mas_right).offset(10);
        
    }];
    
    [self.beiginLableDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftLable.mas_bottom).offset(12);
        make.left.equalTo(self.beiginLable.mas_right).offset(10);
        
    }];
    
    [self.sumLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.beiginLable.mas_bottom).offset(12);
        make.left.equalTo(self.beiginLable.mas_left);
        
    }];
    [self.sumLableDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.beiginLable.mas_bottom).offset(12);
        make.left.equalTo(self.sumLable.mas_right).offset(10);
        
    }];
//    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.stateLab.mas_bottom).offset(8);
//        make.right.equalTo(self.mas_right).offset(-10);
//        make.centerY.equalTo(self.mas_centerY);
//
//    }];
    
    UIView *vi = [UIView new];
    vi.backgroundColor = kHexColor(@"#F0F2F7");
    
    [self addSubview:vi];
    [vi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.height.equalTo(@0);
        
    }];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithRed:62/255.0 green:58/255.0 blue:57/255.0 alpha:0.16].CGColor;
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
    
}
-(void)setModel:(TLtakeMoneyModel *)model
{
    _model = model;
    CoinModel *coin = [CoinUtil getCoinModel:model.symbol];

    self.nameLab.text = [NSString stringWithFormat:@"%.2f%%",[model.expectYield floatValue]*100];
    self.stateLab.text = [NSString stringWithFormat:@"%@%@",model.limitDays,[LangSwitcher switchLang:@"天" key:nil]];
    self.freeLable.text = [NSString stringWithFormat:@"%@%@",model.limitDays,[LangSwitcher switchLang:@"天" key:nil]];
    NSString *totAmount = [CoinUtil convertToRealCoin:model.amount coin:coin.symbol];

    self.desLab.text = [NSString stringWithFormat:@"%@%@",totAmount,model.symbol];
    self.timeLab.text = [LangSwitcher switchLang:@"产品期限" key:nil];
    self.leaveLable.text = [LangSwitcher switchLang:@"产品总额" key:nil];
    NSString *allAmount = [CoinUtil convertToRealCoin:model.amount coin:coin.symbol];
    NSString *currentAmount = [CoinUtil convertToRealCoin:model.saleAmount coin:coin.symbol];
    CGFloat f;
    if ([allAmount isEqualToString:@"0"]) {
        f = 0;
    }else{
        f =  [currentAmount floatValue]/[allAmount floatValue];
        
    }
    [self.blueView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stateLab.mas_bottom).offset(17);
        make.left.equalTo(self.mas_left).offset(30);
        //        make.right.equalTo(self.mas_right).offset(-30);
        make.height.equalTo(@8);
        make.width.equalTo(@((kScreenWidth - 60-100)*f));
        
    }];
    self.orderLable.text = [NSString stringWithFormat:@"%@%.0f%%",[LangSwitcher switchLang:@"已认购" key:nil],f*100];
    self.leftLable.text = [LangSwitcher switchLang:@"剩余" key:nil];
    self.beiginLable.text = [LangSwitcher switchLang:@"起购" key:nil];
    self.sumLable.text = [LangSwitcher switchLang:@"递增金额" key:nil];

    NSString *salemount = [CoinUtil convertToRealCoin:model.avilAmount coin:coin.symbol];

    self.leftLableDetail.text = [NSString stringWithFormat:@"%.4f%@",[salemount floatValue],model.symbol];
    NSString *buyAmount = [CoinUtil convertToRealCoin:model.limitAmount coin:coin.symbol];
    NSString *mAmount = [CoinUtil convertToRealCoin:model.minAmount coin:coin.symbol];
    NSString *sAmount = [CoinUtil convertToRealCoin:model.increAmount coin:coin.symbol];

    self.beiginLableDetail.text = [NSString stringWithFormat:@"%.2f%@  (%@%@%@)",[mAmount floatValue],model.symbol,[LangSwitcher switchLang:@"每人限购" key:nil],buyAmount,model.symbol];
      self.leftLableDetail.text = [NSString stringWithFormat:@"%.2f%@",[salemount floatValue],model.symbol];
       self.sumLableDetail.text = [NSString stringWithFormat:@"%.2f%@",[sAmount floatValue],model.symbol];
//    self.leaveLable.text =[NSString stringWithFormat:@"%@ %@%@",[LangSwitcher switchLang:@"剩余" key:nil],model.avilAmount,model.symbol];
    //    self.nameLab.text = model.payNote; m1.name = @"币币赢第二期";
//    m1.symbol = @"BTC";
//    m1.expectYield = @"0.12";
//    m1.minAmount = @"1000";
//    m1.limitDays = @"129";
//    m1.avilAmount = @"10000";
    //    self.nameLab.text = model.payNote;
    //    self.nameLab.text = model.payNote;
    //    self.nameLab.text = model.payNote;

    
}


@end
