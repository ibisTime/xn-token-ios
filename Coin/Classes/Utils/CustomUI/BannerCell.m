//
//  BannerCell.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BannerCell.h"
#import "UIImageView+WebCache.h"

@interface BannerCell ()

@property (nonatomic,weak) UIImageView *imageIV;

@end

@implementation BannerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:self.bounds];
        
        [self.contentView addSubview:iv];
        iv.clipsToBounds = YES;
        iv.contentMode = UIViewContentModeScaleAspectFill;
        self.imageIV = iv;
    }
    return self;
}

- (void)setUrlString:(NSString *)urlString
{
    _urlString = [urlString copy];
    if ([_urlString hasPrefix:@"http:"]) { //网络图片
        
        NSURL *url = [NSURL URLWithString:urlString];
        if ([urlString containsString:@".gif"]) {
            
            [_imageIV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
            
        } else {
            
            [_imageIV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
            
        }
        
    } else { //本地图片
        
        self.imageIV.image = [UIImage imageWithContentsOfFile:_urlString];
        
    }
    
}

@end
