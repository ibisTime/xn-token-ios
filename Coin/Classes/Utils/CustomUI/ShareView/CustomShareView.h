//
//  CustomShareView.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/26.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomShareView;

@protocol CustomShareViewDelegate <NSObject>

- (void)customShareViewButtonAction:(CustomShareView *)shareView title:(NSString *)title;

@end

typedef void(^CancleBlock)();

@interface CustomShareView : UIView

@property (nonatomic, weak) id<CustomShareViewDelegate> delegate;

@property (nonatomic, copy) CancleBlock cancleBlock;

- (void)setShareAry:(NSArray *)shareAry delegate:(id)delegate;

@end
