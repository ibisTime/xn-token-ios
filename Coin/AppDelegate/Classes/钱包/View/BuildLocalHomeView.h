//
//  BuildLocalHomeView.h
//  Coin
//
//  Created by shaojianfei on 2018/7/20.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^WalletBuildBlock)(void);

typedef void(^WalletimportBlock)(void);

@interface BuildLocalHomeView : UIView


@property (nonatomic ,copy) WalletBuildBlock  buildBlock ;

@property (nonatomic ,copy) WalletimportBlock  importBlock ;
@end
