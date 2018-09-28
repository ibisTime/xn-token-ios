//
//  PosBuyIntroduceCell.h
//  Coin
//
//  Created by QinBao Zheng on 2018/9/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLtakeMoneyModel.h"
@protocol AddAndreductionDelegate <NSObject>

-(void)addAndreductionButton:(UIButton *)sender;

-(void)sliderActionUISlider:(UISlider *)slider;

@end

@interface PosBuyIntroduceCell : UITableViewCell

@property (nonatomic ,strong) TLtakeMoneyModel *moneyModel;

@property (nonatomic, assign) id <AddAndreductionDelegate> delegate;

@property (nonatomic , strong)UISlider *mySlider;

@property (nonatomic , strong)UILabel *numberLabel;
@property (nonatomic , strong)UILabel *titleLbl;

@end
