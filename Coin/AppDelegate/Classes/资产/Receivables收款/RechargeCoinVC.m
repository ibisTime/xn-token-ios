//
//  RechargeCoinVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "RechargeCoinVC.h"

#import "UIButton+EnLargeEdge.h"
#import "NSString+CGSize.h"
#import "UILabel+Extension.h"
#import "UIBarButtonItem+convience.h"

#import "SGQRCodeGenerateManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "BillVC.h"
@interface RechargeCoinVC ()

@property (nonatomic, strong) UIView *topView;
//二维码
@property (nonatomic, strong) UIView *qrView;
//地址
@property (nonatomic, strong) UIView *addressView;

@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic ,strong) UIButton *buildButton;

@property (nonatomic ,strong) UIButton *saveButton;
@property (nonatomic, strong)  UIImageView *qrIV;
@end

@implementation RechargeCoinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kHexColor(@"#F1F2F5");
    self.title = [LangSwitcher switchLang:@"收款" key:nil];
    //提示框
//    [self initTopView];
    //二维码
    [self initQRView];
    //地址
    [self initAddressView];
    //记录
    [self addRecodeItem];
    
}

#pragma mark - Init

- (void)initTopView {
    
    CGFloat topH = kScreenWidth > 375 ? kHeight(50): 50;

    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, topH)];

    self.topView.backgroundColor = kWhiteColor;

    [self.view addSubview:self.topView];
    
    UIButton *cancelBtn = [UIButton buttonWithImageName:@"返回1"];
    cancelBtn.frame = CGRectMake(12, kStatusBarHeight, 60, 30);
    [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelBtn setEnlargeEdge:15];
    
    [self.view addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.width.height.equalTo(@15);
        make.centerY.equalTo(@0);
        make.right.equalTo(@(-15));

    }];
    
    
    UILabel *promptLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kAppCustomMainColor font:12.0];
    NSString *address;
    if (self.currency.symbol) {
        address = self.currency.symbol;
    }else{
        address = self.currency.currency;
        
        
    }
    NSString *currency = address;

//    promptLbl.text = [NSString stringWithFormat:@"%@钱包地址禁止充值除%@之外的其他资产, 任何%@资产充值将不可找回",currency,currency,currency];
//    promptLbl.text = [LangSwitcher switchLang: promptLbl.text key:nil];
    promptLbl.frame = CGRectMake(0, 0, kScreenWidth, 50);
    
    promptLbl.numberOfLines = 0;
    
//    [self.topView addSubview:promptLbl];
//    [promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(@15);
//        make.right.equalTo(cancelBtn.mas_left).offset(-10);
//        make.height.equalTo(@50);
//        make.top.equalTo(@0);
//
//    }];
}

- (void)initQRView {
    
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.qrView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topView.yy, kScreenWidth, 275)];

     UILabel *lab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:16];
    [self.qrView addSubview:lab];

    lab.text = [LangSwitcher switchLang:@"我的收款地址" key:nil];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.qrView.mas_top).offset(20);
        make.centerX.equalTo(self.qrView.mas_centerX);
     
    }];
//    self.qrView.backgroundColor = kHexColor(@"#F1F2F5");
    UIImageView *bgImage = [[UIImageView alloc] init];
    [self.qrView addSubview:bgImage];
    self.bgImage = bgImage;
    bgImage.image = kImage(@"二维码框");
    bgImage.layer.cornerRadius=5;
    bgImage.layer.shadowOpacity = 0.22;// 阴影透明度
    bgImage.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    bgImage.layer.shadowRadius=3;// 阴影扩散的范围控制
    bgImage.layer.shadowOffset=CGSizeMake(1, 1);// 阴影的范围
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@62);
        make.centerX.equalTo(self.qrView.mas_centerX);
//        make.left.equalTo(@(kWidth(45)));
        make.width.height.equalTo(@285);
    }];
    
    UIView *view = [UIView new];
    [bgImage addSubview:view];
    view.backgroundColor = kWhiteColor;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@26);
        make.left.equalTo(@26);
        make.width.height.equalTo(@233);
    }];
    [self.view addSubview:self.qrView];
    //二维码
    UIImageView *qrIV = [[UIImageView alloc] init];
    self.qrIV = qrIV;
    NSString *address ;
    
    if (self.currency.symbol) {
        address = self.currency.address;
    }else{
        address = self.currency.coinAddress;

        
    }
    CoinModel * coin = [CoinUtil getCoinModel:self.currency.currency.length > 0 ? self.currency.currency : self.currency.symbol];

    [qrIV sd_setImageWithURL:[NSURL URLWithString:[coin.pic1 convertImageUrl]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        qrIV.image = [self generateWithLogoQRCodeData:address logoImageName:image logoScaleToSuperView:0.2];

    }];
