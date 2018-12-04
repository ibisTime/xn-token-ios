//
//  GameIntroducedCell.m
//  Coin
//
//  Created by 郑勤宝 on 2018/12/4.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "GameIntroducedCell.h"

@implementation GameIntroducedCell
{
    UIButton *button;
    UIView *lineView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        NSMutableAttributedString *text = [NSMutableAttributedString new];
//        UIFont *font = [UIFont systemFontOfSize:16];
        
        // 添加文本
        NSString *title = @"游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍";
        
        [text appendAttributedString:[UserModel ReturnsTheDistanceBetween:title]];
        
        text.yy_font = FONT(12) ;
        _introduceLbl = [YYLabel new];
//        _introduceLbl.backgroundColor = [UIColor redColor];
        _introduceLbl.userInteractionEnabled = YES;
        _introduceLbl.numberOfLines = 4;
        _introduceLbl.textVerticalAlignment = YYTextVerticalAlignmentTop;
        _introduceLbl.frame = CGRectMake(20,3, SCREEN_WIDTH-40,70);
//        [_introduceLbl sizeToFit];
//        _introduceLbl.frame = CGRectMake(20,3, SCREEN_WIDTH-40,_introduceLbl1.height);
        _introduceLbl.attributedText = text;
        
        [self addSubview:_introduceLbl];
        
        
        _introduceLbl1 = [UILabel labelWithFrame:CGRectMake(20,3, SCREEN_WIDTH-40,67) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(12) textColor:[UIColor blackColor]];
        _introduceLbl1.attributedText = [self ReturnsTheDistanceBetween:title];
        _introduceLbl1.numberOfLines = 0;
        [_introduceLbl1 sizeToFit];
        
        [self addSubview:_introduceLbl1];
        
        _introduceLbl1.hidden = YES;
        [_introduceLbl1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap)]];
        _introduceLbl1.userInteractionEnabled = YES;
        
        lineView = [[UIView alloc]init];
        if (_introduceLbl.height > _introduceLbl1.height) {
            lineView.frame =CGRectMake(20, _introduceLbl1.yy + 21, SCREEN_WIDTH - 40, 1);
        }else
        {
            lineView.frame =CGRectMake(20, _introduceLbl.yy + 21, SCREEN_WIDTH - 40, 1);
        }
        lineView.backgroundColor = RGB(163, 163, 163);
        [self addSubview:lineView];
        
        
        // 添加全文
        [self addSeeMoreButton];
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, lineView.yy + 17, SCREEN_WIDTH, 210)];
        self.scrollView.contentSize = CGSizeMake(20 + 152 * 5 + 8, 0);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        
        for (int i = 0; i < 5; i ++) {
            
            UIImageView *showImage = [[UIImageView alloc]initWithFrame:CGRectMake(20 + i % 5 * 152, 0, 140, 210)];
            showImage.image = kImage(@"起始业背景");
            kViewRadius(showImage, 6.5);
            [self.scrollView addSubview:showImage];
            
        }
        
    }
    return self;
}

-(void)labelTap
{
    _introduceLbl1.hidden = YES;
    _introduceLbl.hidden = NO;
    
    lineView.frame =CGRectMake(20, _introduceLbl.yy + 21, SCREEN_WIDTH - 40, 1);
    
    self.scrollView.frame = CGRectMake(0, lineView.yy + 17, SCREEN_WIDTH, 210);
    [self.delegate GameIntroducedCellClick];
}

-(NSMutableAttributedString *)ReturnsTheDistanceBetween:(NSString *)str
{
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置
    [paragraphStyle  setLineSpacing:3.5];
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:str];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    return setString;
}


#pragma mark - 添加全文
- (void)addSeeMoreButton {
    __weak __typeof(self) weakSelf = self;
    
    NSMutableAttributedString *text = [UserModel ReturnsTheDistanceBetween:@"... 展开"];
    
    YYTextHighlight *hi = [YYTextHighlight new];
    [hi setColor:[UIColor colorWithRed:0.578 green:0.790 blue:1.000 alpha:1.000]];
    

    hi.tapAction = ^(UIView *containerView,NSAttributedString *text,NSRange range, CGRect rect) {
        
        
        weakSelf.introduceLbl1.hidden = NO;
        weakSelf.introduceLbl.hidden = YES;
        lineView.frame =CGRectMake(20, _introduceLbl1.yy + 21, SCREEN_WIDTH - 40, 1);
        self.scrollView.frame = CGRectMake(0, lineView.yy + 17, SCREEN_WIDTH, 210);
//        [self addSubview:weakSelf.introduceLbl1];
        [self.delegate GameIntroducedCellClick];
    };
    
    
    [text yy_setColor:[UIColor colorWithRed:0.000 green:0.449 blue:1.000 alpha:1.000] range:[text.string rangeOfString:@"展开"]];
    [text yy_setTextHighlight:hi range:[text.string rangeOfString:@"展开"]];
    text.yy_font =_introduceLbl.font;
    
    
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    [seeMore sizeToFit];
    
    
    NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:text.yy_font alignment:YYTextVerticalAlignmentTop];
    
    _introduceLbl.truncationToken = truncationToken;
}







@end
