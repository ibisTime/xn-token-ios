//
//  TheInitialView.h
//  Coin
//
//  Created by 郑勤宝 on 2018/11/12.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TheInitialViewBtnDelegate <NSObject>

-(void)TheInitialViewBtnClick:(NSInteger)tag;

@end
@interface TheInitialView : UIView<UIScrollViewDelegate>

@property (nonatomic, assign) id <TheInitialViewBtnDelegate> delegate;

@property (nonatomic , strong)UIView *dynamicLineView;

@end
