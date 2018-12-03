//
//  PrivacyPolicyView.h
//  Coin
//
//  Created by 郑勤宝 on 2018/11/30.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface PrivacyPolicyView : UIView<UIWebViewDelegate,WKNavigationDelegate>
@property (nonatomic, copy) NSString *htmlStr;

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic , strong)UIButton *confirmBtn;
@end
