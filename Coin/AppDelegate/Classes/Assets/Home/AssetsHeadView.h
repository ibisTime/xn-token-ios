//
//  AssetsHeadView.h
//  Coin
//
//  Created by 郑勤宝 on 2018/11/22.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AssetsHeadViewDelegate <NSObject>

-(void)AssetsHeadViewDelegateSelectBtn:(NSInteger)tag;

-(void)SlidingIsWallet:(NSString *)WalletName;



@end


@interface AssetsHeadView : UIView
@property (nonatomic, assign) id <AssetsHeadViewDelegate> delegate;

@property (nonatomic , copy)NSString *usdRate;

@property (nonatomic , strong)NSDictionary *dataDic;

@property (nonatomic , strong)UILabel *announcementlbl;
@property (nonatomic , strong)UIImageView *bottomIV;
@property (nonatomic , strong)UIImageView *topIV;



@end
