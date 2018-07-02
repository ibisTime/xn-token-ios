//
//  RedEnvelopeHeadView.h
//  Coin
//
//  Created by QinBao Zheng on 2018/7/2.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol RedEnvelopeHeadDelegate <NSObject>

-(void)RedEnvelopeHeadButton:(NSInteger)tag;

@end

@interface RedEnvelopeHeadView : UIView

//@property (nonatomic, strong) CurrencyModel *platform;



@property (nonatomic, assign) id <RedEnvelopeHeadDelegate> delegate;

@property (nonatomic , strong)UIButton *backButton;

@property (nonatomic , strong)UILabel *nameLabel;

@property (nonatomic , strong)UIButton *recordButton;


@end
