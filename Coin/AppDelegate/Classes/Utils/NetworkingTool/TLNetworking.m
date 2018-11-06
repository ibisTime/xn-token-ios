//
//  TLNetworking.m
//  WeRide
//
//  Created by  蔡卓越 on 2016/11/28.
//  Copyright © 2016年 trek. All rights reserved.
//

#import "TLNetworking.h"

#import "HttpLogger.h"
#import "TLProgressHUD.h"

#import <SVProgressHUD/SVProgressHUD.h>

@implementation TLNetworking

+ (AFHTTPSessionManager *)HTTPSessionManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer.timeoutInterval = 15.0;
    NSSet *set = manager.responseSerializer.acceptableContentTypes;
    
    set = [set setByAddingObject:@"text/plain"];
    set = [set setByAddingObject:@"text/html"];
    set = [set setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = set;
   manager.responseSerializer.acceptableContentTypes = [set setByAddingObject:@"text/plain"];
    
    return manager;
}

+ (NSString *)serveUrl {
    
    return [[AppConfig config] apiUrl];
    
}

//+ (NSString *)ipUrl {
//
//    return [[AppConfig config] ipUrl];
//    
//}



+ (NSString *)systemCode {
    
    return [AppConfig config].systemCode;
    
}

+ (NSString *)companyCode {

    return [AppConfig config].companyCode;
}

- (instancetype)init{

    if(self = [super init]){
    
       _manager = [[self class] HTTPSessionManager];
        _isShowMsg = YES;
        self.parameters = [NSMutableDictionary dictionary];
        self.isUploadToken = YES;
        
    }
    return self;

}


- (NSURLSessionDataTask *)postWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //如果想要设置其它 请求头信息 直接设置 HTTPSessionManager 的 requestSerializer 就可以了，不用直接设置 NSURLRequest
    
    if(self.showView){
    
        [TLProgressHUD show];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
   
        //动画效果
        [SVProgressHUD setDefaultAnimationType:(SVProgressHUDAnimationTypeFlat)];
        
        
    }
    
    if(self.code && self.code.length > 0){
    
        if (!(self.url && self.url.length > 0)) {
            
            self.url = [[self class] serveUrl];
        }
        
       
        
        if (self.isLocal == YES) {
            
        }else{
            if (self.isUploadToken && [TLUser user].token && [TLUser user].token.length > 0 ) {
                
                self.parameters[@"token"] = [TLUser user].token;
                
            }
            if (![_isShow isEqualToString:@"100"]) {
                
                self.parameters[@"systemCode"] = [[self class] systemCode];
                
            }
        }
        //
        switch ([LangSwitcher currentLangType]) {
            case LangTypeKorean:
                self.parameters[@"language"] = @"KO";
                
                break;
            case LangTypeEnglish:
                self.parameters[@"language"] = @"EN";
                
                break;
            case LangTypeSimple:
                self.parameters[@"language"] = @"ZH_CN";
                
                break;
                
            default:
                break;
        }
        
        if (self.ISparametArray == YES) {
            self.parameters[@"systemCode"] = nil;
            self.parameters[@"companyCode"] = nil;
              NSData *data = [NSJSONSerialization dataWithJSONObject:self.parameters options:NSJSONWritingPrettyPrinted error:nil];
            self.parameters = [NSMutableDictionary dictionaryWithCapacity:2];
            self.parameters[@"code"] = self.code;
            self.parameters[@"json"] = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }else{
            
            self.parameters[@"companyCode"] = [[self class] companyCode];
            
            NSData *data = [NSJSONSerialization dataWithJSONObject:self.parameters options:NSJSONWritingPrettyPrinted error:nil];
            self.parameters = [NSMutableDictionary dictionaryWithCapacity:2];
            self.parameters[@"code"] = self.code;
            self.parameters[@"json"] = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
        }
        
    }
    
    if (!self.url || !self.url.length) {
        NSLog(@"url 不存在啊");
        if ( self.showView) {
            [TLProgressHUD dismiss];
        }
        return nil;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
     [HttpLogger logDebugInfoWithRequest:request apiName:self.code requestParams:self.parameters httpMethod:@"POST"];
    if ([AppConfig config].runEnv != RunEnvRelease) {
        
        [HttpLogger logDebugInfoWithRequest:request apiName:self.code requestParams:self.parameters httpMethod:@"POST"];

    }
    
    return [self.manager POST:self.url parameters:self.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      
      [HttpLogger logDebugInfoWithResponse:task.response apiName:self.code resposeString:responseObject request:task.originalRequest error:nil];

      //打印JSON字符串
      [HttpLogger logJSONStringWithResponseObject:responseObject];
      if (!self.disableLog && [AppConfig config].runEnv != RunEnvRelease) {

          [HttpLogger logDebugInfoWithResponse:task.response apiName:self.code resposeString:responseObject request:task.originalRequest error:nil];

          //打印JSON字符串
          [HttpLogger logJSONStringWithResponseObject:responseObject];
      }
//      if(self.showView){
//
//          [TLProgressHUD dismiss];
//      }

        [TLProgressHUD dismiss];
      if([responseObject[@"errorCode"] isEqual:@"0"]){ //成功
          
          if(success){

              success(responseObject);
          }
          
      }
      else {

          
          if (failure) {
              failure(responseObject);
          }
          
          if ([responseObject[@"errorCode"] isEqual:@"4"]) {
              
              //token错误  4
              [TLAlert alertWithTitle:nil
                              message:[LangSwitcher switchLang:@"token信息已失效,请重新登录" key:nil]
                        confirmAction:^{
                  [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
              }];
              return;
              
          }
          
          if(self.isShowMsg) { //异常也是失败
              
              [TLAlert alertWithInfo:responseObject[@"errorInfo"]];

          }
      
      }
      
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
       if(self.showView){
           [TLProgressHUD dismiss];
       }
       
       if (self.isShowMsg) {
           
           [TLAlert alertWithInfo:@"当前网络不给力，请稍后再试或切换网络"];

       }
       
       if(failure){
           failure(error);
       }
       
   }];

    
}

//- (void)hundleSuccess:(id)responseObj {
//
//    if([responseObj[@"success"] isEqual:@1]){
//
//
//    }
//}


+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(id responseObject))success
                       failure: (void (^)(NSError *error))failure{
    
    AFHTTPSessionManager *manager = [self HTTPSessionManager];
    
    return [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success(responseObject);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(failure){
            
            failure(error);
            
        }
        
    }];


}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                       parameters:(NSDictionary *)parameters
                          success:(void (^)(id responseObject))success
                      abnormality:(void (^)(NSString *msg))abnormality
                          failure:(void (^)(NSError * _Nullable  error))failure;
{
    //先检查网络
    
    AFHTTPSessionManager *manager = [self HTTPSessionManager];
    
    return [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(failure){
            failure(error);
        }
        
    }];
    
}


//#pragma mark - GET
+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(NSString *msg,id data))success
                     abnormality:(void (^)())abnormality
                         failure:(void (^)(NSError *error))failure;
{
    AFHTTPSessionManager *manager = [self HTTPSessionManager];
    
    
    return [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(@"",responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
    
}



@end
