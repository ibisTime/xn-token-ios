//
//  TLWXManager.m
//  ZHCustomer
//
//  Created by  蔡卓越 on 2017/1/9.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import "TLWXManager.h"

#import "AppConfig.h"
#import <CDCommon/ImageUtil.h>
#import "TLAlert.h"
//#import "WXApi.h"

@interface TLWXManager()
//<WXApiDelegate>


@end

@implementation TLWXManager

+ (instancetype)manager {

    static TLWXManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[TLWXManager alloc] init];
    });
    return manager;

}

- (void)registerApp {

//    [WXApi registerApp:[AppConfig config].wxKey];


}


//-(void) onReq:(BaseReq*)req {
//    
//    
//}

#pragma mark- 收到微信的回应
//-(void) onResp:(BaseResp*)resp {
//
////    if ([resp isKindOfClass:[PayResp class]]) { //支付
////
////        if (self.wxPay) {
////
////            self.wxPay(resp.errCode == 0,resp.errCode);
////
////        }
////
////    } else
//
//
//        if([resp isKindOfClass:[SendMessageToWXResp class]]) { //分享回调
//
//        if (self.wxShare) {
//
//            self.wxShare(resp.errCode == 0,resp.errCode);
//
//        }
//
//    }
//
//}
//
//+ (BOOL)judgeAndHintInstalllWX {
//
//    if (![WXApi isWXAppInstalled]) {
//
//        [TLAlert alertWithTitle:@"" msg:@"您还没有安装微信,前往安装" confirmMsg:@"好的" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
//
//        } confirm:^(UIAlertAction *action) {
//
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E5%BE%AE%E4%BF%A1/id414478124?mt=8"]];
//
//        }];
//        return NO;
//    }
//
//    return YES;
//
//}
//
//+ (void)wxShareWebPageWithScene:(int)scene title:(NSString *)title desc:(NSString *)desc url:(NSString *)url {
//
//    if (![WXApi isWXAppInstalled]) {
//
//        [TLAlert alertWithTitle:@"" msg:@"您还没有安装微信,前往安装" confirmMsg:@"好的" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
//
//        } confirm:^(UIAlertAction *action) {
//
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E5%BE%AE%E4%BF%A1/id414478124?mt=8"]];
//
//        }];
//        return;
//    }
//
//    // -- //
//    WXWebpageObject *webObj = [WXWebpageObject object];
//    webObj.webpageUrl = url;
//
//    //
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = title;
//    message.description = desc;
//    message.mediaObject = webObj;
//    [message setThumbImage:[UIImage imageNamed:@"zh_icon"]];
//
//    //
//    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
//    req.bText = NO;
//    req.message = message;
//    req.scene = scene;
//    [WXApi sendReq:req];
//
//
//}
//
//+ (void)wxShareWebPageWith:(NSString *)title desc:(NSString *)desc url:(NSString *)url {
//
//
//    [self wxShareWebPageWithScene:WXSceneTimeline title:title desc:desc url:url];
//
//
//}
//
//
//+ (void)wxShareImgWith:(NSString *)title scene:(int)scene desc:(NSString *)desc image:(UIImage *)img {
//
//
//    WXMediaMessage *message = [WXMediaMessage message];
//    //缩略图
//    //大小不能超过32K, 传logo33
//    [self zipImageWithImage:img begin:^{
//
//    } end:^(UIImage *lastImg) {
//
//        [message setThumbImage:lastImg];
//        WXImageObject *imgObj = [WXImageObject object];
//        imgObj.imageData = UIImagePNGRepresentation(img);
//        //
//        message.mediaObject = imgObj;
//        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
//        req.bText = NO;
//        req.message = message;
//        req.scene = scene;
//        [WXApi sendReq:req];
//
//    }];
//
//
//}


+ (void)zipImageWithImage:(UIImage *)image begin:(void(^)())beginHandler end:(void(^)(UIImage *))endHandler {
    
    if (beginHandler) {
        beginHandler();
    }
    
    UIImage *oldImg = image;
    
    
    if (!oldImg) {
        endHandler(nil);
        return;
    }
    
    
//    CGFloat H_W = oldImg.size.height/oldImg.size.width;
    
    //小于32kb的不压缩
    if (UIImageJPEGRepresentation(oldImg, 1).length < 32*1024) {
        
        if (endHandler) {
            endHandler(oldImg);
            return;
        }
        
    }

    
    //image 中size为point 但是这决定于 image的scale属性，scale == 1时 image pt == px
//    CGFloat zeroW_PX = 1080;
//    // 2X  1point = 4px;
//    // 3X  1point = 9px;
//    CGFloat imgScale = oldImg.scale;
//
//    //正常图片
//    //长图 H_W > 3.0
//    CGFloat animationW = zeroW_PX/imgScale;
//
//    if (oldImg.size.width <= animationW) {
//
//        if (endHandler) {
//            endHandler(oldImg);
//            return;
//        }
//
//    }
    
     CGFloat animationW = 100;
    CGFloat zipScale = oldImg.size.width/animationW;
    CGSize targetSize = CGSizeMake(animationW, oldImg.size.height/zipScale);
    
    
    //*****1.图片缩操作，减小像素数，和尺寸*******//
    //开画布
    UIGraphicsBeginImageContext(targetSize);
    
    [oldImg drawInRect:CGRectMake(0, 0, targetSize.width,targetSize.height)];
    //新图片
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭画布
    UIGraphicsEndImageContext();
    
    //*****2.图片压操作*******//
    UIImage *lastImg = [UIImage imageWithData:UIImageJPEGRepresentation(newImg, 0.7)];
    
    if (endHandler) {
        endHandler(lastImg);
    }
}


@end
