//
//  PublishBuyCell1.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "PublishBuyCell1.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"

@interface PublishBuyCell1 ()

//leftText
@property (nonatomic, strong) UILabel *leftTextLbl;
//rightText
@property (nonatomic, strong) UILabel *rightTextLbl;
//UITextField
@property (nonatomic, strong) UITextField *textTF;
//button
@property (nonatomic, strong) UIButton *promptBtn;
//arrow
@property (nonatomic, strong) UIImageView *arrowIV;

@end

@implementation PublishBuyCell1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    //提示
    self.promptBtn = [UIButton buttonWithImageName:@"问号"];
    
    [self addSubview:self.promptBtn];
    [self.promptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(0);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(45));
        make.height.equalTo(@(50));
        
    }];
    
    //leftText
    self.leftTextLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    [self addSubview:self.leftTextLbl];
    [self.leftTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@70);
        
    }];
    
    //rightText
    self.rightTextLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    [self addSubview:self.rightTextLbl];
    [self.rightTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@70);
        
    }];
}

@end
