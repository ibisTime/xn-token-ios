//
//  ZHAccountBaseVC.m
//  ZHBusiness
//
//  Created by  蔡卓越 on 2016/12/12.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "TLAccountBaseVC.h"

@interface TLAccountBaseVC ()

@end

@implementation TLAccountBaseVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];


}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor backgroundColor];
    
    //---//--//
    self.bgSV = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _bgSV.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.bgSV.contentSize = CGSizeMake(kScreenWidth, kScreenHeight + 1);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.bgSV addGestureRecognizer:tap];
    [self.view addSubview:_bgSV];

}

- (UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleDefault;
    
}

- (void)tap {

    [self.view endEditing:YES];
}

@end
