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

@property (nonatomic ,strong) UIView *drakView;
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
    

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    lineView.backgroundColor = kHexColor(@"#EFEFEF");
    [self addSubview:lineView];





    self.nameLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#464646") font:15];
    self.nameLab.frame = CGRectMake(15, 25, 0, 15);
    [self addSubview:self.nameLab];

    self.stateLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#FF6400") font:13];
    self.stateLab.frame = CGRectMake(15, 25, 0, 15);
    [self addSubview:self.stateLab];


//    self.leaveLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:13];
//    self.leaveLable.frame = CGRectMake(kScreenWidth - 100, 26, 85, 13);
//    [self addSubview:self.leaveLable];


    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(15, 55, kScreenWidth - 30, 1)];
    lineView1.backgroundColor = kLineColor;
    [self addSubview:lineView1];

    for (int i = 0; i < 3; i ++) {
        UILabel *numberLabel = [UILabel labelWithFrame:CGRectMake( 10 + i % 3 * kScreenWidth/3, 75, kScreenWidth/3 - 20, 30) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:Font(24) textColor:kHexColor(@"#FF6400")];
        if ( i != 0) {
            numberLabel.font = Font(18);
            numberLabel.textColor = kHexColor(@"#464646");
        }
        numberLabel.tag = 1000 + i;
        [self addSubview:numberLabel];

        UILabel *contactLabel = [UILabel labelWithFrame:CGRectMake(10 + i %3 *kScreenWidth/3, 110, kScreenWidth/3 - 20, 12) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:Font(12) textColor:kHexColor(@"#999999")];
        NSArray *textArray = @[@"预期年化收益",@"产品期限",@"剩余额度"];
        contactLabel.text = [LangSwitcher switchLang:textArray[i] key:nil];
        [self addSubview:contactLabel];


        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/3 + i %3*kScreenWidth/3, 75, 1, 50)];
        lineV.backgroundColor = kLineColor;
        [self addSubview:lineV];

    }


//     self.desLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
//    self.timeLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
//    [self addSubview:self.timeLab];
//    self.freeLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kAppCustomMainColor font:16];
//    [self addSubview:self.freeLable];
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

//
//    [self addSubview:self.desLab];
//
//
//    self.timeLab.numberOfLines = 0;
//
//
//    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.stateLab.mas_bottom).offset(17);
//        make.left.equalTo(self.mas_left).offset(30);
//        make.right.equalTo(self.mas_right).offset(-70);
//        make.height.equalTo(@8);
//
//
//    }];
//
//
//    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.stateLab.mas_centerY);
//        make.left.equalTo(self.stateLab.mas_right).offset(10);
//
//    }];
//    [self.freeLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.bottomView.mas_centerY);
//        make.right.equalTo(self.mas_right).offset(-5);
//
//    }];
//
//    [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.mas_bottom).offset(-10);
//        make.left.equalTo(self.mas_left).offset(15);
//
//
//    }];
//
//
//
//    [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.mas_bottom).offset(-10);
//        make.left.equalTo(self.mas_left).offset(15);
//
//    }];
//    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.stateLab.mas_bottom).offset(8);
//        make.right.equalTo(self.mas_right).offset(-10);
//        make.centerY.equalTo(self.mas_centerY);
//
//    }];

