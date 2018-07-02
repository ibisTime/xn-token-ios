
#import "InvitationView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TLUIHeader.h"
#import <SVProgressHUD/SVProgressHUD.h>
@implementation InvitationView
{
    UIImageView *wechatImageView;
    NSString *urlStr;
}



-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 20)];
        lineView.backgroundColor = [UIColor redColor];
        [self addSubview:lineView];
        
        self.backgroundColor = [UIColor whiteColor];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"InfoNotification" object:nil];
        
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(40, SCREEN_WIDTH - 70, SCREEN_WIDTH - 140, 40);
        [button setTitle:@"保存二维码" forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];
        button.titleLabel.font = FONT(16);
        [button setBackgroundColor:[UIColor redColor]];
        [self addSubview:button];
        
        
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH - 20, SCREEN_WIDTH - 60, 20)];
//        label.text = @"保存二维码邀请好友注册代理";
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = FONT(13);
//        label.textColor = [uic];
//        [self addSubview:label];

    }
    return self;
    
}

- (void)InfoNotificationAction:(NSNotification *)notification{
    
    NSLog(@"%@",notification.userInfo);
    NSLog(@"---接收到通知---");
    urlStr = [NSString stringWithFormat:@"%@",notification.userInfo[@"code"]];
    // 1. 实例化二维码滤镜
    NSLog(@"======%@",urlStr);
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    ;//测试二维码地址,次二维码不能支付,需要配合服务器来二维码的地址(跟后台人员配合)
    NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 6. 将CIImage转换成UIImage，并放大显示 (此时获取到的二维码比较模糊,所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码)
    //            UIImage *codeImage = [UIImage imageWithCIImage:outputImage scale:1.0 orientation:UIImageOrientationUp];
    
    wechatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 40, SCREEN_WIDTH - 140, SCREEN_WIDTH - 140)];
    
    wechatImageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];//重绘二维码,使其显示清晰
    [self addSubview:wechatImageView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"InfoNotification" object:nil];
}


-(void)buttonClick
{
    [self loadImageFinished:wechatImageView.image];
}

- (void)loadImageFinished:(UIImage *)image
{
    __block ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    [lib writeImageToSavedPhotosAlbum:image.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        
//        NSLog(@"assetURL = %@, error = %@", assetURL, error);
        lib = nil;
        [SVProgressHUD setMinimumDismissTimeInterval:2];
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        
    }];
}



/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}



@end
