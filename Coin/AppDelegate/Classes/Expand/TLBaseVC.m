//
//  TLBaseVC.m
//  WeRide
//
//  Created by  tianlei on 2016/11/25.
//  Copyright © 2016年 trek. All rights reserved.
//

#import "TLBaseVC.h"

#import "UIColor+theme.h"
#import "AppColorMacro.h"

@interface TLBaseVC ()<UIGestureRecognizerDelegate,UINavigationBarDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation TLBaseVC {

    UILabel *_placeholderTitleLbl;
    UIButton *_opBtn;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;


    self.view.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];

//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
//    self.navigationItem.backBarButtonItem = backItem;
//    self.view.backgroundColor = [UIColor backgroundColor];
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.backBarButtonItem = backItem;
    //navigation底部分割线
//    self.navigationController.navigationBar.shadowImage = [kLineColor convertToImage];

//    self.view.backgroundColor  =[UIColor whiteColor];



//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//
    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"返回 白色"];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"返回 白色"];


}




//-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan
//{
//    CGPoint velocity = [pan velocityInView:pan.view];
//    if(velocity.x>0)
//
//    {
//
//        　　//向右滑动
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//
//    else
//
//    {
////        [self.navigationController popViewControllerAnimated:YES];
//        //向左滑动
//
//    }
//
//}


//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    return YES;
//}







- (void)viewWillAppear:(BOOL)animated
{
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setShadowImage:nil];
}

// 如果tableview在视图最底层 默认会偏移电池栏的高度
- (void)setViewEdgeInset {
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setTitle:(NSString *)title {

    self.navigationItem.titleView = [UILabel labelWithNaTitle:title frame:CGRectMake(0, 0, 200, 44)];
//    self.titleStr = title;

}
////隐藏底部横条
//- (BOOL)prefersHomeIndicatorAutoHidden {
//
//    return YES;
//}

- (void)removePlaceholderView {

    if (self.tl_placeholderView) {
        
        [self.tl_placeholderView removeFromSuperview];

    }
    
}

- (void)addPlaceholderView{

    if (self.tl_placeholderView) {
        
        [self.view addSubview:self.tl_placeholderView];
        
    }

}

- (void)setPlaceholderViewTitle:(NSString *)title  operationTitle:(NSString *)opTitle {

    if (self.tl_placeholderView) {
        
        _placeholderTitleLbl.text = title;
        [_opBtn setTitle:opTitle forState:UIControlStateNormal];
        
    } else {
    
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = self.view.backgroundColor;
        UILabel *lbl = [UILabel labelWithFrame:CGRectMake(0, 100, view.width, 50) textAligment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:15] textColor:[UIColor textColor]];
        [view addSubview:lbl];
        lbl.text = title;
        _placeholderTitleLbl = lbl;
        
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, lbl.yy + 10, 200, 40)];
        [self.view addSubview:btn];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
        btn.centerX = view.width/2.0;
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor textColor].CGColor;
        [btn addTarget:self action:@selector(tl_placeholderOperation) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:opTitle forState:UIControlStateNormal];
        [view addSubview:btn];
        _opBtn = btn;
        _tl_placeholderView = view;
    
    }

}






#pragma mark- 站位操作
- (void)tl_placeholderOperation {

    if ([self isMemberOfClass:NSClassFromString(@"TLBaseVC")]) {

        NSLog(@"子类请重写该方法");

    }

}
#pragma mark - Setting

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    
//    return UIStatusBarStyleLightContent;
//    
//}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    NSLog(@"收到内存警告---%@",NSStringFromClass([self class]));
    
}

@end
