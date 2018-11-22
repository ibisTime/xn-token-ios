//
//  questionListCells.m
//  Coin
//
//  Created by shaojianfei on 2018/8/5.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "questionListCells.h"

@interface questionListCells ()
@property (nonatomic ,strong) UILabel *nameLab;
@property (nonatomic ,strong) UILabel *stateLab;
@property (nonatomic ,strong) UILabel *desLab;
@property (nonatomic ,strong) UILabel *timeLab;
@property (nonatomic ,strong) UIButton *moreButton;

@end
@implementation questionListCells
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
//        self.contentView setcon
    }
    
    return self;
}

- (void)initSubviews {
    

        self.nameLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
        [self addSubview:self.nameLab];

        self.stateLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
        [self addSubview:self.stateLab];

        self.desLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
        [self addSubview:self.desLab];
    self.desLab.numberOfLines = 0;

        self.timeLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:11];
        self.timeLab.numberOfLines = 0;
    [self addSubview:self.timeLab];
    
    self.moreButton = [UIButton buttonWithTitle:@"" titleColor:kClearColor backgroundColor:kClearColor titleFont:12];
    [self.moreButton setImage:kImage(@"更多") forState:UIControlStateNormal];
    
    [self addSubview:self.moreButton];
    
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(10);
        
    }];
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        
    }];
    
    [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLab.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-100);

    }];
    
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desLab.mas_bottom).offset(8);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-100);
        
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
        make.height.equalTo(@2);
        
    }];
    self.layer.borderWidth = 0.3;
    self.layer.borderColor = kLineColor.CGColor;
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;

}

- (void)loadMoneys
{
 
    
}

-(void)setModel:(QuestionModel *)model
{
    _model = model;
    self.nameLab.text = [TLUser user].nickname;
    if ([model.status isEqualToString:@"0"]) {
        self.stateLab.text = [LangSwitcher switchLang:@"待确认" key:nil];
        self.stateLab.textColor = kHexColor(@"#007AFF ");
        self.desLab.text = [LangSwitcher switchLang:@"奖励确认中" key:nil];
        self.timeLab.text = [model.commitDatetime convertRedDate];
    }else if ([model.status isEqualToString:@"1"])
    {
        
        self.stateLab.text = [LangSwitcher switchLang:@"已确认,待奖励" key:nil];
        self.stateLab.textColor = kTextColor2;
        NSString *type ;
        if ([self.model.level isEqualToString:@"1"]) {
            type = [LangSwitcher switchLang:@"严重缺陷" key:nil];
        }else if ([self.model.level isEqualToString:@"2"])
        {
            type = [LangSwitcher switchLang:@"一般缺陷" key:nil];

        }else{
            type = [LangSwitcher switchLang:@"优化缺陷" key:nil];

        }
//        CoinModel *currentCoin = [CoinUtil getCoinModel:@"WAN"];
//
//        NSString *leftAmount = [model.payAmount subNumber:currentCoin.withdrawFeeString];
//        NSString *text1 =  [CoinUtil convertToRealCoin:leftAmount coin:@"WAN"];
//
//
//        NSString *str = [NSString stringWithFormat:@"%@%.2fwan-%@,%@%@%@",[LangSwitcher switchLang:@"奖励" key:nil],[text1 floatValue],type,model.repairVersionCode,[LangSwitcher switchLang:@"已于" key:nil],[LangSwitcher switchLang:@"修复" key:nil]];
//        NSString *money = [NSString stringWithFormat:@"%@",text1];
////        NSString *money = [NSString stringWithFormat:@"%@",[CoinUtil convertToRealCoin:model.payAmount coin:@"wan"]];
//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
//        if ([LangSwitcher currentLangType] == LangTypeEnglish) {
//            [attrStr addAttribute:NSForegroundColorAttributeName
//                            value:kHexColor(@"#007AFF")
//                            range:NSMakeRange(6, money.length+3)];
//        }else{
//            [attrStr addAttribute:NSForegroundColorAttributeName
//                            value:kHexColor(@"#007AFF")
//                            range:NSMakeRange(2, money.length+3)];
//        }
        
        self.desLab.text = [LangSwitcher switchLang:@"奖励发放中" key:nil];
        self.timeLab.text = [model.commitDatetime convertRedDate];
        
    }else if ([model.status isEqualToString:@"2"])
    {
        
        self.stateLab.text = [LangSwitcher switchLang:@"复现不成功" key:nil];
        self.stateLab.textColor = kHexColor(@"#FE4F4F");
        self.desLab.text = [LangSwitcher switchLang:@"奖励0" key:nil];
        self.timeLab.text = [model.commitDatetime convertRedDate];
        
    }
    else
    {
        
        self.stateLab.text = [LangSwitcher switchLang:@"已领取" key:nil];
        self.stateLab.textColor = kTextColor2;
        NSString *type ;
        if ([self.model.level isEqualToString:@"1"]) {
            type = [LangSwitcher switchLang:@"严重缺陷" key:nil];
        }else if ([self.model.level isEqualToString:@"2"])
        {
            type = [LangSwitcher switchLang:@"一般缺陷" key:nil];
            
        }else{
            type = [LangSwitcher switchLang:@"优化缺陷" key:nil];
            
        }
        
        CoinModel *currentCoin = [CoinUtil getCoinModel:@"WAN"];
        
//        NSString *leftAmount = [model.payAmount subNumber:currentCoin.withdrawFeeString];
        NSString *text =  [CoinUtil convertToRealCoin:model.payAmount coin:@"WAN"];

        
        NSString *str = [NSString stringWithFormat:@"%@%.2fwan-%@,,%@%@%@",[LangSwitcher switchLang:@"奖励" key:nil],[text floatValue],type,[LangSwitcher switchLang:@"已于" key:nil],model.repairVersionCode,[LangSwitcher switchLang:@"版本修复" key:nil]];
        
     
//        NSString *text1 =  [CoinUtil convertToRealCoin:model.payAmount coin:@"wan"];

//
        NSString *money = [NSString stringWithFormat:@"%@",text];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        if ([LangSwitcher currentLangType] == LangTypeEnglish) {
            [attrStr addAttribute:NSForegroundColorAttributeName
                            value:kHexColor(@"#007AFF")
                            range:NSMakeRange(6, money.length+3)];
        }else{
            [attrStr addAttribute:NSForegroundColorAttributeName
                            value:kHexColor(@"#007AFF")
                            range:NSMakeRange(2, money.length+3)];
        }
//        [attrStr addAttribute:NSForegroundColorAttributeName
//                        value:kHexColor(@"#007AFF")
//                        range:NSMakeRange(2, money.length+3)];
        self.desLab.attributedText = attrStr;
        
        self.timeLab.text = [model.commitDatetime convertRedDate];
        
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
