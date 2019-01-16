//
//  GuideTheFigureView.h
//  Coin
//
//  Created by 郑勤宝 on 2018/12/5.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GuideTheFigureDelegate <NSObject>

-(void)GuideTheFigureButton;

@end


@interface GuideTheFigureView : UIView

@property (nonatomic, assign) id <GuideTheFigureDelegate> delegate;

@property (nonatomic , strong)UIButton *iKonwBtn1;

@end
