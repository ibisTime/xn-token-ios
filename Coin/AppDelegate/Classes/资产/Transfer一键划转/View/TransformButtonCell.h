//
//  TransformButtonCell.h
//  Coin
//
//  Created by 郑勤宝 on 2018/10/25.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyModel.h"

@protocol TransformButtonDelegate <NSObject>

-(void)SelectTheButton:(UIButton *)sender;

@end

@interface TransformButtonCell : UITableViewCell

@property (nonatomic, assign) id <TransformButtonDelegate> SelectDelegate;
@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*models;

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIView  *selectedView;



@end
