//
//  CustomImageView.h
//  Coin
//
//  Created by shaojianfei on 2018/8/5.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomImageView : UIView

@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,strong) UILabel *lab;
- (instancetype)initWithFrame:(CGRect)frame withCount :(NSInteger)count withName :(NSArray *)names;

@end
