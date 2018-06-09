//
//  AddSearchBottomCell.m
//  ljs
//
//  Created by shaojianfei on 2018/5/30.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AddSearchBottomCell.h"
#import "AppColorMacro.h"
#import "TLAlert.h"
#import <Masonry.h>

@interface AddSearchBottomCell()
@property (nonatomic, strong) UIImageView *photoImageView;


@end
@implementation AddSearchBottomCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        //按钮
        
        self.selectedBtn = [[UIButton alloc] init];
        [self.selectedBtn addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.selectedBtn];
        self.selectedBtn.backgroundColor = kAppCustomMainColor;
        self.selectedBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.selectedBtn setTitleColor:kHexColor(@"#56d0fd") forState:UIControlStateNormal];
        [self.selectedBtn setTitle:@"test" forState:UIControlStateNormal];
        [self.selectedBtn setTitle:@"test1" forState:UIControlStateSelected];
        
        self.selectedBtn.enabled = NO;
        self.selectedBtn.layer.cornerRadius = 4.0;
        self.selectedBtn.layer.borderColor = (__bridge CGColorRef _Nullable)(kAppCustomMainColor);
        self.selectedBtn.layer.borderWidth=1;
        self.selectedBtn.frame = self.bounds;
        //        [self.selectedBtn setImage:[UIImage imageNamed:@"金"] forState:UIControlStateNormal];
        //        [self.selectedBtn setImage:[UIImage imageNamed:@"银"] forState:UIControlStateSelected];
//        [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.top.left.right.bottom.equalTo(@0);
//
////            make.top.equalTo(self.contentView.mas_top);
////            make.left.equalTo(self.contentView.mas_left);
////            make.right.mas_equalTo(self.contentView.mas_right);
////            make.bottom.mas_equalTo(self.contentView.mas_bottom);
//
//        }];
        
//        [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.edges.mas_equalTo(UIEdgeInsetsMake(15, 15, 15, 15));
//        }];
        
//        self.photoImageView = [[UIImageView alloc] init];
//        [self.contentView addSubview:self.photoImageView];
//        self.photoImageView.clipsToBounds = YES;
//        self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
//        self.photoImageView.image = [UIImage imageNamed:@"打勾"];
//        [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.mas_right);
//            make.bottom.equalTo(self.selectedBtn.mas_bottom);
//            make.height.equalTo(@21);
//            make.width.equalTo(@21);
//
//        }];
        
    }
    return self;
}
- (void)choose: (UIButton *)button
{
    
    
    NSLog(@"choose");
    
}
- (void)setTitle:(CurrencyTitleModel *)title
{
    
    _title = title;
    [self.selectedBtn setTitle:title.symbol forState:UIControlStateNormal];
    if (title.IsSelect == YES) {
        [self.selectedBtn setBackgroundColor:kAppCustomMainColor];
        [self.selectedBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];

//        self.photoImageView.hidden = NO;
    }else{
        
        [self.selectedBtn setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F5"]];
        [self.selectedBtn setTitleColor:kBlackColor forState:UIControlStateNormal];

//        self.photoImageView.hidden = YES;
    }
    
}
- (void)setNumberModel:(AddNumberModel *)numberModel
{
    
    
    _numberModel = numberModel;
}

@end