//    self.layer.borderWidth = 0.5;
//    self.layer.borderColor = [UIColor colorWithRed:62/255.0 green:58/255.0 blue:57/255.0 alpha:0.16].CGColor;
//    self.layer.cornerRadius = 4;
//    self.clipsToBounds = YES;
//
//    UIView *drakView = [UIView new];
//    drakView.backgroundColor = kLineColor;
//    drakView.alpha = 0.5;
//    self.drakView = drakView;
//    drakView.hidden = YES;
//    [self addSubview:drakView];
//    [drakView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
//    }];



    UIView *backLineView = [[UIView alloc]init];
    backLineView.backgroundColor = RGB(230, 240, 254);
    [self addSubview:backLineView];

    [backLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        //        make.right.equalTo(self.mas_right).offset(-30);
        make.height.equalTo(@2);
        make.width.equalTo(@(kScreenWidth));

    }];

    UIView *blueView = [UIView new];
    self.blueView = blueView;
    blueView.backgroundColor = kAppCustomMainColor;
    blueView.layer.cornerRadius = 5;
    blueView.clipsToBounds = YES;

    [self addSubview:blueView];

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


    UILabel *label1 = [self viewWithTag:1000];
    UILabel *label2 = [self viewWithTag:1001];
    UILabel *label3 = [self viewWithTag:1002];

    _model = model;
    CoinModel *coin = [CoinUtil getCoinModel:model.symbol];
    self.nameLab.text = model.name;
    self.stateLab.text = [LangSwitcher switchLang:@"认购中" key:nil];

    [self.stateLab sizeToFit];
    self.stateLab.frame = CGRectMake(kScreenWidth - 15 - self.stateLab.frame.size.width, 26, self.stateLab.frame.size.width, 13);
    self.nameLab.frame = CGRectMake(15, 25, kScreenWidth - self.stateLab.frame.size.width - 40 , 15);





    NSString *allAmount = [CoinUtil convertToRealCoin:model.amount coin:coin.symbol];
    NSString *currentAmount = [CoinUtil convertToRealCoin:model.saleAmount coin:coin.symbol];
    CGFloat f;
    if ([allAmount isEqualToString:@"0"]) {
        f = 0;
    }else{
       f =  [currentAmount floatValue]/[allAmount floatValue];

    }
    label1.text = [NSString stringWithFormat:@"%.2f%%",f*100];
    label2.text = [NSString stringWithFormat:@"%@%@",model.limitDays,[LangSwitcher switchLang:@"天" key:nil]];
   
    NSLog(@"比例是%f",f);
//    [self setNeedsLayout];


//    self.stateLab.text = [NSString stringWithFormat:@"%.2f%%",[model.expectYield floatValue]*100];
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
        NSString *m =[NSString stringWithFormat:@" %@%@",@(avilAmount.floatValue),model.symbol];

        NSString *str = [NSString stringWithFormat:@"%@ %@%@",[LangSwitcher switchLang:@"剩余" key:nil],@(avilAmount.floatValue),model.symbol];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
            [attrStr addAttribute:NSForegroundColorAttributeName
                            value:kTextBlack
                            range:NSMakeRange(s.length, m.length)];
      
        self.leaveLable.attributedText = attrStr;
//     self.leaveLable.text =[NSString stringWithFormat:@"%@ %@%@",[LangSwitcher switchLang:@"剩余" key:nil],avilAmount,model.symbol];
        
        
        [self.desLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.left.equalTo(self.mas_left).offset(15);
            make.width.equalTo(@(kWidth(150)));
            
        }];
        
        
    }
    else if ([model.status isEqualToString:@"6"])
    {
        if ([model.avilAmount isEqualToString:@"0"]) {
            self.leaveLable.text =[LangSwitcher switchLang:@"已售罄" key:nil];

        }else{
            self.leaveLable.text =[LangSwitcher switchLang:@"募集结束" key:nil];

        }

    }
    else if ([model.status isEqualToString:@"7"])
    {
        self.leaveLable.text =[LangSwitcher switchLang:@"已售罄" key:nil];

    }
    else if ([model.status isEqualToString:@"8"])
    {
        if (self.drakView.hidden == NO) {
            return;
        }
        self.drakView.hidden = NO;
        self.leaveLable.text =[LangSwitcher switchLang:@"已到期" key:nil];
    } else if ([model.status isEqualToString:@"9"])
    {
        self.leaveLable.text =[LangSwitcher switchLang:@"募集失败" key:nil];

    }else{
        
        self.leaveLable.text =[LangSwitcher switchLang:@"敬请期待" key:nil];

    }
    
    [self.blueView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        //        make.right.equalTo(self.mas_right).offset(-30);
        make.height.equalTo(@2);
        make.width.equalTo(@((kScreenWidth)*f));
        
    }];

    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
