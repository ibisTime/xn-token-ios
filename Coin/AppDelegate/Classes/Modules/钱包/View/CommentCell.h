//
//  CommentCell.h
//  Coin
//
//  Created by shaojianfei on 2018/8/13.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "utxoModel.h"
@interface CommentCell : UITableViewCell

@property (nonatomic ,strong) utxoModel *utModel;

@property (nonatomic ,strong) UILabel *titleLbl;
@property (nonatomic ,strong) UILabel *rightLabel;
@property (nonatomic ,copy) NSString *address;


@end