//    qrIV.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:address imageViewWidth:200];
    [view addSubview:qrIV];
    [qrIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@17);
        make.left.equalTo(view.mas_left).offset(17);
        make.width.height.equalTo(@200);
        
    }];

}

- (UIImage *)generateWithLogoQRCodeData:(NSString *)data logoImageName:(UIImage *)logoImageName logoScaleToSuperView:(CGFloat)logoScaleToSuperView {
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *string_data = data;
    // 将字符串转换成 NSdata (虽然二维码本质上是字符串, 但是这里需要转换, 不转换就崩溃)
    NSData *qrImageData = [string_data dataUsingEncoding:NSUTF8StringEncoding];
    
    // 设置过滤器的输入值, KVC赋值
    [filter setValue:qrImageData forKey:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    
    // 4、将CIImage类型转成UIImage类型
    UIImage *start_image = [UIImage imageWithCIImage:outputImage];
    
    // - - - - - - - - - - - - - - - - 添加中间小图标 - - - - - - - - - - - - - - - -
    // 5、开启绘图, 获取图形上下文 (上下文的大小, 就是二维码的大小)
    UIGraphicsBeginImageContext(start_image.size);
    
    // 把二维码图片画上去 (这里是以图形上下文, 左上角为(0,0)点
    [start_image drawInRect:CGRectMake(0, 0, start_image.size.width, start_image.size.height)];
    
    // 再把小图片画上去
    UIImage *icon_imageName = logoImageName;
    UIImage *icon_image = logoImageName;
    CGFloat icon_imageW = start_image.size.width * logoScaleToSuperView;
    CGFloat icon_imageH = start_image.size.height * logoScaleToSuperView;
    CGFloat icon_imageX = (start_image.size.width - icon_imageW) * 0.5;
    CGFloat icon_imageY = (start_image.size.height - icon_imageH) * 0.5;
    
    [icon_image drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
    
    // 6、获取当前画得的这张图片
    UIImage *final_image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 7、关闭图形上下文
    UIGraphicsEndImageContext();
    
    return final_image;
}


- (void)initAddressView {
    
    self.addressView = [[UIView alloc] initWithFrame:CGRectMake(0, self.qrView.yy, kScreenWidth, 50)];
    self.addressView.backgroundColor = kHexColor(@"#F1F2F5");
    [self.view addSubview:self.addressView];
    
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.qrView.mas_bottom);
    }];
    
    
    //点击复制
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCopy)];
    [self.addressView addGestureRecognizer:tapGR];
    
//    //分割线
//    UIView *line = [[UIView alloc] init];
//    line.backgroundColor = kLineColor;
//    [self.addressView addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.right.equalTo(@0);
//        make.top.equalTo(@0);
//        make.height.equalTo(@0.5);
//
//    }];
    
    UILabel *textlbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    textlbl.text = [LangSwitcher switchLang:@"地址" key:nil];
    [self.addressView addSubview:textlbl];
    [textlbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@30);
        make.top.equalTo(self.bgImage.mas_bottom).offset(27);
