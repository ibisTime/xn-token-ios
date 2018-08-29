//
//  AddSearchCell.m
//  ljs
//
//  Created by shaojianfei on 2018/5/29.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AddSearchCell.h"
#import "AppColorMacro.h"
#import "TLAlert.h"
#import "Masonry.h"
@interface AddSearchCell()

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIButton *selectedBtn;

@end
@implementation AddSearchCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.photoImageView = [[UIImageView alloc] init];
//        [self.contentView addSubview:self.photoImageView];
//        self.photoImageView.clipsToBounds = YES;
//        self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
//
//        [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.edges.mas_equalTo(UIEdgeInsetsZero);
//
//        }];
        
        //按钮
        
        self.selectedBtn = [[UIButton alloc] init];
        [self.selectedBtn addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.selectedBtn];
        self.selectedBtn.backgroundColor = kAppCustomMainColor;
        [self.selectedBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        [self.selectedBtn setTitle:@"test" forState:UIControlStateNormal];
        [self.selectedBtn setTitle:@"test1" forState:UIControlStateSelected];
        self.selectedBtn.enabled = NO;
//        self.selectedBtn.layer.cornerRadius = 4.0;
        self.selectedBtn.layer.borderColor = kLineColor.CGColor;
        self.selectedBtn.layer.borderWidth=1;
        self.selectedBtn.titleLabel.font = [UIFont systemFontOfSize:16];

//        [self.selectedBtn setImage:[UIImage imageNamed:@"金"] forState:UIControlStateNormal];
//        [self.selectedBtn setImage:[UIImage imageNamed:@"银"] forState:UIControlStateSelected];
        [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView.mas_top).offset(0);
            make.left.equalTo(self.contentView.mas_left).offset(0);
            make.right.mas_equalTo(self.contentView.mas_right).offset(0);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
            
        }];
        
        [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(UIEdgeInsetsMake(15, 15, 15, 15));
        }];
        
    }
    return self;
}
- (void)choose
{
    
    NSLog(@"choose");
    
}
- (void)setTitle:(CurrencyTitleModel *)title
{
    
    _title = title;
    [self.selectedBtn setTitle:title.symbol forState:UIControlStateNormal];
    if (title.IsSelect == YES) {
        [self.selectedBtn setBackgroundColor:kHexColor(@"#EDF3FF")];
        [self.selectedBtn setTitleColor:kHexColor(@"#407EF9 ") forState:UIControlStateNormal];
        
        //        self.photoImageView.hidden = NO;
    }else{
        
        [self.selectedBtn setBackgroundColor:[UIColor colorWithHexString:@"##F5F5F5"]];
        [self.selectedBtn setTitleColor:kTextColor2 forState:UIControlStateNormal];
        
        //        self.photoImageView.hidden = YES;
    }
    
}
- (void)setNumberModel:(AddNumberModel *)numberModel
{
    
    
    _numberModel = numberModel;
}

@end
