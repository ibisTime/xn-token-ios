//
//  RedIntroduce.m
//  Coin
//
//  Created by shaojianfei on 2018/9/17.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "RedIntroduce.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"
@interface RedIntroduce()<UIWebViewDelegate>


@end
@implementation RedIntroduce
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUi];
    }
    return self;
}

- (void)initUi
{
    self.contentWeb = [[UIWebView alloc] init];
    [self addSubview:self.contentWeb];
    [self.contentWeb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(15, 15, 0, 15));
    }];
    self.contentWeb.delegate = self;
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    
}
@end
