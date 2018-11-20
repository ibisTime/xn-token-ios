//
//  TheInitialView.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/12.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "TheInitialView.h"

@implementation TheInitialView
{
    UIImageView *backView;
    UIImageView *backView1;
    UIScrollView *scrollView;
}



//3D透视函数
CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ)
{
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

//-(BOOL)touchesShouldCancelInContentView:(UIView *)view{
//    if ([view isKindOfClass:[UIButton class]]) {
//
//        return YES;
//    }
//    return [super touchesShouldCancelInContentView:view];
//}
////在触摸事件开始相应前调用
//- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
//{
//
//    if ([view isKindOfClass:[HBSignView class]]||[view isKindOfClass:[UIButton class]]) {
//        return YES;
//    }
//    return NO;
//}




-(void)initView
{
    
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + kStatusBarHeight)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
//    scrollView.userInteractionEnabled=YES;
//    scrollView.delaysContentTouches = NO;
    [self addSubview:scrollView];
    
    backView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.image = kImage(@"安全组");
    [scrollView addSubview:backView];
    
    UILabel *personalWalletLb = [UILabel labelWithFrame:CGRectMake(0, kNavigationBarHeight + 4.5, SCREEN_WIDTH, 30) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(18) textColor:kHexColor(@"#ffffff")];
    personalWalletLb.text = [LangSwitcher switchLang:@"个人钱包" key:nil];
    [backView addSubview:personalWalletLb];
    
    
    UILabel *personalWalletIntroduceLb = [UILabel labelWithFrame:CGRectMake(31, personalWalletLb.yy + 10, SCREEN_WIDTH - 62, 0) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#ffffff")];
    personalWalletIntroduceLb.numberOfLines = 0;
    personalWalletIntroduceLb.attributedText = [UserModel ReturnsTheDistanceBetween:[LangSwitcher switchLang:@"便捷的资产管理，绝对安全的“存入即冷”托管模式。个人钱包还提供了稳定的资产理财方案和趣味应用" key:nil]];
    [personalWalletIntroduceLb sizeToFit];
    [backView addSubview:personalWalletIntroduceLb];
    
    
    UIButton *loginPersonalBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"登录个人账号" key:nil] titleColor:kHexColor(@"#0064ff") backgroundColor:kWhiteColor titleFont:16 cornerRadius:10];
    loginPersonalBtn.frame = CGRectMake(50, backView.yy - 90, SCREEN_WIDTH/2 - 57.5, 40);
    [loginPersonalBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    loginPersonalBtn.tag = 100;
    [scrollView addSubview:loginPersonalBtn];
    
    UIButton *createPersonalBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"创建个人账号" key:nil] titleColor:kHexColor(@"#a7a7a7") backgroundColor:kWhiteColor titleFont:16 cornerRadius:10];
    createPersonalBtn.frame = CGRectMake(SCREEN_WIDTH/2 + 7.5, backView.yy - 90, SCREEN_WIDTH/2 - 57.5, 40);
    [createPersonalBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    createPersonalBtn.tag = 101;
    [scrollView addSubview:createPersonalBtn];
    
    
    
    
    //    私钥
    backView1 =[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView1.image = kImage(@"安全组");
    [scrollView addSubview:backView1];
    
    UILabel *privateWalletLb = [UILabel labelWithFrame:CGRectMake(0, kNavigationBarHeight + 4.5, SCREEN_WIDTH, 30) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(18) textColor:kHexColor(@"#ffffff")];
    privateWalletLb.text = [LangSwitcher switchLang:@"私钥钱包" key:nil];
    [backView1 addSubview:privateWalletLb];
    
    
    UILabel *privateWalletIntroduceLb = [UILabel labelWithFrame:CGRectMake(31, privateWalletLb.yy + 10, SCREEN_WIDTH - 62, 0) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#ffffff")];
    privateWalletIntroduceLb.numberOfLines = 0;
    privateWalletIntroduceLb.attributedText = [UserModel ReturnsTheDistanceBetween:[LangSwitcher switchLang:@"Theia的私钥钱包是一款多链钱包，便捷的管理你的所有链上资产，私钥本地保存，安全可靠。" key:nil]];
    [privateWalletIntroduceLb sizeToFit];
    [backView1 addSubview:privateWalletIntroduceLb];
    
    UIButton *loginPrivateBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"创建私钥钱包" key:nil] titleColor:kHexColor(@"#0064ff") backgroundColor:kWhiteColor titleFont:16 cornerRadius:10];
    loginPrivateBtn.frame = CGRectMake(SCREEN_WIDTH +  50, backView1.yy - 90, SCREEN_WIDTH/2 - 57.5, 40);
    [loginPrivateBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    loginPrivateBtn.tag = 102;
    [scrollView addSubview:loginPrivateBtn];
    
    UIButton *createPrivateBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"导入助记词" key:nil] titleColor:kHexColor(@"#a7a7a7") backgroundColor:kWhiteColor titleFont:16 cornerRadius:10];
    createPrivateBtn.frame = CGRectMake(SCREEN_WIDTH +  SCREEN_WIDTH/2 + 7.5, backView1.yy - 90, SCREEN_WIDTH/2 - 57.5, 40);
    [createPrivateBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    createPrivateBtn.tag = 103;
    [scrollView addSubview:createPrivateBtn];
    
    
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40, SCREEN_HEIGHT  - 90 - 30, 80, 4)];
    lineView.backgroundColor = kHexColor(@"#489fff");
    kViewRadius(lineView, 2);
    [self addSubview:lineView];
    
    UIView *dynamicLineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40, SCREEN_HEIGHT - 90 - 30, 40, 4)];
    self.dynamicLineView = dynamicLineView;
    dynamicLineView.backgroundColor = kHexColor(@"#ffffff");
    kViewRadius(dynamicLineView, 2);
    [self addSubview:dynamicLineView];
    
    _viewArray = @[backView,backView1];
    
}


