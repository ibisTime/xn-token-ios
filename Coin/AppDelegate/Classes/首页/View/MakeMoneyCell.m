//
//  MakeMoneyCell.m
//  Coin
//
//  Created by shaojianfei on 2018/8/10.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "MakeMoneyCell.h"
#import "UILable+convience.h"
#import "AppColorMacro.h"
#import "UIButton+Custom.h"
#import <Masonry/Masonry.h>
#import "NSString+Date.h"
#import "TLUser.h"
#import "CoinModel.h"
#import "CoinUtil.h"
#import "NSString+Extension.h"
#import "CoinUtil.h"
@interface MakeMoneyCell()
@property (nonatomic ,strong) UILabel *nameLab;
@property (nonatomic ,strong) UILabel *stateLab;
@property (nonatomic ,strong) UILabel *desLab;
@property (nonatomic ,strong) UILabel *timeLab;
@property (nonatomic ,strong) UILabel *freeLable;

@property (nonatomic ,strong) UILabel *leaveLable;

@property (nonatomic ,strong) UIButton *moreButton;

@property (nonatomic ,strong) UIView *bottomView;

@property (nonatomic ,strong) UIView *blueView;


@end
@implementation MakeMoneyCell

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
    
    self.stateLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#FF6400") font:20];
//    self.stateLab.font = Font(26);
//    self.stateLab.numberOfLines = 0;
    [self addSubview:self.stateLab];
//    [self.stateLab sizeToFit];
     self.desLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    self.timeLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
    [self addSubview:self.timeLab];
    self.freeLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kAppCustomMainColor font:16];
    
    
    [self addSubview:self.freeLable];
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
    
    [self addSubview:self.desLab];
    self.desLab.numberOfLines = 0;
    
   
    self.timeLab.numberOfLines = 0;
    
    self.moreButton = [UIButton buttonWithTitle:@"" titleColor:kClearColor backgroundColor:kClearColor titleFont:12];
    [self.moreButton setImage:kImage(@"更多") forState:UIControlStateNormal];
    
    [self addSubview:self.moreButton];
      self.leaveLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    [self addSubview:self.leaveLable];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.left.equalTo(self.mas_left).offset(15);
        
    }];
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(53);
        make.left.equalTo(self.mas_left).offset(102);
        make.height.equalTo(@100);
        
        
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stateLab.mas_bottom).offset(17);
        make.left.equalTo(self.mas_left).offset(30);
        make.right.equalTo(self.mas_right).offset(-70);
        make.height.equalTo(@8);
        
        
    }];
    

    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stateLab.mas_centerY);
        make.left.equalTo(self.stateLab.mas_right).offset(10);
        
    }];
    [self.freeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-5);
        
    }];
    
    [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.equalTo(self.mas_left).offset(15);
        
    }];
    
    [self.leaveLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.right.equalTo(self.mas_right).offset(-15);
        
    }];
    
    [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.equalTo(self.mas_left).offset(15);
        
    }];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stateLab.mas_bottom).offset(8);
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.mas_centerY);
        
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
    self.layer.borderColor = [UIColor colorWithRed:62/255.0 green:58/255.0 blue:57/255.0 alpha:0.16].CGColor;
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
    CoinModel *coin = [CoinUtil getCoinModel:model.symbol];
    self.nameLab.text = model.name;
    
    NSString *allAmount = [CoinUtil convertToRealCoin:model.amount coin:coin.symbol];
    NSString *currentAmount = [CoinUtil convertToRealCoin:model.saleAmount coin:coin.symbol];
    CGFloat f;
    if ([allAmount isEqualToString:@"0"]) {
        f = 0;
    }else{
       f =  [currentAmount floatValue]/[allAmount floatValue];

    }
    
   
    NSLog(@"比例是%f",f);
//    [self setNeedsLayout];
    
    self.stateLab.text = [NSString stringWithFormat:@"%.2f%%",[model.expectYield floatValue]*100];
    self.freeLable.text = [NSString stringWithFormat:@"%.2f%%",f*100];
    NSString *minAmount = [CoinUtil convertToRealCoin:model.minAmount coin:coin.symbol];

//    self.desLab.text = [NSString stringWithFormat:@"%@%@ %@",minAmount,model.symbol,[LangSwitcher switchLang:@"起购" key:nil]];
    
    NSString *d = [LangSwitcher switchLang:@" 起购" key:nil];
    NSString *m2 =[NSString stringWithFormat:@"%@%@",minAmount,model.symbol];
    
    NSString *str1 = [NSString stringWithFormat:@"%@%@ %@",minAmount,model.symbol,[LangSwitcher switchLang:@"起购" key:nil]];
    NSMutableAttributedString *attrStr1 = [[NSMutableAttributedString alloc] initWithString:str1];
    [attrStr1 addAttribute:NSForegroundColorAttributeName
                    value:kTextBlack
                    range:NSMakeRange(0, m2.length)];
    
    self.desLab.attributedText = attrStr1;
    
    self.timeLab.text =[NSString stringWithFormat:@"%@%@",model.limitDays,[LangSwitcher switchLang:@"天" key:nil]];
    NSString *avilAmount = [CoinUtil convertToRealCoin:model.avilAmount coin:coin.symbol];

    if ([model.status isEqualToString:@"4"]) {
         self.leaveLable.text =[LangSwitcher switchLang:@"即将开始" key:nil];
    }else if ([model.status isEqualToString:@"5"])
    {
        NSString *s = [LangSwitcher switchLang:@"剩余" key:nil];
        NSString *m =[NSString stringWithFormat:@" %.2f%@",[avilAmount floatValue],model.symbol];

        NSString *str = [NSString stringWithFormat:@"%@ %.2f%@",[LangSwitcher switchLang:@"剩余" key:nil],[avilAmount floatValue],model.symbol];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
            [attrStr addAttribute:NSForegroundColorAttributeName
                            value:kTextBlack
                            range:NSMakeRange(s.length, m.length)];
      
        self.leaveLable.attributedText = attrStr;
//     self.leaveLable.text =[NSString stringWithFormat:@"%@ %@%@",[LangSwitcher switchLang:@"剩余" key:nil],avilAmount,model.symbol];
    }
    else if ([model.status isEqualToString:@"6"])
    {
        self.leaveLable.text =[LangSwitcher switchLang:@"停止交易" key:nil];

    }
    else if ([model.status isEqualToString:@"7"])
    {
        self.leaveLable.text =[LangSwitcher switchLang:@"已售馨" key:nil];

    }
    else if ([model.status isEqualToString:@"8"])
    {
        UIView *drakView = [UIView new];
        drakView.backgroundColor = kLineColor;
        drakView.alpha = 0.5;
        [self addSubview:drakView];
        [drakView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        self.leaveLable.text =[LangSwitcher switchLang:@"已到期" key:nil];
    } else if ([model.status isEqualToString:@"9"])
    {
        self.leaveLable.text =[LangSwitcher switchLang:@"募集失败" key:nil];

    }else{
        
        self.leaveLable.text =[LangSwitcher switchLang:@"敬请期待" key:nil];

    }
    
    [self.blueView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stateLab.mas_bottom).offset(17);
        make.left.equalTo(self.mas_left).offset(30);
        //        make.right.equalTo(self.mas_right).offset(-30);
        make.height.equalTo(@8);
        make.width.equalTo(@((kScreenWidth - 130)*f));
        
    }];
//    [self.blueView mas_remakeConstraints:^(MASConstraintMaker *make) {
//
//        make.width.equalTo(@((kScreenWidth - 60)*f));
//
//    }];
    
  
    [self setNeedsLayout];
    [self setNeedsDisplay];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
