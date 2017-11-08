//
//  HttpRequestTool.m
//  AFNetworkingTool
//
//  Created by 蔡卓越 on 15/9/25.
//  Copyright © 2015年 蔡卓越. All rights reserved.
//

#import "HttpRequestTool.h"
#import "HttpRequestService.h"
#import "AFNetworking.h"
#import "NSObject+Custom.h"

#import <MBProgressHUD.h>

@interface HttpRequestTool () <MBProgressHUDDelegate>


@property (nonatomic, strong) NSMutableDictionary *requestList;

@property (nonatomic, strong) MBProgressHUD *progressHUD;

@property (nonatomic, copy) NSString *apiMethod;

@end

@implementation HttpRequestTool {
    

}

+ (HttpRequestTool *)shareManage {
    
    static HttpRequestTool *httpRequestTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        httpRequestTool = [[super alloc] init];
        
    });
    return httpRequestTool;
}

- (instancetype)init {
    if (self = [super init]) {
        _requestList = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSTimeInterval)timeOut {
    if (_timeOut == 0) {
        _timeOut = 15;
    }
    return _timeOut;
}

- (NSDictionary *)parameters:(NSDictionary *)parameters {
    
    NSMutableDictionary *params = [parameters mutableCopy];
    
    params[@"systemCode"] = [AppConfig config].systemCode;
    
    if (self.isUploadCompanyCode) {
        
        params[@"companyCode"] = [AppConfig config].companyCode;
        
    }
    
    if (!self.kind || self.kind.length <= 0 ) {
        
        params[@"kind"] = @"f2";
        
    }
    
    //将参数转为JSON格式
    NSString *jsonStr = [params convertToString];
    
    params = [[NSMutableDictionary alloc] initWithCapacity:2];
    params[@"json"] = jsonStr;
    params[@"code"] = self.apiMethod;
    
    return [params copy];
}

- (void)asynCheckNetworkStatus:(MiniNetworkStatusCallback)networkBlock {
    
    AFNetworkReachabilityManager *reachabilityManage = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManage startMonitoring];
    [reachabilityManage setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusUnknown) {
            networkBlock(MiniNetworkStatusUnknown);
        }
        else if (status == AFNetworkReachabilityStatusNotReachable) {
            networkBlock(MiniNetworkStatusReachable);
        }
        else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            networkBlock(MiniNetworkStatusReachableViaWWAN);
        }
        else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            networkBlock(MiniNetworkStatusReachableViaWifi);
        }
    }];
}

- (void)asynGetWithBaseUrl:(NSString *)baseUrl apiMethod:(NSString *)apiMethod parameters:(NSDictionary *)params success:(MiniHttpRequestServiceSuccess)successBlock failure:(MiniHttpRequestServiceFailure)failure {
    
    HttpRequestObject *requestObj = [[HttpRequestObject alloc] init];
    if (baseUrl) {
        requestObj.requestUrl = baseUrl;
    }
    else {
        requestObj.requestUrl = self.baseUrl;
    }

    requestObj.requestTimeout = self.timeOut;
    requestObj.requestParams = params;
    requestObj.apiMethod = apiMethod;
    requestObj.requestMethod = MiniRequestMethodGet;
    requestObj.responseType = MiniRequestResponseTypeJSON;
    requestObj.successBlock = successBlock;
    requestObj.failureBlock = failure;
    _requestList[apiMethod] = requestObj;
    
    [HttpRequestService asynRequest:requestObj success:^(id responseObj) {
        [_requestList removeObjectForKey:apiMethod];
        successBlock(responseObj);
        
    } failure:^(NSError *error) {
        [_requestList removeObjectForKey:apiMethod];
        failure(error);
    }];
}