-(void)btnClick:(UIButton *)sender
{
    [_delegate TheInitialViewBtnClick:sender.tag - 100];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat w = scrollView.contentOffset.x/SCREEN_WIDTH;
    NSLog(@"%.2f",scrollView.contentOffset.x);
    NSLog(@"%.2f",w);
    
    
    
    
    [UIView animateWithDuration:0.1 animations:^{
        self.dynamicLineView.frame = CGRectMake(SCREEN_WIDTH/2 - 40 + w * 40, SCREEN_HEIGHT - 90 - 30, 40, 4);
    }];
    
    
    
    //当前页数
//    NSInteger currentPage=_currentPage;
//    
//    //当前视图
//    UIView *currentView=_viewArray[currentPage];
//    
//    //上一个视图
//    UIView *lastView=nil;
//    
//    if (currentPage-1>=0) {
//        
//        lastView=_viewArray[currentPage-1];
//    }
//    
//    //下一个视图控制器视图
//    UIView *nextView;
//    
//    if (currentPage+1<=1) {
//        
//        nextView=_viewArray[currentPage+1];
//    }
//    
//    //本次偏移距离
//    CGFloat currentOffset=scrollView.contentOffset.x-currentPage*self.bounds.size.width;
//    
//    //本次偏移角度
//    CGFloat deltaAngle=currentOffset/self.bounds.size.width * M_PI_2;
//    
//    //****************当前视图移动变幻***************
//    
//    //设置锚点
//    currentView.layer.anchorPoint=CGPointMake(0.5, 0.5);
//    
//    //向屏幕前方移动
//    CATransform3D move = CATransform3DMakeTranslation(0, 0, self.bounds.size.width/2);
//    
//    //旋转
//    CATransform3D rotate = CATransform3DMakeRotation(-deltaAngle, 0, 1, 0);
//    
//    //平移
//    CATransform3D plaintMove=CATransform3DMakeTranslation( currentOffset, 0, 0);
//    
//    //向屏幕后方移动
//    CATransform3D back = CATransform3DMakeTranslation(0, 0, -self.bounds.size.width/2);
//    
//    //连接
//    CATransform3D concat=CATransform3DConcat( CATransform3DConcat(move, CATransform3DConcat(rotate, plaintMove)),back);
//    
//    CATransform3D transform=CATransform3DPerspect(concat, CGPointMake(currentOffset/2, self.bounds.size.height), 5000.0f);
//    
//    //添加变幻特效
//    currentView.layer.transform=transform;
//    
//    //****************下一个视图移动变幻***************
//    
//    //设置锚点
//    nextView.layer.anchorPoint=CGPointMake(0.5, 0.5);
//    
//    //向屏幕前方移动
//    CATransform3D move2 = CATransform3DMakeTranslation(0, 0, self.bounds.size.width/2);
//    
//    //旋转
//    CATransform3D rotate2 = CATransform3DMakeRotation(-deltaAngle+M_PI_2, 0, 1, 0);
//    
//    //平移
//    CATransform3D plaintMove2=CATransform3DMakeTranslation( currentOffset-self.bounds.size.width, 0, 0);
//    
//    //向屏幕后方移动
//    CATransform3D back2 = CATransform3DMakeTranslation(0, 0, -self.bounds.size.width/2);
//    
//    //拼接
//    CATransform3D concat2=CATransform3DConcat( CATransform3DConcat(move2, CATransform3DConcat(rotate2, plaintMove2)),back2);
//    
//    CATransform3D transform2=CATransform3DPerspect(concat2, CGPointMake(self.bounds.size.width/2+currentOffset/2, self.bounds.size.height), 5000.0f);
//    
//    //添加变幻特效
//    nextView.layer.transform=transform2;
//    
//    //****************上一个视图移动变幻***************
//    
//    //设置锚点
//    lastView.layer.anchorPoint=CGPointMake(0.5, 0.5);
//    
//    //向屏幕前方移动
//    CATransform3D move3 = CATransform3DMakeTranslation(0, 0, self.bounds.size.width/2);
//    
//    //旋转
//    CATransform3D rotate3 = CATransform3DMakeRotation(-deltaAngle-M_PI_2, 0, 1, 0);
//    
//    //平移
//    CATransform3D plaintMove3=CATransform3DMakeTranslation( currentOffset+self.bounds.size.width, 0, 0);
//    
//    //向屏幕后方移动
//    CATransform3D back3 = CATransform3DMakeTranslation(0, 0, -self.bounds.size.width/2);
//    
//    //拼接
//    CATransform3D concat3=CATransform3DConcat(CATransform3DConcat(move3, CATransform3DConcat(rotate3, plaintMove3)),back3);
//    
//    CATransform3D transform3=CATransform3DPerspect(concat3, CGPointMake(-self.bounds.size.width/2+currentOffset/2, self.bounds.size.height), 5000.0f);
//    
//    //添加变幻特效
//    lastView.layer.transform=transform3;
    
    
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //改变选中页序号
    [self changeIndex];
    NSArray *_viewArray = @[backView,backView1];
    //3D变幻恢复原状态
    for (UIView * view in _viewArray) {
        
        view.layer.transform=CATransform3DIdentity;
    }
}

-(void)changeIndex{
    
    //改变选中的标签
    _currentPage = scrollView.contentOffset.x/self.bounds.size.width;
}


@end
