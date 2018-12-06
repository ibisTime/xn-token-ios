//
//  TheGameCollCell.h
//  Coin
//
//  Created by 郑勤宝 on 2018/12/3.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindTheGameModel.h"
@interface TheGameCollCell : UICollectionViewCell

@property (nonatomic , strong)UIButton *actionBtn;


@property (nonatomic , strong)FindTheGameModel *GameModel;

@end
