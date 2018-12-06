//
//  TheGameCollCell.m
//  Coin
//
//  Created by 郑勤宝 on 2018/12/3.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "TheGameCollCell.h"

@implementation TheGameCollCell
{
    UIImageView *gameImg;
    UILabel *nameLbl;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 30)/2, (SCREEN_WIDTH - 30)/2/340 * 220)];
        
        backView.layer.cornerRadius=10;
        backView.layer.shadowOpacity = 0.22;// 阴影透明度
        backView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
        backView.layer.shadowRadius=3;// 阴影扩散的范围控制
        backView.layer.shadowOffset = CGSizeMake(1, 1);// 阴
        backView.backgroundColor = kWhiteColor;
        
        [self addSubview:backView];
        
        gameImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 30)/2/340 * 150,(SCREEN_WIDTH - 30)/2/340 * 220)];
        gameImg.image = kImage(@"起始业背景");
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:gameImg.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = gameImg.bounds;
        maskLayer.path = maskPath.CGPath;
        gameImg.layer.mask = maskLayer;
        [self addSubview:gameImg];
        
        
        nameLbl = [UILabel labelWithFrame:CGRectMake(gameImg.xx + 10 , 11, (SCREEN_WIDTH - 30)/2 - gameImg.width - 20, 0) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#000000")];
        nameLbl.numberOfLines = 2;
        [self addSubview:nameLbl];
        
        for (int i = 0; i < 5; i ++) {
            UIImageView *garyImg = [[UIImageView alloc]initWithFrame:CGRectMake(gameImg.xx + 10 + i % 5 * 12, (SCREEN_WIDTH - 30)/2/340 * 220 - 36 - 16, 10, 10)];
            garyImg.image = kImage(@"多边形灰色");
            garyImg.tag = 1000 + i;
            [self addSubview:garyImg];
        }
        
        
        UIButton *actionBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"开始" key:nil] titleColor:kHexColor(@"#0064ff") backgroundColor:kClearColor titleFont:12];
        kViewBorderRadius(actionBtn, 15, 1, kHexColor(@"#0064ff"));
        self.actionBtn = actionBtn;
        actionBtn.frame = CGRectMake(gameImg.width + ((SCREEN_WIDTH - 30)/2 - gameImg.width)/2 - 40, (SCREEN_WIDTH - 30)/2/340 * 220 - 36, 80, 30);
        [self addSubview:actionBtn];
        
    }
    return self;
}

-(void)setGameModel:(FindTheGameModel *)GameModel
{
    nameLbl.text = GameModel.name;
    [nameLbl sizeToFit];
    [gameImg sd_setImageWithURL:[NSURL URLWithString:[GameModel.picIcon convertImageUrl]]];
    
    UIImageView *image1 = [self viewWithTag:1000];
    UIImageView *image2 = [self viewWithTag:1001];
    UIImageView *image3 = [self viewWithTag:1002];
    UIImageView *image4 = [self viewWithTag:1003];
    UIImageView *image5 = [self viewWithTag:1004];
    
    switch ([GameModel.grade integerValue]) {
            
        case 1:
        {
            image1.image = kImage(@"多边形亮色");
            image2.image = kImage(@"多边形灰色");
            image3.image = kImage(@"多边形灰色");
            image4.image = kImage(@"多边形灰色");
            image5.image = kImage(@"多边形灰色");
        }
            break;
        case 2:
        {
            image1.image = kImage(@"多边形亮色");
            image2.image = kImage(@"多边形亮色");
            image3.image = kImage(@"多边形灰色");
            image4.image = kImage(@"多边形灰色");
            image5.image = kImage(@"多边形灰色");
        }
            break;
        case 3:
        {
            image1.image = kImage(@"多边形亮色");
            image2.image = kImage(@"多边形亮色");
            image3.image = kImage(@"多边形亮色");
            image4.image = kImage(@"多边形灰色");
            image5.image = kImage(@"多边形灰色");
        }
            break;
        case 4:
        {
            image1.image = kImage(@"多边形亮色");
            image2.image = kImage(@"多边形亮色");
            image3.image = kImage(@"多边形亮色");
            image4.image = kImage(@"多边形亮色");
            image5.image = kImage(@"多边形灰色");
        }
            break;
        case 5:
        {
            image1.image = kImage(@"多边形亮色");
            image2.image = kImage(@"多边形亮色");
            image3.image = kImage(@"多边形亮色");
            image4.image = kImage(@"多边形亮色");
            image5.image = kImage(@"多边形亮色");
        }
            break;
            
        default:
            break;
    }
    
}

@end
