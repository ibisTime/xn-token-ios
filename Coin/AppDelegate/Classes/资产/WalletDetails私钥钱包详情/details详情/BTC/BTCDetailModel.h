//
//  BTCDetailModel.h
//  Coin
//
//  Created by shaojianfei on 2018/8/13.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTCDetailModel : UITableViewCell

@property (nonatomic, strong) NSArray *localInfo;

@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UILabel *titleLbl;


- (void)localInfoWithData : (NSArray *)arr index :(NSInteger)inter;

- (void)localInfoWithRightData : (NSArray *)arr index :(NSInteger)inter;

@end
