//
//  RecodeCell.m
//  Coin
//
//  Created by shaojianfei on 2018/8/18.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "RecodeCell.h"
#import "UILable+convience.h"
#import "AppColorMacro.h"
#import "UIButton+Custom.h"
#import <Masonry/Masonry.h>
#import "NSString+Date.h"
#import "TLUser.h"
#import "CoinModel.h"
#import "CoinUtil.h"
#import "NSString+Extension.h"

@interface RecodeCell ()
@property (nonatomic ,strong) UILabel *nameLab;
@property (nonatomic ,strong) UILabel *stateLab;
@property (nonatomic ,strong) UILabel *desLab;
@property (nonatomic ,strong) UILabel *timeLab;
@property (nonatomic ,strong) UILabel *freeLable;

@property (nonatomic ,strong) UILabel *leaveLable;

@property (nonatomic ,strong) UIButton *moreButton;

@property (nonatomic ,strong) UIView *bottomView;

@property (nonatomic ,strong) UIView *blueView;

@property (nonatomic ,strong) UILabel *endLable;

@property (nonatomic ,strong) UILabel *endTimeLable;

@end
@implementation RecodeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        //        self.contentView setcon
    }
    
    return self;
}

- (void)initSubviews {
    
    
    self.nameLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:16];
    [self addSubview:self.nameLab];
    
    self.stateLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:12];
    //    self.stateLab.font = Font(26);
    //    self.stateLab.numberOfLines = 0;
    [self addSubview:self.stateLab];
    
    //    [self.stateLab sizeToFit];
    self.desLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
    self.timeLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:15];
    [self addSubview:self.timeLab];
    self.freeLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
    
    self.leaveLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:15];
    
    self.endLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
    
    self.endTimeLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:15];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = kHexColor(@"#E3E3E3");
    [self.contentView addSubview:line1];
   
    [self addSubview:self.leaveLable];
    [self addSubview:self.freeLable];
  
    [self addSubview:self.endLable];
    [self addSubview:self.endTimeLable];
    [self addSubview:self.desLab];
    self.desLab.numberOfLines = 0;
    
    
    self.timeLab.numberOfLines = 0;
    
    self.moreButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"购买成功" key:nil] titleColor:kWhiteColor backgroundColor:kHexColor(@"#FF6400") titleFont:12];
//    [self.moreButton setImage:kImage(@"更多") forState:UIControlStateNormal];
    
    [self addSubview:self.moreButton];

    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.left.equalTo(self.mas_left).offset(15);
        
    }];
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLab.mas_bottom).offset(10);
        make.left.equalTo(self.nameLab.mas_left);
        
        
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stateLab.mas_bottom).offset(15);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@0.3);
        
        
    }];
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
    
    
    [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(15);
        make.left.equalTo(self.mas_left).offset(15);
        
    }];
    
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.desLab.mas_centerY);
        make.left.equalTo(self.desLab.mas_right).offset(20);
        
    }];
    [self.freeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLab.mas_bottom).offset(15);
        make.left.equalTo(self.mas_left).offset(15);
        
    }];
  
    [self.leaveLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.freeLable.mas_centerY);
        make.left.equalTo(self.freeLable.mas_right).offset(20);
        
    }];
    
    [self.endLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leaveLable.mas_bottom).offset(15);
        make.left.equalTo(self.mas_left).offset(15);
        
    }];
    [self.endTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.endLable.mas_centerY);
        make.left.equalTo(self.endLable.mas_right).offset(20);
        
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right).offset(-15);
        make.width.equalTo(@72);
        make.height.equalTo(@26);

        
    }];
    
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
    self.layer.borderColor = [UIColor colorWithRed:62/255.0 green:58/255.0 blue:57/255.0 alpha:0.3].CGColor;
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
    
    
}

-(void)setFrame:(CGRect)frame
{
    //    frame.origin.x = 10;//这里间距为10，可以根据自己的情况调整
    //    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 2 * 5;
    [super setFrame:frame];
}

- (void)loadMoneys
{
    
    
}

-(void)setModel:(TLtakeMoneyModel *)model
{
    _model = model;
    CoinModel *m = [CoinUtil getCoinModel:model.produceModel.symbol];
    
    NSString *inv = [CoinUtil convertToRealCoin:model.investAmount coin:m.symbol];
    self.nameLab.text = model.produceModel.name;
    self.stateLab.text = [model.createDatetime convertToDetailDate];
     self.desLab.text = [LangSwitcher switchLang:@"购买金额" key:nil];
     self.timeLab.text =[NSString stringWithFormat:@"%@%@",inv,m.symbol];
    self.freeLable.text =  [LangSwitcher switchLang:@"总收益" key:nil];
    self.endLable.text = [LangSwitcher switchLang:@"到期时间" key:nil];
    self.endTimeLable.text = [model.produceModel.arriveDatetime convertToDetailDate];;

//    self.timeLab.text =[NSString stringWithFormat:@"%@%@",model.limitDays,[LangSwitcher switchLang:@"个月" key:nil]];
    NSString *inv2 = [CoinUtil convertToRealCoin:model.expectIncome coin:m.symbol];

    self.leaveLable.text = [NSString stringWithFormat:@"%@%@",inv2,m.symbol];
    if ([model.status isEqualToString:@"0"]) {
        
        [self.moreButton setTitle:[LangSwitcher switchLang:@"申购中" key:nil] forState:UIControlStateNormal];
        
    }else if ([model.status isEqualToString:@"1"])
    {
        [self.moreButton setTitle:[LangSwitcher switchLang:@"持有中" key:nil] forState:UIControlStateNormal];

        
    }else if ([model.status isEqualToString:@"2"])
    {
        [self.moreButton setTitle:[LangSwitcher switchLang:@"已到期" key:nil] forState:UIControlStateNormal];

        
    }else
    {
        [self.moreButton setTitle:[LangSwitcher switchLang:@"募集失败" key:nil] forState:UIControlStateNormal];

        
    }
    //    self.nameLab.text = model.payNote;
    //    self.nameLab.text = model.payNote;
    //    self.nameLab.text = model.payNote;
    //    self.nameLab.text = model.payNote;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