//        make.top.equalTo(@0);
        
    }];
    
    UILabel *addressLbl = [UILabel labelWithBackgroundColor:kHexColor(@"#FDFEFF") textColor:kTextColor font:14.0];
    addressLbl.numberOfLines = 0;
    NSString *address ;
    if (self.currency.symbol) {
        address = self.currency.address;
    }else{
        address = self.currency.coinAddress;
        
        
    }
    addressLbl.text = [NSString stringWithFormat:@"%@", address];
    [self.view addSubview:addressLbl];
    addressLbl.numberOfLines = 0;
    addressLbl.layer.cornerRadius=5;
    addressLbl.layer.shadowOpacity = 0.22;// 阴影透明度
    addressLbl.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    addressLbl.layer.shadowRadius=3;// 阴影扩散的范围控制
    addressLbl.layer.shadowOffset=CGSizeMake(1, 1);// 阴影的范围
    [addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(30);
        make.top.equalTo(textlbl.mas_bottom).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.height.equalTo(@50);
    }];
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = kWhiteColor;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(addressLbl.mas_bottom).offset(32);
        make.right.equalTo(self.view.mas_right).offset(0);

        make.bottom.equalTo(self.view.mas_bottom).offset(-kBottomInsetHeight);
        
    }];
    self.buildButton = [UIButton buttonWithImageName:nil cornerRadius:6];
    NSString *text =  [LangSwitcher switchLang:@"复制收款地址" key:nil];
    //     = NSLocalizedString(@"创建钱包", nil);
    
    [self.buildButton setTitle:text forState:UIControlStateNormal];
    self.buildButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.buildButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.buildButton addTarget:self action:@selector(clickCopyAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.buildButton setBackgroundColor:kHexColor(@"0848DF") forState:UIControlStateNormal];
    [bottomView addSubview:self.buildButton];
    [self.buildButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(6);
        make.right.equalTo(bottomView.mas_right).offset(-30);
        make.left.equalTo(bottomView.mas_left).offset(30);
        make.height.equalTo(@48);
        
    }];
    
    self.saveButton = [UIButton buttonWithImageName:nil cornerRadius:6];
    NSString *text1 =  [LangSwitcher switchLang:@"保存二维码" key:nil];
    //     = NSLocalizedString(@"创建钱包", nil);
    
    [self.saveButton setTitle:text1 forState:UIControlStateNormal];
    self.saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.saveButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveCode) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton setBackgroundColor:kHexColor(@"0848DF") forState:UIControlStateNormal];
    [bottomView addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buildButton.mas_bottom).offset(6);
        make.right.equalTo(bottomView.mas_right).offset(-30);
        make.left.equalTo(bottomView.mas_left).offset(30);
        make.height.equalTo(@48);
        
    }];
}


- (void)saveCode
{
    
    CGRect frame = self.view.frame;
    UIGraphicsBeginImageContextWithOptions(self.view.size, NO, [[UIScreen mainScreen] scale]);

    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:contextRef];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    

    
       UIImageWriteToSavedPhotosAlbum(image, self, @selector(image: didFinishSavingWithError: contextInfo:), nil);
    
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
  error ? [TLAlert alertWithError:[LangSwitcher switchLang:@"保存失败" key:nil]] : [TLAlert alertWithSucces:[LangSwitcher switchLang:@"保存成功" key:nil]];}

- (void)addRecodeItem {
//    [UIBarButtonItem addLeftItemWithImageName:@"返回1" frame:CGRectMake(0, 0, 40, 44) vc:self action:@selector(backTop)];
//    [UIBarButtonItem addLeftItemWithTitle:[LangSwitcher switchLang:@"记录" key:nil]
//                                titleColor:kTextColor
//                                     frame:CGRectMake(0, 0, 40, 44)
//                                        vc:self
//                                    action:@selector(lookBillRecord)];
//    [UIBarButtonItem adRightItemWithImageName:@"记录" frame:CGRectMake(0, 0, 40, 44) vc:self action:@selector(lookBillRecord)];
//    [UIBarButtonItem addRightItemWithImageName:@"记录" frame:CGRectMake(0, 0, 40, 44) vc:self action:@selector(lookBillRecord)];
}

#pragma mark - Events
- (void)clickCancel {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.qrView.y = 0;
        
        self.addressView.y = self.qrView.yy;
        
    }];
}

- (void)clickCopyAddress {
    
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    NSString *address ;
    if (self.currency.symbol) {
        address = self.currency.address;
    }else{
        address = self.currency.coinAddress;
        
        
    }
    pasteBoard.string = address;
    
    if (pasteBoard == nil) {
        
        [TLAlert alertWithError:@"复制失败, 请重新复制"];
        
    } else {
        
        [TLAlert alertWithSucces:[LangSwitcher switchLang:@"复制成功" key:nil]];
    }
}
- (void)backTop
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)lookBillRecord {
    
    BillVC *billVC = [BillVC new];
    
    billVC.accountNumber = self.currency.accountNumber;
    
    billVC.billType = BillTypeRecharge;

    [self.navigationController pushViewController:billVC animated:YES];
}

- (void)clickCopy {
    
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    NSString *address ;
    if (self.currency.symbol) {
        address = self.currency.address;
    }else{
        address = self.currency.coinAddress;
        
        
    }
    pasteBoard.string = address;
    
    if (pasteBoard == nil) {
        
        [TLAlert alertWithError:@"复制失败, 请重新复制"];
        
    } else {
        
        [TLAlert alertWithSucces:[LangSwitcher switchLang:@"复制成功" key:nil]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
