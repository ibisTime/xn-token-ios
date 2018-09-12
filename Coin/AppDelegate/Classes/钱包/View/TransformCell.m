//
//  TransformCell.m
//  Coin
//
//  Created by shaojianfei on 2018/9/10.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TransformCell.h"
#import "AppColorMacro.h"
#import "TLAlert.h"
#import "Masonry.h"
#import "UIButton+Custom.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CoinUtil.h"
#import "NSString+Extension.h"

@interface TransformCell()

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) UIView *mengView;
@end
@implementation TransformCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.borderColor = kLineColor.CGColor;
        self.layer.cornerRadius = 4;
        self.clipsToBounds = YES;
        self.backgroundColor = kWhiteColor;
        UIImageView *photoImageView = [[UIImageView alloc] init];
        photoImageView.contentMode = UIViewContentModeScaleToFill;
        
        [self addSubview:photoImageView];
        self.photoImageView = photoImageView;
        [photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@5);
            make.left.equalTo(@15);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
        
        
        self.selectedBtn = [UIButton buttonWithTitle:@"" titleColor:kTextColor backgroundColor:kClearColor titleFont:14];

        [self.selectedBtn addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.selectedBtn];
        [self.selectedBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        self.selectedBtn.enabled = NO;
        self.selectedBtn.titleLabel.font = [UIFont systemFontOfSize:14];
         self.selectedBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        //        [self.selectedBtn setImage:[UIImage imageNamed:@"金"] forState:UIControlStateNormal];
        //        [self.selectedBtn setImage:[UIImage imageNamed:@"银"] forState:UIControlStateSelected];
        [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView.mas_top).offset(5);
            make.left.equalTo(self.photoImageView.mas_right).offset(10);
            
        }];
//        self.selectedBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 15, 60);

        [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.edges.mas_equalTo(UIEdgeInsetsMake(15, 15, 15, 15));
        }];
        UIView *mengView = [[UIView alloc] init];
        self.mengView = mengView;
        mengView.hidden = YES;
        mengView.backgroundColor = kBackgroundColor;
        mengView.alpha = 0.3;
        [self addSubview:mengView];
        [mengView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
    
   
    
}

-(void)setIsClick:(BOOL)isClick
{
    _isClick = isClick;
    
    self.mengView.hidden = ! isClick;
    
}
-(void)setFrame:(CGRect)frame
{
    //    frame.origin.x = 10;//这里间距为10，可以根据自己的情况调整
    //    frame.size.width -= 2 * frame.origin.x;
    frame.origin.x += 2 * 10;
    [super setFrame:frame];
}

- (void)choose
{
    
    NSLog(@"choose");
    
}

-(void)setModel:(CurrencyModel *)model
{
    _model = model;
    
    
    CoinModel *coin = [CoinUtil getCoinModel:model.currency];
   
    
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:[coin.pic1 convertImageUrl]]];

    [self.selectedBtn setTitle:model.currency forState:UIControlStateNormal];

    
}
- (void)setNumberModel:(AddNumberModel *)numberModel
{
    
    
    _numberModel = numberModel;
}

@end
