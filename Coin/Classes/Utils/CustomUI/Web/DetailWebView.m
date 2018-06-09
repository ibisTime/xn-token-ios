//
//  DetailWebView.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/17.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "DetailWebView.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import "PYPhotoBrowseView.h"
#import "PYPhotoView.h"
#import "PYPhoto.h"

#import <objc/runtime.h>

#import "UIView+Responder.h"
#import "NSString+Extension.h"
#import "TLAlert.h"

@interface DetailWebView ()<WKNavigationDelegate, PYPhotoBrowseViewDelegate>


@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *imageViewArr;

@end

@implementation DetailWebView

static char imgUrlArrayKey;

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        //        [self initScrollView];
        
        [self initWebView];
        
    }
    
    return self;
}

#pragma mark - Init

- (void)setMethod:(NSArray *)imgUrlArray {
    objc_setAssociatedObject(self, &imgUrlArrayKey, imgUrlArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)getImgUrlArray {
    
    return objc_getAssociatedObject(self, &imgUrlArrayKey);
}

- (void)initScrollView {
    
    _scrollView = [[UIScrollView alloc]init];
    
    [self addSubview:_scrollView];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
        
    }];
}

- (void)initWebView {
    
    NSString *jS = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'); meta.setAttribute('width', %lf); document.getElementsByTagName('head')[0].appendChild(meta);",kScreenWidth];
    
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *wkUCC = [WKUserContentController new];
    
    [wkUCC addUserScript:wkUserScript];
    
    WKWebViewConfiguration *wkConfig = [WKWebViewConfiguration new];
    
    wkConfig.userContentController = wkUCC;
    
    NSLog(@"width = %lf, height = %lf", self.width, self.height);
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) configuration:wkConfig];
    
    _webView.backgroundColor = kWhiteColor;
    
    _webView.navigationDelegate = self;
    
    _webView.allowsBackForwardNavigationGestures = YES;
    
    [self addSubview:_webView];
    
}

- (void)loadWebWithString:(NSString *)string {
    
    NSString *html = [NSString stringWithFormat:@"<head><style>img{width:%lfpx !important;height:auto;margin: 0px auto;} p{word-wrap:break-word;overflow:hidden;}</style></head>%@",kScreenWidth - 16, string];
    
    [_webView loadHTMLString:html baseURL:nil];
}

#pragma mark - Func

/*
 
 *通过js获取htlm中图片url
 
 */

-(NSArray *)getImageUrlByJS:(WKWebView *)wkWebView

{
    
    //js方法遍历图片添加点击事件返回图片个数
    
    static  NSString * const jsGetImages = @"function getImages(){var objs = document.getElementsByTagName(\"img\");var imgUrlStr='';for(var i=0;i<objs.length;i++){if(i==0){if(objs[i].alt==''){imgUrlStr=objs[i].src;}}else{if(objs[i].alt==''){imgUrlStr+='#'+objs[i].src;}}objs[i].onclick=function(){ if(this.alt==''){document.location=\"myweb:imageClick:\"+this.src;}};};return imgUrlStr;};";
    
    //用js获取全部图片
    
    [wkWebView evaluateJavaScript:jsGetImages completionHandler:^(id Result, NSError * error) {
        
        NSLog(@"js___Result==%@",Result);
        
        NSLog(@"js___Error -> %@", error);
        
    }];
    
    NSString *js2=@"getImages()";
    
    __block NSArray *array=[NSArray array];
    
    [wkWebView evaluateJavaScript:js2 completionHandler:^(id Result, NSError * error) {
        
        NSLog(@"js2__Result==%@",Result);
        
        NSLog(@"js2__Error -> %@", error);
        
        NSString *result=[NSString stringWithFormat:@"%@",Result];
        
        if([result hasPrefix:@"#"])
            
        {
            result = [result substringFromIndex:1];
        }
        
        NSLog(@"result===%@",result);
        
        array = [result componentsSeparatedByString:@"#"];
        
        NSLog(@"array====%@",array);
        
        [self setMethod:array];
        
        //创建图片视图数组
        self.imageViewArr = [NSMutableArray array];
        
        for (int i = 0; i < array.count; i++) {
            
            PYPhotoView *photoView = [[PYPhotoView alloc] init];
            
            PYPhoto *photo = [PYPhoto photoWithOriginalUrl:[array[i] convertImageUrl]];
            
            photoView.photo = photo;
            
            [self.imageViewArr addObject:photoView];
        }
        
    }];
    
    return array;
    
}

//显示大图

-(BOOL)showBigImage:(NSURLRequest *)request {
    
    //将url转换为string
    
    NSString *requestString = [[request URL] absoluteString];
    
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    
    if ([requestString hasPrefix:@"myweb:imageClick:"]) {
        
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        
        NSLog(@"image url------%@", imageUrl);
        
        NSArray *imgUrlArr=[self getImgUrlArray];
        
        //当前选择哪张图片
        NSInteger index=0;
        
        for (NSInteger i=0; i<[imgUrlArr count]; i++) {
            
            if([imageUrl isEqualToString:imgUrlArr[i]]) {
                
                index=i;
                
                break;
            }
        }
        
        //创建图片浏览器
        PYPhotoBrowseView *photoBrowseView = [[PYPhotoBrowseView alloc] init];
        
        //frameFormWindow
        photoBrowseView.frameFormWindow = CGRectMake(kScreenWidth/2.0, kScreenHeight/2.0, 0, 0);
        //frameToWindow
        photoBrowseView.frameToWindow = CGRectMake(kScreenWidth/2.0, kScreenHeight/2.0, 0, 0);
    
        photoBrowseView.imagesURL = imgUrlArr;
        
//        photoBrowseView.sourceImgageViews = [self.imageViewArr copy];
        
        photoBrowseView.currentIndex = index;
        
        photoBrowseView.delegate = self;

        [photoBrowseView show];
        
        return NO;
        
    }
    
    return YES;
    
}

#pragma mark - PYPhotoBrowseViewDelegate
- (void)photoBrowseView:(PYPhotoBrowseView *)photoBrowseView didLongPressImage:(UIImage *)image index:(NSInteger)index {

    UIAlertController *actionAheet = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *savePhotoAction = [UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image: didFinishSavingWithError: contextInfo:), nil);
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [actionAheet addAction:savePhotoAction];
    [actionAheet addAction:cancelAction];
    
    [self.viewController presentViewController:actionAheet animated:YES completion:nil];

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    error ? [TLAlert alertWithError:@"保存失败"] : [TLAlert alertWithSucces:@"保存成功"];
}

#pragma mark - WKWebViewDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable string, NSError * _Nullable error) {
        
        [self changeWebViewHeight:string];
    }];
    
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
    
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    
    //通过js获取htlm中图片url
    
    [self getImageUrlByJS:webView];
    
}

- (void)changeWebViewHeight:(NSString *)heightStr {
    
    CGFloat height = [heightStr integerValue];
    
    // 改变webView和scrollView的高度
    
    _webView.scrollView.contentSize = CGSizeMake(kScreenWidth, height);
    _webView.scrollView.height = height;
    _webView.height = height;
    
    [self sizeToFit];
    self.scrollView.bounces = NO;
    self.scrollView.scrollEnabled = NO;
    
    if (_webViewBlock) {
        
        _webViewBlock(height);
    }
    
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    [self showBigImage:navigationAction.request];
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

@end
