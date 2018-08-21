//
//  CustomImageView.m
//  Coin
//
//  Created by shaojianfei on 2018/8/5.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "CustomImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+Extension.h"
@implementation CustomImageView

- (instancetype)initWithFrame:(CGRect)frame withCount:(NSInteger)count withName:(NSArray *)names
{
    self = [super initWithFrame:frame];
    if (self) {
        
        float width = frame.size.width;
        
        UILabel *lab = [[UILabel alloc] init];
        self.lab = lab;
        [self addSubview:lab];
        lab.frame = CGRectMake(0, 10, 80, 30);
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = [UIColor lightGrayColor];
        
        
        NSInteger picCount = [names count];
        //定义每个cell图片
        for (int i=0;i<picCount;i++){
            UIImageView *imageCell;
            if (i == 0 || i ==1 || i == 2) {
              imageCell = [[UIImageView alloc] initWithFrame:CGRectMake(width/4*(i%3)+80, width/4*(i/3)+20, width/4, width/4)];
            }else{
                
                imageCell = [[UIImageView alloc] initWithFrame:CGRectMake(width/4*(i%3), width/4*(i/3)+20, width/4, width/4)];
            }
          
            
            NSString *name = names[i];
            
            [imageCell sd_setImageWithURL:[NSURL URLWithString:[name convertImageUrl]]];
//            imageCell.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[names objectAtIndex:i]]];
            //每当第4个图片时，增加一行，增加整个view的高度
            if (i%3 == 0) {
                
            }
            [self addSubview:imageCell];
        }
      
    }
    return self;
}
-(void)setName:(NSString *)name
{
    
    _name = [name copy];
    self.lab.text = name;
}

@end
