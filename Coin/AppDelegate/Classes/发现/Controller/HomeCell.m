//
//  HomeCell.m
//  Coin
//
//  Created by haiqingzheng on 2018/4/2.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "HomeCell.h"

@implementation HomeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {



        UIView *applicationView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 103)];
        applicationView.layer.cornerRadius=5;
        applicationView.layer.shadowOpacity = 0.22;// 阴影透明度
        applicationView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
        applicationView.layer.shadowRadius=3;// 阴影扩散的范围控制
        applicationView.layer.shadowOffset = CGSizeMake(1, 1);// 阴
        applicationView.backgroundColor = kHexColor(@"#EFF5FE");
        [self addSubview:applicationView];

        UIImageView *iconIV = [[UIImageView alloc] init];
        iconIV.backgroundColor = kAppCustomMainColor;

        [applicationView addSubview:iconIV];


        


//        [self.findModels enumerateObjectsUsingBlock:^(HomeFindModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {

//            NSLog(@"==========%ld",idx);

//            UIButton *btn = [UIButton buttonWithTitle:nil
//                                           titleColor:kWhiteColor
//                                      backgroundColor:kClearColor
//                                            titleFont:15.0];
//            self.tempBtn = btn;

            UIImageView *imageView= [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleToFill;
            [applicationView addSubview:imageView];
        self.iconImageView = imageView;

//            [btn setBackgroundColor: kHexColor(@"#EFF5FE") forState:UIControlStateNormal];
//            影的范围
//            btn.contentMode = UIViewContentModeScaleAspectFit;
//            btn.tag = 1500 + idx;
//            [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];


            UILabel *textLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:16];
            [applicationView addSubview:textLab];

        self.textLab = textLab;
            //        UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickButton:)];
            //        [contentView addGestureRecognizer:ta]

            UILabel *introfucec = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:12];
        self.introfucec = introfucec;
            [applicationView addSubview:introfucec];
            //        introfucec.numberOfLines = 0;


//            [applicationView addSubview:btn];

//            btn.frame = CGRectMake(0, 50 + idx%100 * 110, SCREEN_WIDTH - 30, 100);

            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(applicationView.mas_top).offset(22.5);
                make.left.equalTo(applicationView.mas_left).offset(20);
                make.width.equalTo(@55);
                make.height.equalTo(@58);

            }];





            //        [btn setTitleBottom];
//        }];

    }
    return self;
}

-(void)setFindModel:(HomeFindModel *)findModel
{
    self.textLab.text = [LangSwitcher switchLang:findModel.name key:nil];
    self.introfucec.text = [LangSwitcher switchLang:findModel.slogan key:nil];
    NSString *url = [findModel.icon convertImageUrl];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    self.introfucec.frame = CGRectMake(90, 0, SCREEN_WIDTH - 135, 0);
    self.introfucec.numberOfLines = 3;
    [self.introfucec sizeToFit];
    self.textLab.frame = CGRectMake(90, (103 - self.introfucec.frame.size.height - 8 - 10)/2, SCREEN_WIDTH - 135, 16);
    self.introfucec.frame = CGRectMake(90, self.textLab.yy + 5, SCREEN_WIDTH - 135, self.introfucec.frame.size.height);
}

@end
