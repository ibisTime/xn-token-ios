//
//  ZHAccountSetBaseVC.m
//  ZHBusiness
//
//  Created by  蔡卓越 on 2016/12/12.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "TLAccountSetBaseVC.h"
#import <CDCommon/UIScrollView+TLAdd.h>
#import "AppColorMacro.h"

@interface TLAccountSetBaseVC ()

@end

@implementation TLAccountSetBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgSV = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    self.bgSV.backgroundColor = kBackgroundColor;
    
    _bgSV.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.bgSV.contentSize = CGSizeMake(kScreenWidth, kSuperViewHeight + 1);
    
    [self.bgSV adjustsContentInsets];
    
    [self.view addSubview:_bgSV];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    
    [self.bgSV addGestureRecognizer:tap];
    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{
//                                     NSForegroundColorAttributeName : [UIColor whiteColor]
//                                     }];
}

- (void)tap {
    
    [self.view endEditing:YES];
    
}



@end
