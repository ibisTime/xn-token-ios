//
//  CommentTableView.h
//  Coin
//
//  Created by shaojianfei on 2018/8/13.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLTableView.h"
#import "utxoModel.h"
@interface CommentTableView : TLTableView
@property (nonatomic, strong) NSArray <utxoModel *>*utxis;

@property (nonatomic, assign) CGFloat owHeight;

@property (nonatomic, assign) CGFloat Height;

@property (nonatomic, copy) NSString *address;

@end
