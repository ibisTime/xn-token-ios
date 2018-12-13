//
//  FindTheGameVC.h
//  Coin
//
//  Created by 郑勤宝 on 2018/12/4.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "TLBaseVC.h"
#import "FindTheGameModel.h"
@interface FindTheGameVC : TLBaseVC

@property (nonatomic , strong)FindTheGameModel *GameModel;

@property (nonatomic , copy)NSString *url;
@end
