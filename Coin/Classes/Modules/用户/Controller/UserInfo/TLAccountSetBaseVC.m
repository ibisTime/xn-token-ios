//
//  ZHAccountSetBaseVC.m
//  ZHBusiness
//
//  Created by  蔡卓越 on 2016/12/12.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "TLAccountSetBaseVC.h"

@interface TLAccountSetBaseVC ()

@end

@implementation TLAccountSetBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgSV = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _bgSV.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.bgSV.contentSize = CGSizeMake(kScreenWidth, kSuperViewHeight + 1);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.bgSV addGestureRecognizer:tap];
    [self.view addSubview:_bgSV];
    
    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{
//                                     NSForegroundColorAttributeName : [UIColor whiteColor]
//                                     }];
}

- (void)tap {
    
    [self.view endEditing:YES];
    
}



@end
