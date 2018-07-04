//
//  MySugarPacketsVC.m
//  Coin
//
//  Created by QinBao Zheng on 2018/7/2.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "MySugarPacketsVC.h"
#import "GetTheVC.h"
#import "SendVC.h"
@interface MySugarPacketsVC ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIScrollView *scroll;
@property (nonatomic, strong)UIButton *selectBtn;

@property (nonatomic, assign)NSInteger currentPages;

//@property (nonatomic, strong)UILabel *WeiGreLabel;
@property (nonatomic, strong)GetTheVC *vc1;
@property (nonatomic, strong)SendVC *vc2;
@property (nonatomic , strong)UIButton *backbButton;
#define kPageCount 2
#define kButton_H 70
#define kMrg 10
#define kTag 1000

@end

@implementation MySugarPacketsVC

-(UIButton *)backbButton
{
    if (!_backbButton) {
        _backbButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _backbButton.frame = CGRectMake(0, 0, 44, 44);
        [_backbButton setImage:kImage(@"返回1") forState:(UIControlStateNormal)];
        [_backbButton addTarget:self action:@selector(buttonMethodClick) forControlEvents:(UIControlEventTouchUpInside)];

    }
    return _backbButton;
}

-(void)buttonMethodClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = [LangSwitcher switchLang:@"我的红包" key:nil];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Georgia-Bold" size:18];
    self.navigationItem.titleView = label;

    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    backView.backgroundColor = HeadBackColor;
    [self.view addSubview:backView];

    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];

    //    negativeSpacer.width = -10;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:self.backbButton]];self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    self.navigationController.navigationBar.titleTextAttributes=
  @{NSForegroundColorAttributeName:[UIColor whiteColor],
    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:18]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = HeadBackColor;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置可以左右滑动的ScrollView
    [self setupScrollView];
    //设置控制的每一个子控制器
    [self setupChildViewControll];
    //设置分页按钮
    [self setupPageButton];

    [self setupSelectBtn];
    [_scroll setContentOffset:CGPointMake(SCREEN_WIDTH * _currentPages, 0) animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setShadowImage:nil];
}

#pragma mark - 设置可以左右滑动的ScrollView
- (void)setupScrollView{

    self.scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kButton_H , SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scroll.pagingEnabled = YES;
    _scroll.delegate = self;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.directionalLockEnabled = YES;

    _scroll.contentSize = CGSizeMake(SCREEN_WIDTH * kPageCount, SCREEN_HEIGHT);
    [self.view addSubview:_scroll];
}

#pragma mark - 设置控制的每一个子控制器
- (void)setupChildViewControll{
    self.vc1 = [[GetTheVC alloc]init];
    self.vc2 = [[SendVC alloc]init];

    //指定该控制器为其子控制器
    [self addChildViewController:_vc1];
    [self addChildViewController:_vc2];


    //将视图加入ScrollView上
    [_scroll addSubview:_vc1.view];
    [_scroll addSubview:_vc2.view];

    //设置两个控制器的尺寸
    _vc1.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _vc2.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

}
#pragma mark - 设置分页按钮
- (void)setupPageButton{
    //button的index值应当从0开始

    UIButton *btn = [self setupButtonWithTitle:[LangSwitcher switchLang:@"抢到红包" key:nil] Index:0];
    [self setupButtonWithTitle:[LangSwitcher switchLang:@"发出红包" key:nil] Index:1];
//    kViewBorderRadius(btn, 0, 2, [UIColor whiteColor]);
    [btn setTitleColor:HeadBackColor forState:(UIControlStateNormal)];
    [btn setBackgroundColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.selectBtn = btn;
}
- (UIButton *)setupButtonWithTitle:(NSString *)title Index:(NSInteger)index{
    CGFloat x = SCREEN_WIDTH/2 - 100 +  index * 100;
    CGFloat y = 15;
    CGFloat w = 100;
    CGFloat h = 40;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:(UIControlStateNormal)];
    btn.frame = CGRectMake(x, y, w, h);
    kViewBorderRadius(btn, 5, 2, [UIColor whiteColor]);
    btn.titleLabel.font = FONT(14);
    btn.tag = index + kTag;
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [btn setBackgroundColor:HeadBackColor forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(pageClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    if (index == 0) {
        UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer=[[CAShapeLayer alloc]init];
        maskLayer.frame=btn.bounds;
        maskLayer.path=maskPath.CGPath;
        btn.layer.mask=maskLayer;
    }else if (index == 0)
    {
        UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer=[[CAShapeLayer alloc]init];
        maskLayer.frame=btn.bounds;
        maskLayer.path=maskPath.CGPath;
        btn.layer.mask=maskLayer;
    }

    return btn;
}

#pragma mark -- 按钮点击方法
- (void)pageClick:(UIButton *)btn
{
    self.currentPages = btn.tag - kTag;
    [self gotoCurrentPage];
}
#pragma mark - 设置选中button的样式
- (void)setupSelectBtn{
    UIButton *btn = [self.view viewWithTag:self.currentPages + kTag];
    if ([self.selectBtn isEqual:btn]) {
        return;
    }
    kViewBorderRadius(self.selectBtn, 5, 2, [UIColor whiteColor]);
    [self.selectBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.selectBtn setBackgroundColor:HeadBackColor forState:(UIControlStateNormal)];

    self.selectBtn = btn;
    kViewBorderRadius(btn, 5, 2, [UIColor whiteColor]);
    [btn setTitleColor:HeadBackColor forState:(UIControlStateNormal)];
    [btn setBackgroundColor:[UIColor whiteColor] forState:(UIControlStateNormal)];

}
#pragma mark -   进入当前的选定页面
- (void)gotoCurrentPage{
    CGRect frame;
    frame.origin.x = self.scroll.frame.size.width * self.currentPages;
    frame.origin.y = 0;
    frame.size = _scroll.frame.size;
    [_scroll scrollRectToVisible:frame animated:YES];
}

#pragma mark - ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = _scroll.frame.size.width;
    self.currentPages = floor((_scroll.contentOffset.x - pageWidth/2)/pageWidth) + 1;
    //设置选中button的样式
    [self setupSelectBtn];
}


@end
