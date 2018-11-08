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
#import "Masonry.h"

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
//        self.selectedBtn.layer.cornerRadius = 4.0;
        self.selectedBtn.layer.borderColor = kLineColor.CGColor;
        self.selectedBtn.layer.borderWidth=1;
        self.selectedBtn.frame = self.bounds;
        
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
        [self.selectedBtn setBackgroundColor:kHexColor(@"#F8F8F8")];
        [self.selectedBtn setTitleColor:kHexColor(@"#CCCCCC") forState:UIControlStateNormal];

//        self.photoImageView.hidden = NO;
    }else{
        
        [self.selectedBtn setBackgroundColor:kWhiteColor];
        [self.selectedBtn setTitleColor:kTextBlack forState:UIControlStateNormal];

//        self.photoImageView.hidden = YES;
    }
    
}
- (void)setNumberModel:(AddNumberModel *)numberModel
{
    
    
    _numberModel = numberModel;
}

@end