- (void)asynPostWithBaseUrl:(NSString *)baseUrl apiMethod:(NSString *)apiMethod parameters:(NSDictionary *)params success:(MiniHttpRequestServiceSuccess)successBlock failure:(MiniHttpRequestServiceFailure)failure {
    
    HttpRequestObject *requestObj = [[HttpRequestObject alloc] init];
    if (baseUrl) {
        requestObj.requestUrl = baseUrl;
    }
    else {
        requestObj.requestUrl = self.baseUrl;
    }
    self.apiMethod = apiMethod;

    requestObj.requestTimeout = self.timeOut;
    
    requestObj.requestParams = [self parameters:params];
    requestObj.apiMethod = apiMethod;
    requestObj.requestMethod = MiniRequestMethodPost;
    requestObj.responseType = MiniRequestResponseTypeJSON;
    requestObj.successBlock = successBlock;
    requestObj.failureBlock = failure;
    _requestList[apiMethod] = requestObj;
    
    [HttpRequestService asynRequest:requestObj success:^(id responseObj) {
        
        if ([responseObj[@"errorCode"] isEqual:@"4"]) {
            //token错误  4
            
            [self showTextOnly:@"为了您的账户安全，请重新登录"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];

            return;
            
        }
        
        if([responseObj[@"errorCode"] isEqual:@"0"]){ //成功
            
            successBlock(responseObj);

        } else if(self.isShowMsg) { //异常也是失败
            
            [self showTextOnly:responseObj[@"errorInfo"]];
            
        }
        
        [_requestList removeObjectForKey:apiMethod];
        
    } failure:^(NSError *error) {
        
        if (self.isShowMsg) {
            
            [self showTextOnly:@"您的网络不通畅"];
            
        }
        [_requestList removeObjectForKey:apiMethod];
        failure(error);
    }];
}

- (void)asynPostUploadWithUrl:(NSString *)baseurl apiMethod:(NSString *)apiMethod parameters:(NSDictionary *)parameters fileData:(NSData *)data success:(MiniHttpRequestServiceSuccess)success failure:(MiniHttpRequestServiceFailure)failure {
    
    HttpRequestObject *requestObj = [[HttpRequestObject alloc] init];
    if (baseurl)
    {
        requestObj.requestUrl = baseurl;
    }
    else
    {
        requestObj.requestUrl = self.baseUrl;
    }
    requestObj.requestTimeout = self.timeOut;
    requestObj.requestParams = parameters;
    requestObj.apiMethod = apiMethod;
    requestObj.requestMethod = MiniRequestMethodPost;
    requestObj.responseType = MiniRequestResponseTypeJSON;
    requestObj.successBlock = success;
    requestObj.failureBlock = failure;
    _requestList[apiMethod] = requestObj;
    
    [HttpRequestService uploadRequest:requestObj
                             fileData:data
                              success:^(id responseObj){
                                  [_requestList removeObjectForKey:apiMethod];
                                  success(responseObj);
                              }
                              failure:^(NSError *error){
                                  [_requestList removeObjectForKey:apiMethod];
                                  failure(error);
                              }];
    
}

- (void)resumeRequestWithApiMethid:(NSString*)apiMethod {
    
    HttpRequestObject *requestObj = _requestList[apiMethod];
    [requestObj.requestOperation resume];
}

- (void)suspendRequestWithApiMethid:(NSString*)apiMethod {
    
    HttpRequestObject *requestObj = _requestList[apiMethod];
    [requestObj.requestOperation suspend];
}

- (void)cancleRequestWithApiMethod:(NSString *)apiMethod {
    
    HttpRequestObject *requestObj = _requestList[apiMethod];
    [HttpRequestService cancleRequest:requestObj];
    [_requestList removeObjectForKey:apiMethod];
}

- (void)cancleAllRequest {
    
    for (NSString *apiMethod in [_requestList allKeys]) {
        HttpRequestObject *requestObj = _requestList[apiMethod];
        [HttpRequestService cancleRequest:requestObj];
        [_requestList removeObjectForKey:apiMethod];
    }
}

#pragma mark - show error message when debug
- (void)showTextOnly:(NSString *)text {
    
    if (_progressHUD) {
        return;
    }
    
    _progressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    _progressHUD.mode = MBProgressHUDModeText;
    
    _progressHUD.animationType = MBProgressHUDAnimationZoom;
    
    _progressHUD.delegate = self;
    _progressHUD.labelText = text;
    _progressHUD.margin = 10.f;
    _progressHUD.removeFromSuperViewOnHide = YES;
    _progressHUD.color = kBlackColor;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_progressHUD hide:YES];
        
        _progressHUD = nil;
    });
    
}






@end
