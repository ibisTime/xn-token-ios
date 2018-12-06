//
//  GameIntroducedCell.h
//  Coin
//
//  Created by 郑勤宝 on 2018/12/4.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYLabel.h"
#import "NSAttributedString+YYText.h"
#import <UIKit/UIKit.h>
#import "FindTheGameModel.h"

@protocol GameIntroducedCellDelegate <NSObject>

-(void)GameIntroducedCellClick;

@end

@interface GameIntroducedCell : UITableViewCell
@property (nonatomic , strong)FindTheGameModel *GameModel;
@property (nonatomic, assign) id <GameIntroducedCellDelegate> delegate;
@property (nonatomic , strong)YYLabel *introduceLbl;

@property (nonatomic , strong)UILabel *introduceLbl1;

@property (nonatomic , strong)UIScrollView *scrollView;

@end
