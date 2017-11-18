//
//  PublishBuyVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "PublishBuyVC.h"
#import "PublishBuyView.h"

#import "UIBarButtonItem+convience.h"

@interface PublishBuyVC ()
//
@property (nonatomic, strong) PublishBuyView *publishView;
//底部按钮
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation PublishBuyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"发布购买";
    //保留草稿
    [self addRightItem];
    //发布购买
    [self initPublishView];
    //发布按钮
    [self initBottomView];
}

#pragma mark - Init
- (void)addRightItem {
    
    [UIBarButtonItem addRightItemWithTitle:@"保留草稿" titleColor:kTextColor frame:CGRectMake(0, 0, 100, 44) vc:self action:@selector(keepDraft)];
}

- (void)initPublishView {
    
    self.publishView = [[PublishBuyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 60 - kBottomInsetHeight)];
    
    self.publishView.backgroundColor = kBackgroundColor;
    
    [self.view addSubview:self.publishView];
}

- (void)initBottomView {
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kSuperViewHeight - 60 - kBottomInsetHeight, kScreenWidth, 60)];
    
    self.bottomView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:self.bottomView];
}

#pragma mark - Events
- (void)keepDraft {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
