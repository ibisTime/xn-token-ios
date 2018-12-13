//
//  FindTheGameHeadCell.m
//  Coin
//
//  Created by 郑勤宝 on 2018/12/4.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "FindTheGameHeadCell.h"

@implementation FindTheGameHeadCell
{
    UIImageView *headImage;
    UILabel *nameLabel;
    UILabel *provenance;
    UILabel *numberLabel;
    UILabel *downloadLabel;
    UILabel *volumeLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        headImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 90, 90)];
//        headImage.image =  kImage(@"起始业背景");
        kViewRadius(headImage, 6.5);
        [self addSubview:headImage];
        
        
        
        UIButton *actionBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"开始游戏" key:nil] titleColor:kHexColor(@"#0064ff") backgroundColor:kClearColor titleFont:14];
        [actionBtn sizeToFit];
        self.actionBtn = actionBtn;
        actionBtn.frame = CGRectMake(SCREEN_WIDTH - 20 - actionBtn.width - 30, 12 + 20 - 5, actionBtn.width + 30, 35);
        kViewBorderRadius(actionBtn, 6.5, 1, kHexColor(@"#0064ff"));
        [self addSubview:actionBtn];
        
        nameLabel = [UILabel labelWithFrame:CGRectMake(headImage.xx + 15, 20, SCREEN_WIDTH - headImage.xx - actionBtn.width - 20 - 30, 18) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:HGboldfont(18) textColor:[UIColor blackColor]];
        [self addSubview:nameLabel];
        
        provenance = [UILabel labelWithFrame:CGRectMake(headImage.xx + 15, nameLabel.yy + 11 , SCREEN_WIDTH - headImage.xx - actionBtn.width - 20 - 30, 12) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(12) textColor:[UIColor blackColor]];
//        provenance.text = @"网友游戏出品";
        [self addSubview:provenance];
        
        
        
        NSArray *array = @[@"评分",@"下载量",@"成交量"];
//        NSArray *numberArray = @[@"",@"6856",@"88553ETH/天"];
        for (int i = 0; i < 3 ; i ++) {
            UILabel *attributeLabel = [UILabel labelWithFrame:CGRectMake(i % 3 * SCREEN_WIDTH/3, headImage.yy + 26, SCREEN_WIDTH/3, 14) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(12) textColor:RGB(146, 146, 146)];
            attributeLabel.text = [LangSwitcher switchLang:array[i] key:nil];
            [self addSubview:attributeLabel];
            
            
            if (i != 0) {
                UILabel *Label = [UILabel labelWithFrame:CGRectMake(i % 3 * SCREEN_WIDTH/3, headImage.yy + 50, SCREEN_WIDTH/3, 14) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#000000")];
//                Label.text = numberArray[i];
                if (i == 1) {
                    downloadLabel = Label;
                }else if (i == 2)
                {
                    volumeLabel = Label;
                }
                [self addSubview:Label];
            }
        }
        
        for (int i = 0; i < 5; i ++) {
            UIImageView *garyImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3/2 - 50 + 10 + i % 5 * 12, headImage.yy + 50 + 2, 10, 10)];
            
            garyImg.image = kImage(@"多边形灰色");
            garyImg.tag = 1000 + i;
            [self addSubview:garyImg];
            
            if (i == 4) {
                numberLabel = [UILabel labelWithFrame:CGRectMake(garyImg.xx + 4, headImage.yy + 50, 40, 14) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#000000")];
                numberLabel.text = @"(0.0)";
                [self addSubview:numberLabel];
            }
        }
    }
    return self;
}

-(void)setGameModel:(FindTheGameModel *)GameModel
{
    nameLabel.text = GameModel.name;
    [headImage sd_setImageWithURL:[NSURL URLWithString:[GameModel.picList convertImageUrl]]];
    provenance.text = GameModel.company;
    
    
    UIImageView *image1 = [self viewWithTag:1000];
    UIImageView *image2 = [self viewWithTag:1001];
    UIImageView *image3 = [self viewWithTag:1002];
    UIImageView *image4 = [self viewWithTag:1003];
    UIImageView *image5 = [self viewWithTag:1004];
    
    for (int i = 0; i < GameModel.labelList.count; i ++) {
        if (i == 8) {
            return;
        }
        UILabel *theLabel = [UILabel labelWithFrame:CGRectMake(headImage.xx + 15 + i % 4 * (SCREEN_WIDTH - headImage.xx - 15 - 15)/4 , provenance.yy + 8  + i / 4 * (28), (SCREEN_WIDTH - headImage.xx - 15 - 15 - 9)/4, 24) textAligment:(NSTextAlignmentCenter) backgroundColor:RGB(247, 201, 84) font:FONT(12) textColor:kWhiteColor];
        theLabel.text = GameModel.labelList[i];
        kViewRadius(theLabel, 12);
        [self addSubview:theLabel];
    }
    
    
    switch ([GameModel.grade integerValue]) {
    
        case 1:
        {
            numberLabel.text = @"(1.0)";
            image1.image = kImage(@"多边形亮色");
            image2.image = kImage(@"多边形灰色");
            image3.image = kImage(@"多边形灰色");
            image4.image = kImage(@"多边形灰色");
            image5.image = kImage(@"多边形灰色");
        }
            break;
        case 2:
        {
            numberLabel.text = @"(2.0)";
            image1.image = kImage(@"多边形亮色");
            image2.image = kImage(@"多边形亮色");
            image3.image = kImage(@"多边形灰色");
            image4.image = kImage(@"多边形灰色");
            image5.image = kImage(@"多边形灰色");
        }
            break;
        case 3:
        {
            numberLabel.text = @"(3.0)";
            image1.image = kImage(@"多边形亮色");
            image2.image = kImage(@"多边形亮色");
            image3.image = kImage(@"多边形亮色");
            image4.image = kImage(@"多边形灰色");
            image5.image = kImage(@"多边形灰色");
        }
            break;
        case 4:
        {
            numberLabel.text = @"(4.0)";
            image1.image = kImage(@"多边形亮色");
            image2.image = kImage(@"多边形亮色");
            image3.image = kImage(@"多边形亮色");
            image4.image = kImage(@"多边形亮色");
            image5.image = kImage(@"多边形灰色");
        }
            break;
        case 5:
        {
            numberLabel.text = @"(5.0)";
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
    
    
    downloadLabel.text = GameModel.download;
    volumeLabel.text = GameModel.volume;
//    if (GameModel) {
//        <#statements#>
//    }
}

@end
