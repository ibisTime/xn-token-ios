//
//  TestViewController.m
//  Coin
//
//  Created by  tianlei on 2018/2/05.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TestViewController.h"
#import "TLSwitchView.h"
#import "TLUIHeader.h"
#import "TestContentVC.h"

#define BARandomColor      [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0f];



@interface TestViewController ()<TLSwitchViewDelegate>

@property (nonatomic, strong) TLSwitchView *mySwitchView;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    TLSwitchView *mySwitchView = [[TLSwitchView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 400)];
    mySwitchView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:mySwitchView];
    self.mySwitchView = mySwitchView;
    self.mySwitchView.delegate = self;
    mySwitchView.count = 4;
    
}

// delegate
- (UIView *)currentIndex:(NSInteger)index alreadyAdd:(BOOL)already{
    
    NSLog(@"%ld",index);
    if (already) {
        //已经添加不进处理
        return nil;
    }
    
    TestContentVC *contentVC1 = [[TestContentVC alloc] init];
    //添加VC
    [self addChildViewController:contentVC1];
    contentVC1.view.backgroundColor = BARandomColor;
    return contentVC1.view;
    
}

- (void)adddChild:(NSInteger)index {
    
    TestContentVC *contentVC1 = [[TestContentVC alloc] init];
    
    //添加VC
    [self addChildViewController:contentVC1];
    
    //view添加,
    contentVC1.view.userInteractionEnabled = NO;
    contentVC1.view.frame = CGRectMake(index * 1, 9, SCREEN_WIDTH, 100);
    [self.mySwitchView addSubview:contentVC1.view];
    
}
@end
