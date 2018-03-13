//
//  StoreCell.m
//  OGC
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "StoreCell.h"
//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Category
#import "NSString+Extension.h"
//Extension
#import <UIImageView+WebCache.h>

@interface StoreCell()
//店铺图片
@property (nonatomic, strong) UIImageView *storeIV;
//店铺名称
@property (nonatomic, strong) UILabel *nameLbl;
//店铺说明
@property (nonatomic, strong) UILabel *descLbl;
//店铺地址
@property (nonatomic, strong) UILabel *addressLbl;

@end

@implementation StoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //店铺图片
    self.storeIV = [[UIImageView alloc] init];
    
    self.storeIV.contentMode = UIViewContentModeScaleAspectFill;
    self.storeIV.clipsToBounds = YES;
    
    [self addSubview:self.storeIV];
    
    //店铺名称
    self.nameLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor clearColor]
                                      font:Font(15.0)
                                 textColor:kTextColor];
    
    self.nameLbl.numberOfLines = 0;
    
    [self addSubview:self.nameLbl];
    //店铺说明
    self.descLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor2
                                                font:14.0];
    self.descLbl.numberOfLines = 0;
    
    [self addSubview:self.descLbl];
    //店铺地址
    self.addressLbl = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:kTextColor
                                                   font:13.0];
    [self addSubview:self.addressLbl];
    
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    CGFloat leftMargin = 15;
    
    //店铺图片
    [self.storeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@(leftMargin));
        make.width.equalTo(@(100));
        make.height.equalTo(@80);
    }];
    //店铺名称
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.storeIV.mas_right).offset(leftMargin);
        make.top.equalTo(self.storeIV.mas_top).offset(8);
        make.right.equalTo(@(-leftMargin));
        make.height.lessThanOrEqualTo(@40);
    }];
    //店铺说明
    [self.descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.top.equalTo(self.nameLbl.mas_bottom).offset(6);
        make.right.equalTo(@(-leftMargin));
        make.height.lessThanOrEqualTo(@20);
    }];
    //店铺地址
    [self.addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.bottom.equalTo(self.storeIV.mas_bottom).offset(-5);
        make.right.equalTo(@(-15));
    }];

}

#pragma mark - Setting
- (void)setStore:(StoreModel *)store {
    
    _store = store;
    
    [_storeIV sd_setImageWithURL:[NSURL URLWithString:[store.pic convertImageUrl]] placeholderImage:GOOD_PLACEHOLDER_SMALL];
    
    _nameLbl.text = store.name;
    _descLbl.text = store.slogan;
    _addressLbl.text = [NSString stringWithFormat:@"地址: %@", store.address];
    
}

@end
