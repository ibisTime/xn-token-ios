//
//  XNBannerCell.m
//  MOOM
//
//  Created by 田磊 on 16/4/12.
//  Copyright © 2016年 田磊. All rights reserved.
//

#import "TLBannerCell.h"
#import "UIImageView+WebCache.h"
#import "AppColorMacro.h"

@interface TLBannerCell ()

@property (nonatomic,weak) UIImageView *imageIV;

@end

@implementation TLBannerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:self.bounds];
        iv.image = GOOD_PLACEHOLDER_SMALL;
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
            
            [_imageIV sd_setImageWithURL:url placeholderImage:GOOD_PLACEHOLDER_SMALL];
            
            return ;
        }
        
        [_imageIV sd_setImageWithURL:url placeholderImage:GOOD_PLACEHOLDER_SMALL];
        return ;
    }
    //本地图片
    self.imageIV.image = [UIImage imageWithContentsOfFile:_urlString];

}

@end
