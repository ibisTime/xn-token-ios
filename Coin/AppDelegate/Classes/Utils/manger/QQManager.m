//
//  QQManager.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "QQManager.h"
//Manager
#import "AppConfig.h"
//Extension
#import <TencentOpenAPI/TencentOAuth.h>
//Macro
#import "AppMacro.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Category
#import "UIView+Responder.h"
#import "NSString+Extension.h"
#import "TLAlert.h"

@interface QQManager()<TencentSessionDelegate>
//
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
//授权内容
@property (nonatomic, strong) NSArray *permissions;

@end

@implementation QQManager

+ (instancetype)manager {
    
    static QQManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[QQManager alloc] init];
    });
    return manager;
}

- (void)registerApp {
    
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"" andDelegate:self];
    _tencentOAuth.redirectURI = @"www.qq.com";
    _permissions = [NSArray arrayWithObjects:@"get_user_info",@"get_simple_userinfo", @"add_t", nil];
    //QQ第三方授权登录，此处不需要。该方法执行后会直接跳转QQ进行快捷登录
    //[_tencentOAuth authorize:_permissions inSafari:NO];
}

- (void) onReq:(QQBaseReq*)req {
    
    
}

#pragma mark- 收到QQ的回应
- (void)onResp:(QQBaseResp*)resp {
    
    if (self.qqShare) {

        self.qqShare([resp.result isEqualToString:@"0"], [resp.result intValue]);
    }
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
            
        case EQQAPIAPPNOTREGISTED:
        {
            [TLAlert alertWithTitle:@"温馨提示" message:@"App未注册" confirmMsg:@"确定" confirmAction:^{
            }];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            [TLAlert alertWithTitle:@"温馨提示" message:@"发送参数错误" confirmMsg:@"确定" confirmAction:^{
            }];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        case EQQAPIQQNOTSUPPORTAPI:
        {
            [TLAlert alertWithTitle:@"温馨提示" message:@"您的设备未安装手机QQ" confirmMsg:@"确定" confirmAction:^{
            }];
            break;
        }
        
        case EQQAPISENDFAILD:
        {
            [TLAlert alertWithTitle:@"温馨提示" message:@"发送失败" confirmMsg:@"确定" confirmAction:^{
            }];
            break;
        }
        case EQQAPIVERSIONNEEDUPDATE:
        {
            [TLAlert alertWithTitle:@"温馨提示" message:@"当前QQ版本太低，需要更新" confirmMsg:@"确定" confirmAction:^{
            }];
            break;
        }
        default:
        {
            break;
        }
    }
}

#pragma mark - 分享
+ (void)qqShareWebPageWithScene:(int)scene
                          title:(NSString *)title
                           desc:(NSString *)desc
                            url:(NSString *)url
                   previewImage:(NSString *)previewImageUrl {
    
    if (![TencentOAuth iphoneQQInstalled]) {
        
        [TLAlert alertWithTitle:@"" msg:@"您还没有安装QQ,前往安装" confirmMsg:@"好的" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
            
        } confirm:^(UIAlertAction *action) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/qq/id444934666?mt=8"]];
        }];
        return;
    }
    
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:url]
                                title:title
                                description:desc
                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    //将内容分享到qzone
    //    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    
    [[QQManager manager] handleSendResult:sent];
}


+ (void)qqShareImageWithScene:(int)scene
                        title:(NSString *)title
                         desc:(NSString *)desc
                        image:(UIImage *)image {
    
    if (![TencentOAuth iphoneQQInstalled]) {
        
        [TLAlert alertWithTitle:@"" msg:@"您还没有安装QQ,前往安装" confirmMsg:@"好的" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
            
        } confirm:^(UIAlertAction *action) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/qq/id444934666?mt=8"]];
        }];
        return;
    }
    
    NSString *shareTitle = PASS_NULL_TO_NIL(title).length > 0 ? title : @"链接社";
    NSString *shareDesc = PASS_NULL_TO_NIL(desc).length > 0 ? desc : @"欢迎使用链接社";
    
    NSData *imgData = [self imageWithImage:image scaledToSize:CGSizeMake(image.size.width, image.size.height)];
    
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
                                               previewImageData:imgData
                                                          title:shareTitle
                                                    description:shareDesc];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    [[QQManager manager] handleSendResult:sent];

}

+ (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}

#pragma mark - 登录

//登录功能没添加，但调用TencentOAuth相关方法进行分享必须添加<TencentSessionDelegate>，则以下方法必须实现，尽管并不需要实际使用它们
//登录成功
- (void)tencentDidLogin
{
    //    _labelTitle.text = @"登录完成";
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        // 记录登录用户的OpenID、Token以及过期时间
        //        _labelAccessToken.text = _tencentOAuth.accessToken;
    }
    else
    {
        //        _labelAccessToken.text = @"登录不成功 没有获取accesstoken";
    }
}


//非网络错误导致登录失败
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        //        _labelTitle.text = @"用户取消登录";
    }
    else
    {
        //        _labelTitle.text = @"登录失败";
    }
}

//网络错误导致登录失败
- (void)tencentDidNotNetWork
{
    //    _labelTitle.text=@"无网络连接，请设置网络";
}

@end
