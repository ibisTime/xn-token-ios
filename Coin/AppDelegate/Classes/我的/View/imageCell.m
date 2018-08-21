//
//  imageCell.m
//  Coin
//
//  Created by shaojianfei on 2018/8/5.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "imageCell.h"
#import "UILable+convience.h"
#import "AppColorMacro.h"
#import "UIButton+Custom.h"
#import <Masonry/Masonry.h>
#import "NSString+Date.h"
#import "TLUser.h"
#import "NSString+Extension.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface imageCell()
@property (nonatomic , strong) UILabel *nameLab;

@property (nonatomic , strong) UIImageView *imageView1;

@end
@implementation imageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

- (void)initSubviews
{
    
    self.nameLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    [self addSubview:self.nameLab];
    
    
    
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
        image.frame = CGRectMake(marge*i + i*w , marge*i+10 +i*h, w, h);
        NSString *str = imageArray[i];
        NSURL *u = [NSURL URLWithString:str];
        [image sd_setImageWithURL:u];
//        [image sd_setImageWithURL:u];
    }
    [self setNeedsDisplay];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
