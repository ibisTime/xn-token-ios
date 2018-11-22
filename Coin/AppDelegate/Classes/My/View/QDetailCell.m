//
//  QDetailCell.m
//  Coin
//
//  Created by shaojianfei on 2018/8/5.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "QDetailCell.h"


@interface QDetailCell ()

@property (nonatomic ,strong) UILabel *desLab;
@property (nonatomic ,strong) UILabel *timeLab;
@property (nonatomic ,strong) UIButton *moreButton;

@end
@implementation QDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

- (void)initSubviews {
    
    
    self.nameLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    [self addSubview:self.nameLab];
    
    self.stateLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
    [self addSubview:self.stateLab];
    
//    self.desLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
//    [self addSubview:self.desLab];
//
//    self.timeLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:11];
//    self.timeLab.numberOfLines = 0;
//    [self addSubview:self.timeLab];
//
//    self.moreButton = [UIButton buttonWithTitle:@"" titleColor:kClearColor backgroundColor:kClearColor titleFont:12];
//    [self.moreButton setImage:kImage(@"更多") forState:UIControlStateNormal];
//
//    [self addSubview:self.moreButton];
    
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(10);

    }];
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(110);
        make.right.equalTo(self.mas_right).offset(-10);

    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = kLineColor;
    [self addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(-1);
        make.left.equalTo(self.nameLab.mas_left);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@0.5);

        
    }];
//
//    [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.nameLab.mas_bottom).offset(10);
//        make.left.equalTo(self.mas_left).offset(10);
//
//    }];
//
//
//    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.desLab.mas_bottom).offset(8);
//        make.left.equalTo(self.mas_left).offset(10);
//        make.right.equalTo(self.mas_right).offset(-100);
//
//    }];
//
//    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.stateLab.mas_bottom).offset(8);
//        make.right.equalTo(self.mas_right).offset(-10);
//        make.centerX.equalTo(self.desLab.mas_centerX).offset(-100);
//
//    }];
//
    
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
        self.desLab.text = [LangSwitcher switchLang:@"奖励1000wan-严重缺陷,已于170版本修复" key:nil];
        self.timeLab.text = [model.commitDatetime convertRedDate];
        
    }else if ([model.status isEqualToString:@"2"])
    {
        
        self.stateLab.text = [LangSwitcher switchLang:@"复现不成功" key:nil];
        self.stateLab.textColor = kHexColor(@"#FE4F4F");
        self.desLab.text = [LangSwitcher switchLang:@"奖励1000wan-严重缺陷,已于170版本修复" key:nil];
        self.timeLab.text = [model.commitDatetime convertRedDate];
        
    }
    else
    {
        
        self.stateLab.text = [LangSwitcher switchLang:@"已领取" key:nil];
        self.stateLab.textColor = kTextColor2;
        self.desLab.text = [LangSwitcher switchLang:@"奖励1000wan-严重缺陷,已于170版本修复" key:nil];
        self.timeLab.text = [model.commitDatetime convertRedDate];
        
    }
    
    [self layoutSubviews];

  
}

- (void)setImageArray:(NSArray *)imageArray
{
    
    _imageArray = imageArray;
    
    for (int i = 0; i < imageArray.count; i ++) {
        
        CGFloat w = kWidth((80));
        CGFloat h = kHeight((80));
        
        
        
        CGFloat marge = 10;
        UIImageView * image = [[UIImageView alloc] init];
        image.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.left.equalTo(self.nameLab.mas_right).offset(10+i*w);
            make.width.equalTo(@(kWidth(90)));
            make.height.equalTo(@(kHeight(90)));

        }];
        image.frame = CGRectMake(marge*i + i*w , 10 , w, h);
        NSString *str = imageArray[i];
        NSURL *u = [NSURL URLWithString:[str convertImageUrl]];
        
        [image sd_setImageWithURL:u placeholderImage:kImage(@"头像")];
        //        [image sd_setImageWithURL:u];
    }
    [self setNeedsLayout];
    self.model.rowHeight = 200;
}

@end
