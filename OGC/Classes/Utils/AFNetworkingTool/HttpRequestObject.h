//
//  HttpRequestObject.h
//  AFNetworkingTool
//
//  Created by 蔡卓越 on 15/9/25.
//  Copyright © 2015年 蔡卓越. All rights reserved.
//

#import <Foundation/Foundation.h>

  //请求方法
typedef NS_ENUM(NSInteger, MiniRequestMethod) {
    MiniRequestMethodGet = 0,
    MiniRequestMethodPost = 1,
};
  //请求响应类型
typedef NS_ENUM(NSInteger, MiniRequestResponseType) {
   MiniRequestResponseTypeJSON = 0,
   MiniRequestResponseTypeHTTP = 1,
};
   // 网络状态
typedef NS_ENUM(NSInteger, MiniNetworkStatus)  {
    MiniNetworkStatusUnknown = -1,   //未知网路
    MiniNetworkStatusReachable = 0,   //没有网络
    MiniNetworkStatusReachableViaWWAN = 1,   //2G/3G网络
    MiniNetworkStatusReachableViaWifi = 2,   //Wifi网络
};

//网络请求成功回调
typedef void (^MiniHttpRequestServiceSuccess)(id responseObj);

//网络请求失败回调
typedef void (^MiniHttpRequestServiceFailure)(NSError *error);

//网络状态回调
typedef void (^MiniNetworkStatusCallback)(MiniNetworkStatus networkStatus);

@interface HttpRequestObject : NSObject

@property (nonatomic, copy) NSString *requestUrl;

@property (nonatomic, copy) NSDictionary *requestParams;

@property (nonatomic, assign) NSTimeInterval requestTimeout;

@property (nonatomic, strong) NSURLSessionDataTask *requestOperation;

@property (nonatomic, copy) NSString *apiMethod;

@property (nonatomic, assign) MiniRequestMethod requestMethod;

@property (nonatomic, assign) MiniRequestResponseType responseType;

@property (nonatomic, copy) MiniHttpRequestServiceSuccess successBlock;

@property (nonatomic, copy) MiniHttpRequestServiceFailure failureBlock;

@end
