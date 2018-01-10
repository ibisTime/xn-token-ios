//
//  WebVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "WebVC.h"
#import <WebKit/WebKit.h>
#import "TLProgressHUD.h"
#import "ShareView.h"
#import "TLWXManager.h"

@interface WebVC ()<WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *currentWebView;
@end

@implementation WebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
    
    // ************* js
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    webConfig.userContentController = userContentController;

    //
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
//  preferences.minimumFontSize = 40.0;
    webConfig.preferences = preferences;
    
//    [userContentController addScriptMessageHandler:self name:@"Share"];


    //*****************
    
    WKWebView *webV = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) configuration:webConfig];
    [self.view addSubview:webV];
    webV.navigationDelegate = self;
    self.currentWebView = webV;
    
    NSURL *url = [[NSURL alloc] initWithString:self.url];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    
    [webV loadRequest:req];
    
    //
    if (self.canSendWX) {
        
        [self addTestMask];

    }
    
}


#pragma mark- 收到js方法
// js 调用oc方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    //     [userContentController addScriptMessageHandler:self name:@"Share"];
    //  相当于          window.webkit.messageHandlers.Share.postMessage({title:'测试分享的标题',content:'测试分享的内容',url:'https://github.com/maying1992'});
    // window.webkit.messageHandlers.Share 添加了一个 Share
    //
//    NSString *name =  message.name;
//    id body = message.body;
    
}


- (void)addTestMask {
    
    UIControl *maskCtrl = [[UIControl alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:maskCtrl];
    [maskCtrl addTarget:self action:@selector(saveOrShare) forControlEvents:UIControlEventTouchUpInside];
    
    //手势实验
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWeb)];
//    [self.currentWebView addGestureRecognizer:tap];
    
}

- (void)tapWeb {
    
    
    
}

- (void)saveOrShare {
    
    
    UIImage *image = [self screenshotForView:self.currentWebView];

    //1.分享到微信
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"选择您要进行的操作"
                                                                       message:nil
                                                           preferredStyle:UIAlertControllerStyleActionSheet];
    
    //分享给朋友
  UIAlertAction *friendAction =  [UIAlertAction actionWithTitle:@"分享给朋友"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * _Nonnull action) {
                               
                               [TLWXManager wxShareImgWith:@"图片" scene:WXSceneSession desc:@"图片" image:image];

                           }];

    
    //分享到朋友圈
    UIAlertAction *friendTimelineAction =  [UIAlertAction actionWithTitle:@"分享到朋友圈"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              
                                                              [TLWXManager wxShareImgWith:@"图片" scene:WXSceneTimeline desc:@"图片" image:image];
                                                              
                                                          }];
    
    
    //保存到相册
    UIAlertAction *saveAction =  [UIAlertAction actionWithTitle:@"保存到相册"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                                      
                                                                      [TLProgressHUD showWithStatus:nil]; UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
                                                                      
                                                                      
                                                                  }];
    
    //取消
    UIAlertAction *cancelAction =  [UIAlertAction actionWithTitle:@"取消"
                                                          style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            
                                                            
                                                        }];
    
    
    
    [alertCtrl addAction:friendAction];
    [alertCtrl addAction:friendTimelineAction];
    [alertCtrl addAction:saveAction];
    [alertCtrl addAction:cancelAction];
    [self presentViewController:alertCtrl animated:YES completion:nil];
    
    //
    [[TLWXManager manager] setWxShare:^(BOOL isSuccess, int errorCode) {
        
        if (isSuccess) {
            
            [TLAlert alertWithInfo:@"分享成功"];
            
        } else {
            
            [TLAlert alertWithInfo:@"分享失败"];

        }
        
    }];

}



- (void)remve:(UIView *)v {
    
    [v removeFromSuperview];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    [TLProgressHUD dismiss];
    if (!error) {
        
        [TLAlert alertWithInfo:@"保存成功"];

    } else {
        
        [TLAlert alertWithInfo:@"保存失败"];

    }
    
}



#pragma mark- 截图相关代码
//根据一个View生成一个image
- (UIImage *)screenshotForView:(UIView *)view {
    UIImage *image = nil;
    //判断View类型（一般不是滚动视图或者其子类的话内容不会超过一屏，当然如果超过了也可以通过修改frame来实现绘制）
//    if ([view.class isSubclassOfClass:[UIScrollView class]]) {
//        UIScrollView *scrView = (UIScrollView *)view;
//
//        //记录
//        CGPoint tempContentOffset = scrView.contentOffset;
//        CGRect tempFrame = scrView.frame;
//
//        scrView.contentOffset = CGPointZero;
//        scrView.frame = CGRectMake(0, 0, scrView.contentSize.width, scrView.contentSize.height);
//
//        image = [self screenshotForView:scrView size:scrView.frame.size];
//        scrView.contentOffset = tempContentOffset;
//        scrView.frame = tempFrame;
//
//    } else {
    
        image = [self screenshotForView:view size:view.frame.size];
        
//    }
    
    return image;
}

- (UIImage *)screenshotForView:(UIView *)view size:(CGSize)size {
    
    UIImage *image = nil;

    //1. 第一种方法
//    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
//    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    //2. 第二种
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:false];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}




- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    
    [TLProgressHUD dismiss];
    [TLAlert alertWithError:@"加载失败"];
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [TLProgressHUD show];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [TLProgressHUD dismiss];

    });
    
    if (self.canSendWX ||( self.title && self.title.length >0) ) {
        
        return;
        
    }
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable string, NSError * _Nullable error) {
        
        self.title = string;
    }];
}

@end
