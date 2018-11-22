//
//  UserModel.h
//  Coin
//
//  Created by 郑勤宝 on 2018/11/6.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJAnimationPopView.h"
@interface UserModel : NSObject

@property (nonatomic , strong)ZJAnimationPopView *cusPopView;

+ (instancetype)user;
//
+(NSMutableAttributedString *)ReturnsTheDistanceBetween:(NSString *)str;

-(void)showPopAnimationWithAnimationStyle:(NSInteger)style showView:(UIView *)showView;
-(void)phoneCode:(UIButton *)sender;

- (BOOL)isStringContainNumberWith:(NSString *)str;
- (BOOL)isStringTheCapitalLettersWith:(NSString *)str;
- (BOOL)isStringLowercaseLettersWith:(NSString *)str;

@end
